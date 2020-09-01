# class to work with FIT readout unit control registers

import lib.control_reg as cntrl_reg
import lib.run_sim_data as run_data
import lib.pylog as pylog

log = pylog.log

class simulation_data_class:
    def __init__(self, ctrl_file_name = 'simulation_inputs/simple_sig_inputs.txt',\
                 gbt_data_file_name = 'simulation_outputs/readout_gbt_output.txt',\
                 gbt_info_file_name = 'simulation_outputs/readout_gbt_info_output.txt',\
                 status_file_name = 'simulation_outputs/readout_status_reg_output.txt'):

        # data set
        self.ctrl_file_name = ctrl_file_name
        self.gbt_data_file_name = gbt_data_file_name
        self.gbt_info_file_name = gbt_info_file_name
        self.status_file_name = status_file_name

        self.gbt_file = open(gbt_data_file_name, 'r')
        self.gbt_info_file = open(gbt_info_file_name, 'r')
        self.status_file = open(status_file_name, 'r')
        self.ctrl_file = open(ctrl_file_name, 'r')

        self.gbt_data_list = list( self.gbt_file )
        self.gbt_info_list = list( self.gbt_info_file )
        self.ctrl_data_list = list( self.ctrl_file )
        self.status_data_list = list( self.status_file )

        self.runs_list = []



        self.print_info()

        # getting run from control reg
        search_run_str = 0
        log.info("\n\nSearching run starting from %d"%(search_run_str) )
        dyn_run = run_data.run_sim_data_class(self.ctrl_data_list)
        get_run_ret = dyn_run.get_run(search_run_str)
        if get_run_ret == -1: log.debug("[-1] no run found ...")
        if get_run_ret == -2: log.debug("[-2] run type switched (no idle command) ...")
        if get_run_ret == -3: log.debug("[-3] run is not stopped, file end reached ...")
        if get_run_ret == -4: log.debug("[-4] run is too short ...")
        if get_run_ret == -5: log.debug("[-5] post run idle is too short ...")
        if get_run_ret ==  1:
            log.info("run found: [str: %d, stp: %d, post idle len: %d]"%(dyn_run.pos_run_start, dyn_run.pos_run_stop, dyn_run.pos_run_postidl - dyn_run.pos_run_stop))
            dyn_run.print_info()
            self.runs_list.append(dyn_run)




    def print_info(self):
        log.info("#######################################################################################")
        log.info("############################# SIMULATION DATA INFO ####################################")
        log.info("#######################################################################################")
        log.info("\ninputs files:")
        log.info("gbt data: %s"%(self.gbt_data_file_name))
        log.info("gbt info: %s"%(self.gbt_info_file_name))
        log.info("control data: %s"%(self.ctrl_file_name))
        log.info("status data: %s"%(self.status_file_name))























