/*
Fast PM/TCM readout initialisation (all modules via IPbus/TCM)


g++ -g -Wall fit_gbt_init.cpp -o fit_gbt_init.run && ./fit_gbt_init.run
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

int main(int argc, char *argv[]) {
    printf("\n\n====================================================\n");
    printf(    "================ FIT GBT init ===============\n");
    printf("====================================================\n\n\n");
    
    ipbus_connection slow_control;
    slow_control.set_board_ip("172.20.75.180");
    slow_control.set_board_port(50001);
    if (slow_control.connect_to_board() < 0) {
	printf("Connection to board failed\n");
	return -1;
    }
	
	
	uint32_t ctrl_reg[16] = {0};
	
	// writing init Readout registers to all modules
	for(uint32_t pmtcm_iter = 0; pmtcm_iter < pmtcm_total; pmtcm_iter+=1){
		if (pmtcm_map[pmtcm_iter][2] == 0) continue;
		
		uint32_t curr_ctrl_addr = ctrl_addr + pmtcm_map[pmtcm_iter][1];
		uint32_t curr_thrs_cal_addr = trhr_calib_ch0 + pmtcm_map[pmtcm_iter][1];
		
		bool is_tcm = (pmtcm_iter == 0);
		int res = 0;
		uint8_t reg_size = 16;
		
		printf("%04x addr 0x%08x", pmtcm_map[pmtcm_iter][0], curr_ctrl_addr);
		
		printf(" init ");
		ctrl_reg[0] = 0x00104000;
		ctrl_reg[1] = is_tcm ? 0x40:0x10;// trg response mask
		ctrl_reg[9] = 0x00220000 + pmtcm_map[pmtcm_iter][0]; // sys id
	    ctrl_reg[11] = is_tcm ? 0x1C:0x24; //bcid delay
		ctrl_reg[12] = 0x10; // trigger select
		res = slow_control.write_registers(ctrl_reg, reg_size, curr_ctrl_addr);
		
		printf(" reset ");
		ctrl_reg[0] = 0x00100000; // release reset
		res = slow_control.write_registers(ctrl_reg, reg_size, curr_ctrl_addr);
		
		//threshold calibration
		if(not is_tcm){
			ctrl_reg[0] = pmtcm_map[pmtcm_iter][4];
			reg_size = 1;
			res = slow_control.write_registers(ctrl_reg, reg_size, curr_thrs_cal_addr);
		}
		
		printf(" done\n");

	}
	
	/*
    slow_control.read_registers(ctrl_reg, reg_size, ctrl_addr);
	for(int i=0; i <reg_size; i++){
		printf("reg %i: %08x\n", i, ctrl_reg[i]);
	}
	*/	

	
	
	
	
	
	
}
	
	
	
	
