# class to work with FIT readout unit control registers

import lib.simulation_data as sim_data
import lib.RDH_data as rdh_data
import lib.pylog as pylog

log = pylog.log


class run_testbench_class:
    def __init__(self, simulation, run_num = 0):

        # data set
        self.simulation = simulation
        self.run_num = run_num
        self.run_data = self.simulation.runs_list[self.run_num]

        # run data
        self.rdh_data_list = []

        self.read_run_data()

    # def print_info(self):
    #     log.info("############################# SIMULATION RUN  INFO ####################################")
    #     log.info("\ninputs files:")
    #     log.info("data position run start: %d"%(self.pos_run_start))
    #     log.info("data position run stop: %d"%(self.pos_run_stop))
    #     log.info("data position post run idle: %d"%(self.pos_run_postidl))


    def read_run_data(self):
        self.rdh_data_list = []
        dyn_event = rdh_data.rdh_data_class()
        pos = self.run_data.pos_gbt_start
        while pos < self.run_data.pos_gbt_postidl:
            pos = dyn_event.read_data(self.simulation.gbt_data_list, pos)
            dyn_event.print_raw()
            dyn_event.print_struct()
            self.rdh_data_list.append(dyn_event)






























