# class to work with FIT readout unit control registers

import lib.control_reg as cntrl_reg
import lib.pylog as pylog

log = pylog.log

class input_generator_class:
    def __init__(self, ctrl_file_name = 'simulation_inputs/simple_sig_inputs.txt'):

        self.ctrl_file_name = ctrl_file_name
        self.control_reg = cntrl_reg.control_reg_class()


        # gen parameters
        self.goffset_sig_len = 10
        self.empty_len = 3*0xdeb
        self.run_len = 10*0xdeb
        self.data_gen_delay = 0xf00


        # defoult start
        self.sigin_file = open(self.ctrl_file_name, 'w')



    def gen_gsync_signal(self):
        self.gen_empty_cicle(0x500)

        self.control_reg.reset_gen_offset = 0x1
        for i in range(self.goffset_sig_len): self.sigin_file.write(self.control_reg.get_reg_line_16() + '\n')

        self.control_reg.reset_gen_offset = 0x0
        for i in range(self.goffset_sig_len): self.sigin_file.write(self.control_reg.get_reg_line_16() + '\n')

        self.gen_empty_cicle()
        return

    def gen_empty_cicle(self, len = 0):
        if len == 0: len = self.empty_len
        self.control_reg.trg_rd_command = cntrl_reg.readout_cmd.idle
        data_pattern = self.control_reg.data_bunch_pattern
        self.control_reg.data_bunch_pattern = 0x0
        for i in range(len): self.sigin_file.write(self.control_reg.get_reg_line_16() + '\n')
        self.control_reg.data_bunch_pattern = data_pattern
        return

    def gen_run(self, mode = cntrl_reg.readout_cmd.continious, len = 0):
        if len < self.data_gen_delay: len = self.run_len

        self.gen_empty_cicle()

        data_pattern = self.control_reg.data_bunch_pattern
        self.control_reg.data_bunch_pattern = 0x0
        self.control_reg.trg_rd_command = mode
        for i in range(self.data_gen_delay): self.sigin_file.write(self.control_reg.get_reg_line_16() + '\n')

        self.control_reg.data_bunch_pattern = data_pattern
        for i in range(len - self.data_gen_delay): self.sigin_file.write(self.control_reg.get_reg_line_16() + '\n')

        return
























