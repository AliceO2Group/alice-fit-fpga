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


class control_reg_class:
    def __init__(self):
        self.data_gen = gen_mode.no_gen
        self.data_trg_respond_mask = 0
        self.data_bunch_pattern = 0x1
        self.data_bunch_freq = 0xF0
        self.data_freq_offset = 1

        self.trg_gen = gen_mode.no_gen
        self.trg_rd_command = readout_cmd.idle
        self.trg_single_val = 0
        self.trg_pattern_0 = 0x1
        self.trg_pattern_1 = 0
        self.trg_cont_val = 0x10
        self.trg_bunch_freq = 0xf0
        self.trg_freq_offset = 1

        self.rd_bypass = 0
        self.is_hb_response = 1
        self.trg_data_select = 0x10
        self.strt_rdmode_lock = 0

        self.bcid_delay = 0xF
        self.crutrg_delay_comp = 0xf
        self.max_data_payload = 0xff

        self.reset_orbc_sync = 0
        self.reset_drophit_counter = 0
        self.reset_gen_offset = 0
        self.reset_gbt_rxerror = 0
        self.reset_gbt = 0
        self.reset_rxph_error = 0

        self.RDH_feeid = 0xAAAA
        self.RDH_par = 0xCCCC
        self.RDH_detf = 0xDDDD


    def print_struct(self):
        print("======== control reg ========")
        print("data generator param:")
        print("    data_gen: ", self.data_gen)
        print("    data_trg_respond_mask:", hex(self.data_trg_respond_mask))
        print("    data_bunch_pattern: ", hex(self.data_bunch_pattern))
        print("    data_bunch_freq: ", hex(self.data_bunch_freq))
        print("    data_freq_offset: ", hex(self.data_freq_offset))

        print("trigger generator param:")
        print("    trg_gen: ", self.trg_gen)
        print("    trg_rd_command: ", self.trg_rd_command)
        print("    trg_pattern_0: ", hex(self.trg_pattern_0))
        print("    trg_pattern_1: ", hex(self.trg_pattern_1))
        print("    trg_cont_val: ", hex(self.trg_cont_val))
        print("    trg_bunch_freq: ", hex(self.trg_bunch_freq))
        print("    trg_freq_offset: ", hex(self.trg_freq_offset))

        print("readout param:")
        print("    rd_bypass: ", hex(self.rd_bypass))
        print("    is_hb_response: ", hex(self.is_hb_response))
        print("    trg_data_select: ", hex(self.trg_data_select))
        print("    strt_rdmode_lock: ", hex(self.strt_rdmode_lock))

        print("delay param:")
        print("    bcid_delay: ", hex(self.bcid_delay))
        print("    crutrg_delay_comp: ", hex(self.crutrg_delay_comp))
        print("    max_data_payload: ", hex(self.max_data_payload))

        print("reset param:")
        print("    reset_orbc_sync: ", hex(self.reset_orbc_sync))
        print("    reset_drophit_counter: ", hex(self.reset_drophit_counter))
        print("    reset_gen_offset: ", hex(self.reset_gen_offset))
        print("    reset_gbt_rxerror: ", hex(self.reset_gbt_rxerror))
        print("    reset_gbt: ", hex(self.reset_gbt))
        print("    reset_rxph_error: ", hex(self.reset_rxph_error))

        print("RDH param:")
        print("    RDH_feeid: ", hex(self.RDH_feeid))
        print("    RDH_par: ", hex(self.RDH_par))
        print("    RDH_detf: ", hex(self.RDH_detf))

    def get_reg(self):
        reg_00 = 0xF&self.data_gen.value
        reg_00 = reg_00 + ((0xF&self.trg_gen.value) << 4)

        reset_ctrl = (0x1&self.reset_orbc_sync)+ \
                     ((0x1&self.reset_drophit_counter) << 1) + \
                     ((0x1 & self.reset_gen_offset) << 2) + \
                     ((0x1 & self.reset_gbt_rxerror) << 3) + \
                     ((0x1 & self.reset_gbt) << 4) + \
                     ((0x1 & self.reset_gbt_rxerror) << 5)
        reg_00 = reg_00 + ((0xFF&reset_ctrl) << 8)

        reg_00 = reg_00 + ((0xF & self.trg_rd_command.value) << 16)

        rd_mode = (0x1&self.is_hb_response)+ \
                     ((0x1&self.rd_bypass) << 1) + \
                     ((0x1&self.strt_rdmode_lock) << 2)
        reg_00 = reg_00 + ((0xF&reset_ctrl) << 20)


        register = []
        register.append( reg_00 )
        register.append( 0xFFFFFFFF&self.data_trg_respond_mask)
        register.append( 0xFFFFFFFF&self.data_bunch_pattern)
        register.append( 0xFFFFFFFF&self.trg_single_val)
        register.append( 0xFFFFFFFF&self.trg_pattern_1)
        register.append( 0xFFFFFFFF&self.trg_pattern_0)
        register.append( 0xFFFFFFFF&self.trg_cont_val)

        register.append( ((0xFFFF&self.trg_bunch_freq)<<16) +  (0xFFFF&self.data_bunch_freq) )
        register.append( ((0xFFF&self.trg_freq_offset)<<16) +  (0xFFF&self.data_freq_offset) )
        register.append( ((0xFFFF&self.RDH_feeid)<<16) +  (0xFFFF&self.RDH_par) )
        register.append( ((0xFFFF&self.max_data_payload)<<16) +  (0xFFFF&self.RDH_detf) )
        register.append( ((0xFFFF&self.crutrg_delay_comp)<<16) +  (0xFFFF&self.bcid_delay) )
        register.append( 0xFFFFFFFF&self.trg_data_select)
        return register

    def get_reg_line(self):
        return ' '.join( [str(x) for x in self.get_reg()])
    
    def get_reg_line_16(self):
        res_str = ""
        for ireg in self.get_reg():
            res_str = res_str + str( (0xFFFF0000&ireg)>>16  ) + " "
            res_str = res_str + str(0xFFFF & ireg) + " "
        return res_str

    def get_reg_line_hex(self):
        return ' '.join( [hex(x) for x in self.get_reg()])

    def read_reg_line_16(self, line = "0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0"):
        line_regs = line.split(" ")
        regs = []
        for ireg in range(0, len(line_regs)-1, 2):
            reg = ( (0xFFFF&int(line_regs[ireg])) << 16) + (0xFFFF & int(line_regs[ireg+1]) )
            regs.append(reg)

        self.data_gen = gen_mode( 0xF&regs[0] )
        self.trg_gen = gen_mode( (0xF0&regs[0])>>4 )
        self.reset_orbc_sync = 0x1&(regs[0]>>8)
        self.reset_drophit_counter = 0x1&(regs[0]>>9)
        self.reset_gen_offset = 0x1&(regs[0]>>10)
        self.reset_gbt_rxerror = 0x1&(regs[0]>>11)
        self.reset_gbt = 0x1&(regs[0]>>12)
        self.reset_rxph_error = 0x1&(regs[0]>>13)
        self.trg_rd_command = readout_cmd( (0xF0000&regs[0])>>16)
        self.is_hb_response = 0x1&(regs[0]>>20)
        self.rd_bypass = 0x1&(regs[0]>>21)
        self.strt_rdmode_lock = 0x1&(regs[0]>>22)

        self.data_trg_respond_mask = regs[1]
        self.data_bunch_pattern = regs[2]
        self.trg_single_val = regs[3]
        self.trg_pattern_1 = regs[4]
        self.trg_pattern_0 = regs[5]
        self.trg_cont_val = regs[6]
        self.data_bunch_freq = (0xFFFF&regs[7])
        self.trg_bunch_freq = (0xFFFF0000&regs[7])>>16
        self.data_freq_offset = (0xFFF&regs[8])
        self.trg_freq_offset = (0xFFF0000&regs[8])>>16
        self.RDH_par = (0xFFFF&regs[9])
        self.RDH_feeid = (0xFFFF0000&regs[9])>>16
        self.RDH_detf = (0xFFFF&regs[10])
        self.max_data_payload = (0xFFFF0000&regs[10])>>16
        self.bcid_delay = (0xFFFF&regs[11])
        self.crutrg_delay_comp = (0xFFFF0000&regs[11])>>16
        self.trg_data_select = regs[12]

    def print_raw(self):
        print(self.get_reg_line_hex())












