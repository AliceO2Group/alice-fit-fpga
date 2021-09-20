/*
Fast PM/TCM status report (all modules via IPbus/TCM)


g++ -g -Wall fit_gbt_status.cpp -o fit_gbt_status.run && ./fit_gbt_status.run
g++ -g -Wall fit_gbt_status.cpp -o fit_gbt_status.run &&  watch -c ./fit_gbt_status.run
 */
 
 #include <stdlib.h>
#include <chrono>
#include <iostream>
#include <time.h>
#include <string.h>
#include <math.h>
#include <fstream>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <sys/ioctl.h>
#include <unistd.h>

#include "ipbus_connection.h"
#include "pmtcm_map.h"

using namespace std; 
typedef chrono::high_resolution_clock Clock;

bool do_adjust = 0;
float noise_rate_set = 20000.0; //kHz

int main(int argc, char *argv[]) {
    printf("\n\n====================================================\n");
    printf(    "================ FIT GBT status ===============\n");
    printf("====================================================\n\n\n");
    
    ipbus_connection slow_control;
    slow_control.set_board_ip("172.20.75.180");
    slow_control.set_board_port(50001);
    if (slow_control.connect_to_board() < 0) {
	printf("Connection to board failed\n");
	return -1;
    }
	
	int act_iter=0;
	uint32_t ctrl_reg[16] = {0};
	uint32_t stat_reg[16] = {0};
	
	printf("\nIT FEEID  ADDR     BR_ON  RD_ON  BC_SYN  CRU    BRD    ERRORs      RATE_kHz   CNV_DRP    SEL_DRP");
	for(uint32_t pmtcm_iter = 0; pmtcm_iter < pmtcm_total; pmtcm_iter+=1){
		
		uint32_t curr_ctrl_addr = ctrl_addr + pmtcm_map[pmtcm_iter][1];
		uint32_t curr_stat_addr = stat_addr + pmtcm_map[pmtcm_iter][1];
		uint32_t curr_thrs_cal_addr = trhr_calib_ch0 + pmtcm_map[pmtcm_iter][1];

		bool is_tcm = (pmtcm_iter == 0);
		int res = 0;
		uint8_t reg_size = 16;
		
		printf("\n%02i %04x   [0x%04x]    %s   ",act_iter, pmtcm_map[pmtcm_iter][0], pmtcm_map[pmtcm_iter][1], pmtcm_map[pmtcm_iter][2]? "ON ":"OFF");
		if (pmtcm_map[pmtcm_iter][2] == 0) continue;
		
		
		slow_control.read_registers(ctrl_reg, reg_size, curr_ctrl_addr);
		
		//reset counters
		reg_size = 1;
		ctrl_reg[0] |= 1UL << 9;
		res = slow_control.write_registers(ctrl_reg, reg_size, curr_ctrl_addr);
		ctrl_reg[0] &= ~(1UL << 9);
		res = slow_control.write_registers(ctrl_reg, reg_size, curr_ctrl_addr);
		reg_size = 16;

		
		auto timer1 = Clock::now();
		slow_control.read_registers(stat_reg, reg_size, curr_stat_addr);
		
		bool is_force_idle = ctrl_reg[0]&(1<<22);
		uint8_t bc_sync = (stat_reg[0]&0xF00000)>>20;
		uint8_t rd_mode = (stat_reg[0]&0xF0000)>>16;
		uint8_t rd_cru_mode = (stat_reg[0]&0xF0000000)>>28;
		bool rd_mode_corr = (rd_mode == rd_cru_mode) || is_force_idle;
		uint16_t fsm_errs = (stat_reg[2]&0xFFFF0000)>>16;
		uint32_t gbt_cnt0 = stat_reg[5];
		uint32_t event_cnt0 = stat_reg[9] & 0xFFFF;
		uint16_t cnv_drop0 = stat_reg[3] & 0xFFFF;
		uint16_t sel_drop0 = stat_reg[4] & 0xFFFF;
		
		
		if (not is_force_idle) act_iter++;
		
		printf("%s   ", is_force_idle?"\x1b[31mOFF\x1b[0m":"\x1b[32mON \x1b[0m");
		printf("%s   ", bcsync_lbl[bc_sync]);
		printf("%s   ", run_lbl[rd_cru_mode]);
		printf("%s   ",rd_mode_corr?run_lbl_g[rd_mode]:run_lbl_r[rd_mode]);
		printf("%04x %s  ", fsm_errs, fsm_errs!=0?"\x1b[31mER\x1b[0m":"\x1b[32mOK \x1b[0m");
		
		if(fsm_errs > 0){
			for (int ibit = 0; ibit <15; ibit++) if((fsm_errs&(1<<ibit))>0) printf(" %i ", ibit);
		}
		
		usleep(1000);
		auto timer2 = Clock::now();
		slow_control.read_registers(stat_reg, reg_size, curr_stat_addr);
		uint32_t gbt_cnt1 = stat_reg[5];
		uint32_t event_cnt1 = stat_reg[9];
		uint16_t cnv_drop1 = stat_reg[3] & 0xFFFF;
		uint16_t sel_drop1 = stat_reg[4] & 0xFFFF;

		
		double read_time_s = double(std::chrono::duration_cast<std::chrono::nanoseconds>(timer2 - timer1).count())/1E9;
		float gbt_rate = (gbt_cnt1-gbt_cnt0)/read_time_s/1000.;
		float gbt_rate_noHB_khz = gbt_rate-11.248*4.;
		float event_rate_khz = (event_cnt1-event_cnt0)/read_time_s/1000.;
		float cnv_drp_rate_khz = (cnv_drop1-cnv_drop0)/read_time_s/1000.;
		float sel_drp_rate_khz = (sel_drop1-sel_drop0)/read_time_s/1000.;
		printf(" %8.2f ", event_rate_khz);
		//printf(" %8.2f ", gbt_rate_noHB_khz);
		printf(" %8.2f ", cnv_drp_rate_khz);
		printf(" %8.2f ", sel_drp_rate_khz);
		
		
		// adjusting noise rate
		int adjust = 0;
		if(rd_cru_mode > 0 and not is_force_idle)
		if(not is_tcm){
			ctrl_reg[0] = 0x000009C4;//2500
			reg_size = 1;
			res = slow_control.read_registers(ctrl_reg, reg_size, curr_thrs_cal_addr);
			
			//float rate_diff_hz = (noise_rate_set - event_rate_khz)*500.;
			float rate_diff_hz = (noise_rate_set - gbt_rate_noHB_khz)*500.;
			
			if ((rate_diff_hz > -500.)&&(rate_diff_hz < 500.)){adjust = 0;}else
			if (gbt_rate_noHB_khz < 0.01){adjust = -5;}else
			if ((gbt_rate_noHB_khz > 0.5)&&(rate_diff_hz < -500.)){adjust = 10; }else
			if ((gbt_rate_noHB_khz >= 0.01)&&(rate_diff_hz > 0.)){adjust = -1; }else
			if ((gbt_rate_noHB_khz >= 0.01)&&(rate_diff_hz < 0.)){adjust = 1; }else
			{adjust = 0; }
			
			ctrl_reg[0] += adjust;
			if (do_adjust)
			  res = slow_control.write_registers(ctrl_reg, reg_size, curr_thrs_cal_addr);
			
			printf("(%5i ", ctrl_reg[0]);
			printf("%2i) ", adjust);				
		}
		
	}
	
	printf("\n");

}
	
	
	
	
