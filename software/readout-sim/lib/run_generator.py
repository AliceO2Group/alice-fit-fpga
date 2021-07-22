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
        self.output_ctrlreg_file = filename_ctrlreg
        self.ctrl_reg = ctrl_reg
        self.run_comment = run_comment
        self.log = pylog.log

    def reset_file(self):
        self.log.info("Rewriting sim input file: %s"%(self.output_ctrlreg_file))
        file = open(self.output_ctrlreg_file, 'w')
        file.close()

    # generate pattern of control registers to start and stop run
    def generate_ctrl_pattern(self, norbits=3):
        self.log.info("RENERATING %s RUN for %i orbits in file %s" % (self.ctrl_reg.trg_rd_command, norbits, self.output_ctrlreg_file))

        # open file
        file = open(self.output_ctrlreg_file, 'a')
        file_start_pos = file.tell()

        # generate void orbits before run
        run_type = self.ctrl_reg.trg_rd_command
        self.ctrl_reg.trg_rd_command = readout_cmd.idle
        # for first run generate 3 empty orbits for generator offset sync
        reg_line = self.ctrl_reg.get_reg_line_16() + '\n'
        for i in range((3 if file_start_pos<1 else 1) * orbit_size): file.write(reg_line)

        # generate run
        self.ctrl_reg.trg_rd_command = run_type
        reg_line = self.ctrl_reg.get_reg_line_16() + '\n'
        for i in range(norbits * orbit_size): file.write(reg_line)

        # generate void orbits after run
        self.ctrl_reg.trg_rd_command = readout_cmd.idle
        reg_line = self.ctrl_reg.get_reg_line_16() + '\n'
        for i in range(1 * orbit_size): file.write(reg_line)
