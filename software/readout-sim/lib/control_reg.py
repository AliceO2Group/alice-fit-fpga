# class to work with FIT readout unit control registers
from aenum import Enum
import lib.pylog as pylog

log = pylog.log


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
        self.data_gen = gen_mode.main_gen
        self.data_trg_respond_mask = 0
        self.data_bunch_pattern = 0x0
        self.data_bunch_freq = 0x0
        self.data_freq_offset = 0

        self.trg_gen = gen_mode.main_gen
        self.trg_rd_command = readout_cmd.idle
        self.trg_single_val = 0
        self.trg_pattern_0 = 0
        self.trg_pattern_1 = 0
        self.trg_cont_val = 0
        self.trg_bunch_freq = 0
        self.trg_freq_offset = 0

        self.rd_bypass = 0
        self.is_hb_response = 1
        self.trg_data_select = 0
        self.strt_rdmode_lock = 0

        self.bcid_delay = 0xF
        self.crutrg_delay_comp = 0xF
        self.max_data_payload = 0xFF

        self.reset_orbc_sync = 0
        self.reset_drophit_counter = 0
        self.reset_gen_offset = 0
        self.reset_gbt_rxerror = 0
        self.reset_gbt = 0
        self.reset_rxph_error = 0

        self.RDH_feeid = 0xAAAA
        self.RDH_par = 0xCCCC
        self.RDH_detf = 0xDDDD


    def is_equal(self, other):
        if self.data_gen != other.data_gen: return 0
        if self.data_trg_respond_mask != other.data_trg_respond_mask: return 0
        if self.data_bunch_pattern != other.data_bunch_pattern: return 0
        if self.data_bunch_freq != other.data_bunch_freq: return 0
        if self.data_freq_offset != other.data_freq_offset: return 0
        if self.trg_gen != other.trg_gen: return 0
        if self.trg_rd_command != other.trg_rd_command: return 0
        if self.trg_single_val != other.trg_single_val: return 0
        if self.trg_pattern_0 != other.trg_pattern_0: return 0
        if self.trg_pattern_1 != other.trg_pattern_1: return 0
        if self.trg_cont_val != other.trg_cont_val: return 0
        if self.trg_bunch_freq != other.trg_bunch_freq: return 0
        if self.trg_freq_offset != other.trg_freq_offset: return 0
        if self.rd_bypass != other.rd_bypass: return 0
        if self.is_hb_response != other.is_hb_response: return 0
        if self.trg_data_select != other.trg_data_select: return 0
        if self.strt_rdmode_lock != other.strt_rdmode_lock: return 0
        if self.bcid_delay != other.bcid_delay: return 0
        if self.crutrg_delay_comp != other.crutrg_delay_comp: return 0
        if self.max_data_payload != other.max_data_payload: return 0
        if self.reset_orbc_sync != other.reset_orbc_sync: return 0
        if self.reset_drophit_counter != other.reset_drophit_counter: return 0
        if self.reset_gen_offset != other.reset_gen_offset: return 0
        if self.reset_gbt_rxerror != other.reset_gbt_rxerror: return 0
        if self.reset_gbt != other.reset_gbt: return 0
        if self.reset_rxph_error != other.reset_rxph_error: return 0
        if self.RDH_feeid != other.RDH_feeid: return 0
        if self.RDH_par != other.RDH_par: return 0
        if self.RDH_detf != other.RDH_detf: return 0
        return 1


    def print_struct(self):
        log.info("======== control reg ========")
        log.info("data generator param:")
        log.info("    data_gen: %s"%(self.data_gen))
        log.info("    data_trg_respond_mask:%s"%( hex(self.data_trg_respond_mask)))
        log.info("    data_bunch_pattern: %s"%( hex(self.data_bunch_pattern)))
        log.info("    data_bunch_freq: %s"%( hex(self.data_bunch_freq)))
        log.info("    data_freq_offset: %s"%( hex(self.data_freq_offset)))

        log.info("trigger generator param:")
        log.info("    trg_gen: %s"%( self.trg_gen))
        log.info("    trg_rd_command: %s"%( self.trg_rd_command))
        log.info("    trg_pattern_0: %s"%( hex(self.trg_pattern_0)))
        log.info("    trg_pattern_1: %s"%( hex(self.trg_pattern_1)))
        log.info("    trg_cont_val: %s"%( hex(self.trg_cont_val)))
        log.info("    trg_bunch_freq: %s"%( hex(self.trg_bunch_freq)))
        log.info("    trg_freq_offset: %s"%( hex(self.trg_freq_offset)))

        log.info("readout param:")
        log.info("    rd_bypass: %s"%( hex(self.rd_bypass)))
        log.info("    is_hb_response: %s"%( hex(self.is_hb_response)))
        log.info("    trg_data_select: %s"%( hex(self.trg_data_select)))
        log.info("    strt_rdmode_lock: %s"%( hex(self.strt_rdmode_lock)))

        log.info("delay param:")
        log.info("    bcid_delay: %s"%( hex(self.bcid_delay)))
        log.info("    crutrg_delay_comp: %s"%( hex(self.crutrg_delay_comp)))
        log.info("    max_data_payload: %s"%( hex(self.max_data_payload)))

        log.info("reset param:")
        log.info("    reset_orbc_sync: %s"%( hex(self.reset_orbc_sync)))
        log.info("    reset_drophit_counter: %s"%( hex(self.reset_drophit_counter)))
        log.info("    reset_gen_offset: %s"%( hex(self.reset_gen_offset)))
        log.info("    reset_gbt_rxerror: %s"%( hex(self.reset_gbt_rxerror)))
        log.info("    reset_gbt: %s"%( hex(self.reset_gbt)))
        log.info("    reset_rxph_error: %s"%( hex(self.reset_rxph_error)))

        log.info("RDH param:")
        log.info("    RDH_feeid: %s"%( hex(self.RDH_feeid)))
        log.info("    RDH_par: %s"%( hex(self.RDH_par)))
        log.info("    RDH_detf: %s"%( hex(self.RDH_detf)))

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

        reg_00 = reg_00 + ((0xF&rd_mode) << 20)


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












