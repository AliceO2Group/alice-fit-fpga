'''

write / reading readout control registers

Dmitry Finogeev dmitry.finogeev@cern.ch
07/2021

'''

from enum import Enum

import bitstring

import lib.pylog as pylog

log = pylog.log


class gen_mode(Enum):
    no_gen = 0
    main_gen = 1
    tx_gen = 2

    def __str__(self):
        return self.name

    @property
    def counter(self):
        return self.value


class readout_cmd(Enum):
    idle = 0
    continious = 1
    trigger = 2

    def __str__(self):
        return self.name

    @property
    def counter(self):
        return self.value


class control_reg:
    def __init__(self):
        self.data_gen = gen_mode.no_gen
        self.data_trg_respond_mask = 0
        self.data_bunch_pattern = 0
        self.data_bunch_freq = 0
        self.data_bc_start = 0
        self.data_orbit_jump = 0

        self.trg_gen = gen_mode.no_gen
        self.trg_rd_command = readout_cmd.idle
        self.trg_pattern_0 = 0
        self.trg_pattern_1 = 0
        self.trg_cont_val = 0
        self.trg_bunch_freq = 0
        self.trg_bc_start = 0
        self.trg_hbr_rate = 0

        self.rd_bypass = 0
        self.is_hb_response = 0
        self.is_hb_reject = 0
        self.trg_data_select = 0
        self.force_idle = 0
        self.rxclk_sync_shift = 0

        self.bcid_offset = 0


        self.reset_orbc_sync = 0
        self.reset_data_counters = 0
        self.reset_gensync = 0
        self.reset_gbt_rxerror = 0
        self.reset_readout = 0
        self.reset_gbt = 0
        self.reset_rxph_error = 0
        self.reset_err_report = 0

        self.RDH_FEEID = 0
        self.RDH_SYS_ID = 0
        self.RDH_PRT_BIT = 0

    def print_struct(self):
        log.info("======== control reg ========")
        log.info("data generator param:")
        log.info("    data_gen: %s" % (self.data_gen))
        log.info("    data_trg_respond_mask:%s" % (hex(self.data_trg_respond_mask)))
        log.info("    data_bunch_pattern: %s" % (hex(self.data_bunch_pattern)))
        log.info("    data_bunch_freq: %s" % (hex(self.data_bunch_freq)))
        log.info("    data_freq_offset: %s" % (hex(self.data_bc_start)))

        log.info("trigger generator param:")
        log.info("    trg_gen: %s" % (self.trg_gen))
        log.info("    trg_rd_command: %s" % (self.trg_rd_command))
        log.info("    trg_pattern_0: %s" % (hex(self.trg_pattern_0)))
        log.info("    trg_pattern_1: %s" % (hex(self.trg_pattern_1)))
        log.info("    trg_cont_val: %s" % (hex(self.trg_cont_val)))
        log.info("    trg_bunch_freq: %s" % (hex(self.trg_bunch_freq)))
        log.info("    trg_freq_offset: %s" % (hex(self.trg_bc_start)))
        log.info("    trg_hbr_rate: %s" % (hex(self.trg_hbr_rate)))

        log.info("readout param:")
        log.info("    rd_bypass: %s" % (hex(self.rd_bypass)))
        log.info("    is_hb_response: %s" % (hex(self.is_hb_response)))
        log.info("    is_hb_rject: %s" % (hex(self.is_hb_reject)))
        log.info("    trg_data_select: %s" % (hex(self.trg_data_select)))
        log.info("    strt_rdmode_lock: %s" % (hex(self.force_idle)))

        log.info("delay param:")
        log.info("    bcid_offset: %s" % (hex(self.bcid_offset)))

        log.info("reset param:")
        log.info("    reset_orbc_sync: %s" % (hex(self.reset_orbc_sync)))
        log.info("    reset_data_counters: %s" % (hex(self.reset_data_counters)))
        log.info("    reset_gensync: %s" % (hex(self.reset_gensync)))
        log.info("    reset_gbt_rxerror: %s" % (hex(self.reset_gbt_rxerror)))
        log.info("    reset_gbt: %s" % (hex(self.reset_gbt)))
        log.info("    reset_readout: %s" % (hex(self.reset_readout)))
        log.info("    reset_rxph_error: %s" % (hex(self.reset_rxph_error)))
        log.info("    reset_err_report: %s" % (hex(self.reset_err_report)))

        log.info("RDH param:")
        log.info("    RDH_feeid: %s" % (hex(self.RDH_FEEID)))
        log.info("    RDH_SYS_ID: %s" % (hex(self.RDH_SYS_ID)))
        log.info("    RDH_PRT_BIT: %s" % (hex(self.RDH_PRT_BIT)))

    def get_reg(self):

        bitarray = []

        reset_field = bitstring.pack('8*uint:1', self.reset_err_report, self.reset_readout, self.reset_rxph_error, self.reset_gbt,
                                     self.reset_gbt_rxerror,
                                     self.reset_gensync, self.reset_data_counters, self.reset_orbc_sync)
        rd_mode = bitstring.pack('6*uint:1', self.data_orbit_jump, self.rxclk_sync_shift, self.is_hb_reject, self.force_idle, self.rd_bypass, self.is_hb_response)

        bitarray.append(
            bitstring.pack('uint:6=0, uint:6, uint:4,  uint:8, 2*uint:4', rd_mode.uint, self.trg_rd_command.value,
                           reset_field.uint, self.trg_gen.value, self.data_gen.value))
        bitarray.append(bitstring.pack('uint:32', self.data_trg_respond_mask))
        bitarray.append(bitstring.pack('uint:32', self.data_bunch_pattern))
        bitarray.append(bitstring.pack('uint:32=0'))
        bitarray.append(bitstring.pack('uint:32', self.trg_pattern_1))
        bitarray.append(bitstring.pack('uint:32', self.trg_pattern_0))
        bitarray.append(bitstring.pack('uint:32', self.trg_cont_val))

        bitarray.append(bitstring.pack('2*uint:16', self.trg_bunch_freq, self.data_bunch_freq))
        bitarray.append(bitstring.pack('uint:4, uint:12, uint:16', self.trg_hbr_rate, self.trg_bc_start, self.data_bc_start))
        bitarray.append(bitstring.pack('2*uint:8, uint:16', self.RDH_PRT_BIT, self.RDH_SYS_ID, self.RDH_FEEID))
        bitarray.append(bitstring.pack('uint:32=0'))
        bitarray.append(bitstring.pack('uint:20=0, uint:12', self.bcid_offset))
        bitarray.append(bitstring.pack('uint:32', self.trg_data_select))

        return bitarray

    def set_reg(self, bitarray):

        self.data_gen = gen_mode(bitarray[0][-4:].uint)
        self.trg_gen = gen_mode(bitarray[0][-8:-4].uint)
        self.reset_orbc_sync = bitarray[0][-9:-8].uint
        self.reset_data_counters = bitarray[0][-10:-9].uint
        self.reset_gensync = bitarray[0][-11:-10].uint
        self.reset_gbt_rxerror = bitarray[0][-12:-11].uint
        self.reset_gbt = bitarray[0][-13:-12].uint
        self.reset_rxph_error = bitarray[0][-14:-13].uint
        self.reset_readout = bitarray[0][-15:-14].uint
        self.trg_rd_command = readout_cmd(bitarray[0][-20:-16].uint)
        self.is_hb_response = bitarray[0][-21:-20].uint
        self.rd_bypass = bitarray[0][-22:-21].uint
        self.force_idle = bitarray[0][-23:-22].uint
        self.is_hb_reject = bitarray[0][-24:-23].uint
        self.rxclk_sync_shift = bitarray[0][-25:-24].uint
        self.data_orbit_jump = bitarray[0][-26:-25].uint

        self.data_trg_respond_mask = bitarray[1][:].uint
        self.data_bunch_pattern = bitarray[2][:].uint
        self.trg_pattern_1 = bitarray[4][:].uint
        self.trg_pattern_0 = bitarray[5][:].uint
        self.trg_cont_val = bitarray[6][:].uint
        self.data_bunch_freq = bitarray[7][-16:].uint
        self.trg_bunch_freq = bitarray[7][-32:-16].uint
        self.data_bc_start = bitarray[8][-16:].uint
        self.trg_bc_start = bitarray[8][-32:-16].uint
        self.RDH_SYS_ID = bitarray[9][-24:-16].uint
        self.RDH_FEEID = bitarray[9][-16:].uint
        self.RDH_PRT_BIT = bitarray[10][-32:-24].uint
        self.bcid_offset = bitarray[11][-12:].uint
        self.trg_data_select = bitarray[12][:].uint

    def get_reg_line_16(self):
        res_str = ""
        for ireg in self.get_reg():
            res_str += str(ireg[-32:-16].uint) + " " + str(ireg[-16:].uint) + " "
        return res_str

    def set_reg_line_16(self, line):
        line_regs = line.split(" ")
        bitarray = []
        for ireg in range(0, len(line_regs) - 1, 2):
            bitarray.append(bitstring.pack('0x00000000, 2*uint:16', int(line_regs[ireg]), int(line_regs[ireg + 1])))
        self.set_reg(bitarray)
