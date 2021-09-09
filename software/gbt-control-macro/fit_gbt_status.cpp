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
	
	printf("\nIT FEEID  ADDR     BR_ON  RD_ON  BC_SYN  CRU    BRD    ERRORs    GBT_RT_kHz");
	for(uint32_t pmtcm_iter = 0; pmtcm_iter < pmtcm_total; pmtcm_iter+=1){
		
		uint32_t curr_ctrl_addr = ctrl_addr + pmtcm_map[pmtcm_iter][1];
		uint32_t curr_stat_addr = stat_addr + pmtcm_map[pmtcm_iter][1];
		bool is_tcm = (pmtcm_iter == 0);
		int res = 0;
		uint8_t reg_size = 16;
		
		printf("\n%02i %04x   [0x%04x]    %s   ",act_iter, pmtcm_map[pmtcm_iter][0], pmtcm_map[pmtcm_iter][1], pmtcm_map[pmtcm_iter][2]? "ON ":"OFF");
		if (pmtcm_map[pmtcm_iter][2] == 0) continue;
		
		
		slow_control.read_registers(ctrl_reg, reg_size, curr_ctrl_addr);
		auto timer1 = Clock::now();
		slow_control.read_registers(stat_reg, reg_size, curr_stat_addr);
		
		bool is_force_idle = ctrl_reg[0]&(1<<22);
		uint8_t bc_sync = (stat_reg[0]&0xF00000)>>20;
		uint8_t rd_mode = (stat_reg[0]&0xF0000)>>16;
		uint8_t rd_cru_mode = (stat_reg[0]&0xF0000000)>>28;
		bool rd_mode_corr = (rd_mode == rd_cru_mode) && (not is_force_idle);
		uint16_t fsm_errs = (stat_reg[2]&0xFFFF0000)>>16;
		uint32_t gbt_cnt0 = stat_reg[5];
		
		if (not is_force_idle) act_iter++;
		
		printf("%s   ", is_force_idle?"\x1b[31mOFF\x1b[0m":"\x1b[32mON \x1b[0m");
		printf("%s   ", bcsync_lbl[bc_sync]);
		printf("%s   ", run_lbl[rd_cru_mode]);
		printf("%s   ",rd_mode_corr?run_lbl_g[rd_mode]:run_lbl_r[rd_mode]);
		printf("%04x %s  ", fsm_errs, fsm_errs!=0?"\x1b[31mER\x1b[0m":"\x1b[32mOK \x1b[0m");
		
		usleep(100000);
		auto timer2 = Clock::now();
		slow_control.read_registers(stat_reg, reg_size, curr_stat_addr);
		uint32_t gbt_cnt1 = stat_reg[5];
		
		double read_time_s = double(std::chrono::duration_cast<std::chrono::nanoseconds>(timer2 - timer1).count())/1E9;
		float gbt_rate = (gbt_cnt1-gbt_cnt0)/read_time_s/1000.;
		printf(" %7.2f   ", gbt_rate);

	}
	printf("\n");

}
	
	
	
	
