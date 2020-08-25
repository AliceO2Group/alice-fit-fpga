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
                     ((0x1 & self.strt_rdmode_lock) << 2)
        reg_00 = reg_00 + ((0xF&reset_ctrl) << 20)


        register = []
        register.append( reg_00 )
        register.append( 0xFFFFFFFF&self.data_trg_respond_mask)
        register.append( 0xFFFFFFFF&self.data_bunch_pattern)
        register.append( 0xFFFFFFFF&self.trg_single_val)
        register.append( 0xFFFFFFFF&self.trg_pattern_1)
        register.append( 0xFFFFFFFF&self.trg_pattern_0)
        register.append( 0xFFFFFFFF&self.trg_cont_val)

        register.append( ((0xFFFFFFFF&self.trg_bunch_freq)<<16) +  (0xFFFFFFFF&self.data_bunch_freq) )
        register.append( ((0xFFFFFFF&self.trg_bunch_freq)<<16) +  (0xFFFFFFF&self.data_bunch_freq) )
        register.append( ((0xFFFFFFFF&self.RDH_feeid)<<16) +  (0xFFFFFFFF&self.RDH_par) )
        register.append( ((0xFFFFFFFF&self.max_data_payload)<<16) +  (0xFFFFFFFF&self.RDH_detf) )
        register.append( ((0xFFFFFFFF&self.crutrg_delay_comp)<<16) +  (0xFFFFFFFF&self.bcid_delay) )
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











