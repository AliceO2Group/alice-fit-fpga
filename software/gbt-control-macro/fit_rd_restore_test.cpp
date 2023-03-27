/*
Test of RUN restore procedure
Set low PMs tresholds, and turning on/off force idle with random delay

g++ -g -Wall fit_rd_restore_test.cpp -o fit_rd_restore_test.run && ./fit_rd_restore_test.run
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

#include "ipbus_connection.h"
#include "pmtcm_map.h"

#include <unistd.h>

int main(int argc, char *argv[]) {
    printf("\n\n====================================================\n");
    printf(    "================ Readout RUN restore TEST ===============\n");
    printf("====================================================\n\n\n");
    
    ipbus_connection slow_control;
    slow_control.set_board_ip("172.20.75.180");
    slow_control.set_board_port(50001);
    if (slow_control.connect_to_board() < 0) {
	printf("Connection to board failed\n");
	return -1;
    }
	
	
	uint32_t ctrl_reg[16] = {0};
	
	//threshold calibration all modules
	const uint32_t trsh_val = 500;
	
	printf("\n\n-----------------------------------------------------------------\n");
	printf("Writing PMs treshold values ... \n\n");
	for(uint32_t pmtcm_iter = 0; pmtcm_iter < pmtcm_total; pmtcm_iter+=1){
		if (pmtcm_map[pmtcm_iter][2] == 0) continue;
		
		uint32_t curr_ctrl_addr = ctrl_addr + pmtcm_map[pmtcm_iter][1];
		uint32_t curr_thrs_cal_addr = trhr_calib_ch0 + pmtcm_map[pmtcm_iter][1];
		
		bool is_tcm = (pmtcm_iter == 0);
		int res = 0;
		uint8_t reg_size = 1;
		
		if(not is_tcm){
			//ctrl_reg[0] = pmtcm_map[pmtcm_iter][4];
			ctrl_reg[0] = trsh_val;
			res = slow_control.write_registers(ctrl_reg, reg_size, curr_thrs_cal_addr);
            printf("writing %04d to 0x%08x: %d\n\n", ctrl_reg[0], curr_ctrl_addr, res);
		}
	}
	printf("-----------------------------------------------------------------\n\n\n");
	
	
	
	
	// Turning on/off force idle board by board in cycle
	for(int iter=0; iter <= 1000; iter++){
		for(uint32_t pmtcm_iter = 0; pmtcm_iter < pmtcm_total; pmtcm_iter+=1){
			if (pmtcm_map[pmtcm_iter][2] == 0) continue;
			
			uint32_t curr_ctrl_addr = ctrl_addr + pmtcm_map[pmtcm_iter][1];
			uint32_t curr_thrs_cal_addr = trhr_calib_ch0 + pmtcm_map[pmtcm_iter][1];
			
			bool is_tcm = (pmtcm_iter == 0);
			int res = 0;
			uint8_t reg_size = 1;
			
			
			ctrl_reg[0] = 0x00500000; // force on
			res = slow_control.write_registers(ctrl_reg, reg_size, curr_ctrl_addr);
			
			unsigned int delay_val = rand()%5000;//microseconds
			usleep(delay_val);
			
			ctrl_reg[0] = 0x00100000; // force off
			res = slow_control.write_registers(ctrl_reg, reg_size, curr_ctrl_addr);
			
			
			printf("delay: %dus (%.1f orbits)\n", delay_val, float(delay_val)/89.1);
			
		}
	}
	

	
	
}
	
	
	
	
