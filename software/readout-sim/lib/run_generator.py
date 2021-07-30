'''

Class include RUN parameters
generate control registers for vhdl simulation
used for simulated run test

Dmitry Finogeev dmitry.finogeev@cern.ch
07/2021

'''
import lib.pylog as pylog

from lib.control_reg import control_reg as ctrl_reg
from lib.control_reg import gen_mode, readout_cmd

from lib.constants import filename_ctrlreg
from lib.constants import orbit_size


class run_generator:
    def __init__(self, ctrl_reg = ctrl_reg(), run_comment=""):
        self.filename_ctrlreg = filename_ctrlreg
        self.ctrl_reg = ctrl_reg
        self.run_comment = run_comment

        self.run_pos_start = 0
        self.run_pos_stop = 0

        self.log = pylog.log

    def print_run_meta(self):
        self.log.info("file name: %s" % (self.filename_ctrlreg))
        self.log.info("run type: %s"%(str(self.ctrl_reg.trg_rd_command)))
        self.log.info(self.run_comment)
        self.log.info("run pos range: [%i, %i]"%(self.run_pos_start, self.run_pos_stop))


    def reset_file(self):
        self.log.info("Rewriting sim input file: %s" % (self.filename_ctrlreg))
        file = open(self.filename_ctrlreg, 'w')
        file.close()

    # generate pattern of control registers to start and stop run
    def generate_ctrl_pattern(self, norbits=3):
        self.log.info("RENERATING %s RUN for %i orbits in file %s" % (self.ctrl_reg.trg_rd_command, norbits, self.filename_ctrlreg))

        # open file
        self.run_pos_start = len(open(self.filename_ctrlreg).readlines())
        file = open(self.filename_ctrlreg, 'a')

        # generate void orbits before run
        run_type = self.ctrl_reg.trg_rd_command
        self.ctrl_reg.trg_rd_command = readout_cmd.idle
        # start of simulation
        if self.run_pos_start<2*orbit_size:
            # reset orbc sync
            self.ctrl_reg.reset_orbc_sync = 1
            reg_line = self.ctrl_reg.get_reg_line_16() + '\n'
            for i in range(20): file.write(reg_line)
            # generate void orbits to make RX decoder sync
            self.ctrl_reg.reset_orbc_sync = 0
            reg_line = self.ctrl_reg.get_reg_line_16() + '\n'
            for i in range(2*orbit_size): file.write(reg_line)

        # reset simulation generators and errors
        self.ctrl_reg.reset_gensync = 1
        self.ctrl_reg.reset_data_counters = 1
        reg_line = self.ctrl_reg.get_reg_line_16() + '\n'
        for i in range(10): file.write(reg_line)
        # generate void orbits to make generators in sync
        self.ctrl_reg.reset_gensync = 0
        self.ctrl_reg.reset_data_counters = 0
        reg_line = self.ctrl_reg.get_reg_line_16() + '\n'
        for i in range(2*orbit_size): file.write(reg_line)

        # generate run
        self.ctrl_reg.trg_rd_command = run_type
        reg_line = self.ctrl_reg.get_reg_line_16() + '\n'
        for i in range(norbits * orbit_size): file.write(reg_line)

        # generate void orbits after run to finish sending data
        self.ctrl_reg.trg_rd_command = readout_cmd.idle
        reg_line = self.ctrl_reg.get_reg_line_16() + '\n'
        for i in range(6 * orbit_size): file.write(reg_line)
        self.ctrl_reg.trg_rd_command = run_type

        file.close()
        self.run_pos_stop = len(open(self.filename_ctrlreg).readlines())




