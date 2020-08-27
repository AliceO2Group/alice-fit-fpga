# class to work with FIT readout unit control registers
from aenum import Enum

class gen_mode(Enum):
    no_gen = 0
    main_gen = 1
    tx_gen = 2

class readout_cmd(Enum):
    idle = 0
    continious = 1
    trigger = 2

class bcid_smode(Enum):
    start = 0
    sync = 1
    lost = 2


class status_reg_class:
    def __init__(self):
        self.gbt_status = 0
        self.readout_mode = readout_cmd.idle
        self.bcid_sync = bcid_smode.start
        self.rx_phase = 0x0

        self.cru_readout_mode = readout_cmd.idle
        self.cru_orbit = 0x0
        self.cru_bc = 0x0

        self.raw_fifo_count = 0x0

        self.slct_fifo_count = 0x0
        self.slct_frst_hd_orbit = 0x0
        self.slct_last_hd_orbit = 0x0
        self.slct_tot_hd = 0x0
        self.readout_rate = 0x0

    def print_struct(self):
        print("======== status reg ========")
        print("    gbt_status: ", self.gbt_status)
        print("    readout_mode:", self.readout_mode)
        print("    bcid_sync: ", self.bcid_sync)
        print("    rx_phase: ", hex(self.rx_phase))

        print("    cru_readout_mode: ", self.cru_readout_mode)
        print("    cru_orbit: ", hex(self.cru_orbit))
        print("    cru_bc: ", hex(self.cru_bc))

        print("    raw_fifo_count: ", hex(self.raw_fifo_count))

        print("    slct_fifo_count: ", hex(self.slct_fifo_count))
        print("    slct_frst_hd_orbit: ", hex(self.slct_frst_hd_orbit))
        print("    slct_last_hd_orbit: ", hex(self.slct_last_hd_orbit))
        print("    slct_tot_hd: ", hex(self.slct_tot_hd))
        print("    readout_rate: ", hex(self.readout_rate))


    def read_reg_line_hex(self, line = "0 0 0 0 0 0 0 0"):
        line = line.replace('X', '0')
        line_regs = line.split(" ")[:-1]
        print(line_regs)

        # - 20-19 19-18 18-17 17-16 16-15 15-14 14-13 13-12 12-11 11-10 10- 9 9 - 8 8 - 7 7 - 6 6 - 5 5 - 4 4 - 3 3 - 2 2 - 1 1 -
        #   79-76 75-72 71-68 67-64 63-60 59-56 55-52 51-48 47-44 43-40 39-36 35-32 31-28 27-24 23-20 19-16 15-12 11- 8 7 - 4 3 - 0
        self.gbt_status = int(line_regs[0][ -4: ], base=16)
        self.readout_mode = readout_cmd( int(line_regs[0][ -5: -4], base=16) )
        self.bcid_sync = bcid_smode( int(line_regs[0][ -6: -5], base=16) )
        self.rx_phase = int(line_regs[0][ -7: -6], base=16)
        self.cru_readout_mode = readout_cmd( int(line_regs[0][ -8: -7], base=16) )
        self.cru_orbit = int(line_regs[1][ -8: ], base=16)
        self.cru_bc = int(line_regs[2][ -3: ], base=16)
        self.raw_fifo_count = int(line_regs[3][ -4: ], base=16)
        self.slct_fifo_count = int(line_regs[3][ -8: -4], base=16)
        self.slct_frst_hd_orbit = int(line_regs[4][ -8: ], base=16)
        self.slct_last_hd_orbit = int(line_regs[5][ -8: ], base=16)
        self.slct_tot_hd = int(line_regs[6][ -8: ], base=16)
        self.readout_rate = int(line_regs[7][ -4: ], base=16)










