# class to work with FIT readout unit control registers

import lib.control_reg as cntrl_reg
import lib.status_reg as stat_reg
import lib.pylog as pylog
import lib.readout_constants as rd_const

log = pylog.log


class gen_simulation_class:
    def __init__(self, ctrl_data_list, status_data_list):

        # data set
        self.ctrl_data_list = ctrl_data_list
        self.status_data_list = status_data_list

        # simulation results
        self.ntotal_reset = 0
        self.trigger_val_list = []


#    def print_info(self):


    def sim_cont_trigger(self):
        # simulation continious trigger generator
        trg_gen_fsm = 0 # 0 - start; 1 - reset signal done, waiting hb; 2 - counting offset; 3 - trigger period
        freq_offset_cnt = 0
        period_cnt = 0
        pattern_cnt = 0 # 0: waiting period

        # main simulation loop -----------------------------------------------
        dyn_ctrl_reg = cntrl_reg.control_reg_class()
        dyn_stat_reg = stat_reg.status_reg_class()

        curr_pos = 0
        while curr_pos < len(self.ctrl_data_list):
            dyn_ctrl_reg.read_reg_line_16(self.ctrl_data_list[curr_pos])
            dyn_stat_reg.read_reg_line_hex(self.status_data_list[curr_pos])

            # reset procedure -----------------------------
            if (trg_gen_fsm == 1) and (dyn_stat_reg.cru_trigger & rd_const.TRG_const_HB > 0):
                trg_gen_fsm = 2
                freq_offset_cnt = 0
                self.ntotal_reset += 1

            if (dyn_ctrl_reg.reset_gen_offset == 1):
                trg_gen_fsm = 1

            if (trg_gen_fsm == 2) and (freq_offset_cnt == dyn_ctrl_reg.trg_bc_start):
                trg_gen_fsm = 3
                freq_offset_cnt = 0
                period_cnt = 0
            elif (trg_gen_fsm == 2):
                freq_offset_cnt += 1




            if (trg_gen_fsm == 3):
                if (period_cnt < dyn_ctrl_reg.trg_bunch_freq):
                    period_cnt += 1
                else:
                    period_cnt = 0
                    pattern_cnt = 1


            if (pattern_cnt > 0) and (pattern_cnt <= 64):
                if (pattern_cnt <= 32):
                    if (dyn_ctrl_reg.trg_pattern_0&(1<<(pattern_cnt-1)) > 0):
                        self.trigger_val_list.append([ ])

                pattern_cnt += 1




        return

























