# class to work with FIT readout unit control registers

import lib.control_reg as cntrl_reg
import lib.pylog as pylog

log = pylog.log


class run_sim_data_class:
    def __init__(self, ctrl_data_list, gbt_info_list):

        # data set
        self.ctrl_data_list = ctrl_data_list
        self.gbt_info_list = gbt_info_list

        # test bench parameters
        self.idle_min_len = 2*0xdec
        self.run_min_len = 3*0xdec

        # run parameters
        self.pos_run_start = 0
        self.pos_run_stop = 0
        self.pos_run_postidl = 0
        self.run_type = cntrl_reg.readout_cmd.idle
        self.pos_gbt_start = 0
        self.pos_gbt_stop = 0
        self.pos_gbt_postidl = 0
        self.pos_last_read = 0
        self.run_control = cntrl_reg.control_reg_class()

    def print_info(self):
        log.info("############################# SIMULATION RUN INFO ####################################")
        log.info("\ninputs files:")
        log.info("data position run start: %d"%(self.pos_run_start))
        log.info("data position run stop: %d"%(self.pos_run_stop))
        log.info("data position post run idle: %d"%(self.pos_run_postidl))
        log.info("\noutputs files:")
        log.info("gbt position run start: %d (%d)"%(self.pos_gbt_start, int(self.gbt_info_list[self.pos_gbt_start], base=16)))
        log.info("gbt position run stop: %d (%d)"%(self.pos_gbt_stop, int(self.gbt_info_list[self.pos_gbt_stop], base=16)))
        log.info("gbt position post run idle: %d (%d)"%(self.pos_gbt_postidl, int(self.gbt_info_list[self.pos_gbt_postidl], base=16)))
        log.info("\nrun params:")
        log.info("run type: %s"%(self.run_type))
        self.run_control.print_struct()


    def get_run(self, ctrl_reg_pos):
        # one orbit = 3563 BCs
        # 1) find idle readout for one orbit
        # 2) check next cnt/trg control
        # 3) return [code, run start, run stop]

        # find first idle pattern -----------------------------------------------
        idle_len = 0
        curr_pos = ctrl_reg_pos
        dyn_ctrl_reg = cntrl_reg.control_reg_class()
        while curr_pos < len(self.ctrl_data_list):
            dyn_ctrl_reg.read_reg_line_16(self.ctrl_data_list[curr_pos])

            if (dyn_ctrl_reg.trg_rd_command != cntrl_reg.readout_cmd.idle) and \
                    (idle_len >= self.idle_min_len): break

            if dyn_ctrl_reg.trg_rd_command == cntrl_reg.readout_cmd.idle:
                idle_len += 1
            else:
                idle_len = 0

            self.pos_last_read = curr_pos
            curr_pos += 1

        if len(self.ctrl_data_list) - curr_pos < self.run_min_len:
            return -1 # no space for run

        run_start = curr_pos

        # find uniform run parameters -------------------------------------------
        run_len = 0
        run_type = dyn_ctrl_reg.trg_rd_command
        self.run_control = dyn_ctrl_reg

        while curr_pos < len(self.ctrl_data_list):
            dyn_ctrl_reg.read_reg_line_16(self.ctrl_data_list[curr_pos])

            if (dyn_ctrl_reg.trg_rd_command != run_type) and \
               (dyn_ctrl_reg.trg_rd_command != cntrl_reg.readout_cmd.idle):
                return -2 # run type switched

            if (not self.run_control.is_equal(dyn_ctrl_reg)):
                return -6 #control reg is different


            if dyn_ctrl_reg.trg_rd_command == cntrl_reg.readout_cmd.idle:
                break

            self.pos_last_read = curr_pos
            run_len += 1
            curr_pos += 1

        if (dyn_ctrl_reg.trg_rd_command != cntrl_reg.readout_cmd.idle):
            return -3  # run is not stopped

        if (run_len < self.run_min_len):
            return -4  # run is too short

        run_stop = curr_pos-1


        # post run idle cycle -------------------------------------------
        idle_len = 0
        while curr_pos < len(self.ctrl_data_list):
            dyn_ctrl_reg.read_reg_line_16(self.ctrl_data_list[curr_pos])
            if (dyn_ctrl_reg.trg_rd_command != cntrl_reg.readout_cmd.idle): break

            self.pos_last_read = curr_pos
            curr_pos += 1
            idle_len += 1

        if idle_len < self.idle_min_len:
            return -5 # post run idle it too short



        self.pos_run_start = run_start
        self.pos_run_stop = run_stop
        self.pos_run_postidl = curr_pos-1
        self.run_type = run_type
        return 1

    def find_gbt_pos(self):
        # GBT data run start position
        ipos = 0
        while 1:
            curr_gbt_num = int(self.gbt_info_list[ipos], base=16)
            if curr_gbt_num >= self.pos_run_start:
                self.pos_gbt_start = ipos
                break

            ipos += 1
            if ipos >= len(self.gbt_info_list):
                self.pos_gbt_start = len(self.gbt_info_list)-1
                break

        # GBT data run stop position
        ipos = 0
        while 1:
            curr_gbt_num = int(self.gbt_info_list[ipos], base=16)
            if curr_gbt_num >= self.pos_run_stop:
                self.pos_gbt_stop = ipos
                break

            ipos += 1
            if ipos >= len(self.gbt_info_list):
                self.pos_gbt_stop = len(self.gbt_info_list)-1
                break


        # GBT data run post idle position
        ipos = 0
        while 1:
            curr_gbt_num = int(self.gbt_info_list[ipos], base=16)
            if curr_gbt_num >= self.pos_run_postidl:
                self.pos_gbt_postidl = ipos
                break

            ipos += 1
            if ipos >= len(self.gbt_info_list):
                self.pos_gbt_postidl = len(self.gbt_info_list)-1
                break



        return


























