# class to work with FIT readout unit control registers
from aenum import Enum

from lib.control_reg import readout_cmd


class bcid_smode(Enum):
    start = 0
    sync = 1
    lost = 2

    def __str__(self):
        return self.name

    @property
    def counter(self):
        return self.value


class status_reg:
    def __init__(self, reg_line=0):
        self.readout_mode = readout_cmd.idle
        self.cru_readout_mode = readout_cmd.idle
        self.bcid_sync = bcid_smode.start

        self.fsm_errors = 0x0
        self.cnv_fifo_max = 0x0
        self.cnv_drop_cnt = 0x0
        self.sel_fifo_max = 0x0
        self.sel_drop_cnt = 0x0

        self.cru_orbit = 0x0
        self.cru_bc = 0x0
        self.cru_trigger = 0x0
        self.cru_orbit_corr = 0x0
        self.cru_bc_corr = 0x0

        self.data_gen_orbit = 0x0
        self.data_gen_bc = 0x0
        self.data_gen_size = 0x0
        self.data_gen_packnum = 0

        self.fsm_error_msg = {1 << 0: '[RDH builder] reading empty fifo',
                              1 << 1: '[Selector] slct fifo is not empty',
                              1 << 2: '[Selector] cntpck fifo is not empty',
                              1 << 3: '[Selector] trg fifo is not empty',
                              1 << 4: '[Selector] trg fifo is full',
                              1 << 5: '[Converter] data fifo is not empty',
                              1 << 6: '[Converter] header fifo is not empty',
                              1 << 7: '[Converter] tcm_data_fifo is full'}

        if reg_line != 0: self.read_reg_line_hex(reg_line)

    def print_struct(self):
        print("======== status reg ========")
        print("    readout_mode:", self.readout_mode)
        print("    cru_readout_mode: ", self.cru_readout_mode)
        print("    bcid_sync: ", self.bcid_sync)

        print("    fsm_errors: ", hex(self.fsm_errors))
        print("    cnv_fifo_max: ", hex(self.cnv_fifo_max))
        print("    cnv_drop_cnt: ", hex(self.cnv_drop_cnt))
        print("    sel_fifo_max: ", hex(self.sel_fifo_max))
        print("    sel_drop_cnt: ", hex(self.sel_drop_cnt))

        print("    cru_orbit: ", hex(self.cru_orbit))
        print("    cru_bc: ", hex(self.cru_bc))
        print("    cru_trigger: ", hex(self.cru_trigger))
        print("    cru_orbit_corr: ", hex(self.cru_orbit_corr))
        print("    cru_bc_corr: ", hex(self.cru_bc_corr))

        print("    data_gen_orbit: ", hex(self.data_gen_orbit))
        print("    data_gen_bc: ", hex(self.data_gen_bc))
        print("    data_gen_size: ", hex(self.data_gen_size))

    def get_fsm_err_msg(self):
        res = ""
        for key in self.fsm_error_msg:
            if (self.fsm_errors & key) > 0: res += self.fsm_error_msg[key] + " "
        return res

    def read_reg_line_hex(self, line_regs):
        # - 20-19 19-18 18-17 17-16 16-15 15-14 14-13 13-12 12-11 11-10 10- 9 9 - 8 8 - 7 7 - 6 6 - 5 5 - 4 4 - 3 3 - 2 2 - 1 1 -
        #   79-76 75-72 71-68 67-64 63-60 59-56 55-52 51-48 47-44 43-40 39-36 35-32 31-28 27-24 23-20 19-16 15-12 11- 8 7 - 4 3 - 0
        self.readout_mode = readout_cmd(int(line_regs[0][-5: -4], base=16))
        self.cru_readout_mode = readout_cmd(int(line_regs[0][-8: -7], base=16))
        self.bcid_sync = bcid_smode(int(line_regs[0][-6: -5], base=16))

        self.fsm_errors = int(line_regs[2][-8: -4], base=16)
        self.cnv_drop_cnt = int(line_regs[3][-4:], base=16)
        self.cnv_fifo_max = int(line_regs[3][-8: -4], base=16)
        self.sel_drop_cnt = int(line_regs[4][-4:], base=16)
        self.sel_fifo_max = int(line_regs[4][-8: -4], base=16)

        self.cru_orbit = int(line_regs[1][-8:], base=16)
        self.cru_bc = int(line_regs[2][-3:], base=16)

        self.cru_orbit_corr = int(line_regs[9][-8:], base=16)
        self.cru_bc_corr = int(line_regs[10][-3:], base=16)
        self.cru_trigger = int(line_regs[11][-3:], base=16)

        self.data_gen_orbit = int(line_regs[12][-8:], base=16)
        self.data_gen_bc = int(line_regs[13][-3:], base=16)
        self.data_gen_size = int(line_regs[13][-5:-4], base=16)
        self.data_gen_packnum = int(line_regs[14][-8:], base=16)
