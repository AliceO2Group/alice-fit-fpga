'''

Decode GBT RDH data: RDH, detector packet
Check data consistency

Dmitry Finogeev dmitry.finogeev@cern.ch
07/2021

'''
import lib.constants as cnst
import lib.pylog as pylog
from lib.control_reg import control_reg as ctrl_reg

log = pylog.log


class detector_packet:
    def __init__(self):
        self.gbt_data = []

        self.magic = 0
        self.size = 0
        self.is_tcm = 0
        self.phase_err = 0
        self.phase = 0
        self.bc = 0
        self.orbit = 0
        self.payload = []
        self.pck_num = 0

    def print_struct(self, log):
        log.info("magic: 0x%x" % (self.magic))
        log.info("is_tcm: 0x%x" % (self.is_tcm))
        log.info("n_words: 0x%x" % (self.size))
        log.info("phase_err: 0x%x" % (self.phase_err))
        log.info("phase: 0x%x" % (self.phase))
        log.info("bc: 0x%x" % (self.bc))
        log.info("orbit: 0x%x" % (self.orbit))
        log.info("payload: %s" % (str(self.payload)))
        # for idata in self.payload:
        # log.info("[0x%x, 0x%x]:" % (idata[0], idata[1]))

    def read_data(self, line_list, pos):
        # - 20-19 19-18 18-17 17-16 16-15 15-14 14-13 13-12 12-11 11-10 10- 9 9 - 8 8 - 7 7 - 6 6 - 5 5 - 4 4 - 3 3 - 2 2 - 1 1 -
        #   79-76 75-72 71-68 67-64 63-60 59-56 55-52 51-48 47-44 43-40 39-36 35-32 31-28 27-24 23-20 19-16 15-12 11- 8 7 - 4 3 - 0

        # reading header
        self.gbt_data.append(line_list[pos])
        self.magic = int(self.gbt_data[0][-20: -19], base=16)  # [79 - 76]
        self.size = int(self.gbt_data[0][-19: -18], base=16)  # [75 - 72]
        self.is_tcm = int(self.gbt_data[0][-13: -12], base=16)  # [75 - 72]
        pherr_ = int(self.gbt_data[0][-12: -11], base=16)  # [47 - 44]
        self.phase = pherr_ & 0x7
        self.phase_err = (pherr_ & 0x8 > 0)
        self.orbit = int(self.gbt_data[0][-10: -3], base=16)  # [39 - 12]
        self.bc = int(self.gbt_data[0][-3:], base=16)  # [11 - 0]

        self.payload = []
        for iword in range(1, self.size + 1):
            if pos + iword >= len(line_list):
                log.info(pylog.c_FAIL+"Out of GBT data list while detector data reading ... "+pylog.c_ENDC)
                return -1

            self.gbt_data.append(line_list[pos + iword])
            if self.is_tcm == 0:
                ch1_no = int(self.gbt_data[-1][-20: -19], base=16)
                ch1_data = int(self.gbt_data[-1][-19: -10], base=16)
                ch2_no = int(self.gbt_data[-1][-10:  -9], base=16)
                ch2_data = int(self.gbt_data[-1][-9:], base=16)

                # if ch1_no > 0: self.payload.append([ch1_no, ch1_data])
                # if ch2_no > 0: self.payload.append([ch2_no, ch2_data])
                self.payload.append([ch1_no, ch1_data])
                self.payload.append([ch2_no, ch2_data])
                self.pck_num = ch1_data  # same for all words
            else:
                self.payload = [[0, 0]]
        # todo

        return pos + 1 + self.size

    def check_data(self):
        res = 0
        if self.magic != 0xf: res = "wrong magic: %i" % self.magic
        if self.size > 0xf or self.size < 1: res = "wrong size: %i" % self.size
        if len(self.payload) != self.size * 2: res = "wrong payload %i, size %i" % (len(self.payload), self.size)

        if res != 0:
            self.print_struct(log)
            log.info("Data check error: %s\n%s" % (res, str(self.gbt_data)))

        return res


class rdh_header:
    def __init__(self):
        self.gbt_data_pos = 0
        self.gbt_data = []

        self.header_version = 0
        self.header_size = 0
        self.det_field = 0
        self.par_bit = 0

        self.fee_id = 0
        self.sys_id = 0
        self.priority_bit = 0
        self.orbit = 0
        self.bc = 0
        self.trg_type = 0
        self.stop_bit = 0
        self.page_counter = 0
        self.offset_new_packet = 0

    def print_struct(self, log):
        log.info("header_version: 0x%x" % (self.header_version))
        log.info("header_size: 0x%x" % (self.header_size))
        log.info("det_field: 0x%x" % (self.det_field))
        log.info("par_bit: 0x%x" % (self.par_bit))
        log.info("fee_id: 0x%x" % (self.fee_id))
        log.info("sys_id: 0x%x" % (self.sys_id))
        log.info("priority_bit: 0x%x" % (self.priority_bit))
        log.info("orbit: 0x%x" % (self.orbit))
        log.info("bc: 0x%x" % (self.bc))
        log.info("trg_type: 0x%x" % (self.trg_type))
        log.info("stop_bit: 0x%x" % (self.stop_bit))
        log.info("page_counter: 0x%x" % (self.page_counter))
        log.info("offset_new_packet: 0x%x" % (self.offset_new_packet))

    def read_data(self, line_list, pos):
        self.gbt_data_pos = pos
        self.gbt_data = line_list[pos:pos + 4]

        self.header_version = int(self.gbt_data[0][-2:], base=16)  # [7  -  0]

        if self.header_version == 0x6:
            # - 20-19 19-18 18-17 17-16 16-15 15-14 14-13 13-12 12-11 11-10 10- 9 9 - 8 8 - 7 7 - 6 6 - 5 5 - 4 4 - 3 3 - 2 2 - 1 1 -
            #   79-76 75-72 71-68 67-64 63-60 59-56 55-52 51-48 47-44 43-40 39-36 35-32 31-28 27-24 23-20 19-16 15-12 11- 8 7 - 4 3 - 0
            self.header_size = int(self.gbt_data[0][-4: -2], base=16)  # [15 - 8]
            self.fee_id = int(self.gbt_data[0][-8: -4], base=16)  # [31 - 16]
            self.priority_bit = int(self.gbt_data[0][-10:-8], base=16)  # [39 - 32]
            self.sys_id = int(self.gbt_data[0][-12: -10], base=16)  # [47 - 40]
            self.offset_new_packet = int(self.gbt_data[0][-20: -16], base=16)  # [79 - 64]

            self.bc = int(self.gbt_data[1][-3:], base=16)  # [11 - 0]
            self.orbit = int(self.gbt_data[1][-16: -8], base=16)  # [63 - 32]

            self.trg_type = int(self.gbt_data[2][-8:], base=16)  # [31 - 0]
            self.page_counter = int(self.gbt_data[2][-12:-8], base=16)  # [47 - 32]
            self.stop_bit = int(self.gbt_data[2][-14: -12], base=16)  # [55 - 48]

            self.det_field = int(self.gbt_data[3][-8:], base=16)  # [31 - 0]
            self.par_bit = int(self.gbt_data[3][-12: -8], base=16)  # [47 - 32]
        return pos + 4

    def check_data(self, ctrl=ctrl_reg()):
        res = 0
        if self.header_version != 0x6: res = "wrong version: 0x%x [0x%x]" % (self.header_version, 0x6)
        if self.header_size != 0x40: res = "wrong size: %i [0x%x]" % (self.header_size, 0x40)
        if self.det_field != 0x0: res = "wrong det field: 0x%x [0x%x]" % (self.det_field, 0x0)
        if self.par_bit != 0x0: res = "wrong par: 0x%x [0x%x]" % (self.par_bit, 0x0)

        if self.fee_id != ctrl.RDH_FEEID: res = "wrong fee id: 0x%x [0x%x]" % (self.fee_id, ctrl.RDH_FEEID)
        if self.sys_id != ctrl.RDH_SYS_ID: res = "wrong sys id: 0x%x [0x%x]" % (self.sys_id, ctrl.RDH_SYS_ID)
        if self.priority_bit != ctrl.RDH_PRT_BIT: res = "wrong priority_bit: 0x%x [0x%x]" % (self.par_bit, ctrl.RDH_PRT_BIT)

        if self.offset_new_packet > cnst.max_rdh_payload * 16: res = "rdh oversize: 0x%x [0x%x]" % (self.offset_new_packet, cnst.max_rdh_payload*16)

        if res != 0:
            log.info("RDH %i, orbit %04x check error [line %i] : %s\n%s" % (self.page_counter, self.orbit, self.gbt_data_pos, res, str(self.gbt_data)))

        return res


class rdh_packet:
    def __init__(self):
        self.rdh_header = rdh_header()
        self.event_list = []

    def print_raw(self):
        for igbt in self.rdh_header.gbt_data: print(hex(igbt))
        for event in self.event_list:
            for igbt in event.gbt_data: print(hex(igbt))

    def print_struct(self, log):
        log.info("######################## RDH ########################")
        self.rdh_header.print_struct(log)
        for event in self.event_list:
            log.info("=== EVENT ===")
            event.print_struct(log)

    def read_data(self, line_list, pos):
        dyn_pos = self.rdh_header.read_data(line_list, pos)
        n_dw_in_packet = (self.rdh_header.offset_new_packet / 16) - 4

        packet_start = dyn_pos
        while dyn_pos < packet_start + n_dw_in_packet:
            dyn_event = detector_packet()
            dyn_pos = dyn_event.read_data(line_list, dyn_pos)
            if dyn_pos < 0: return -1
            self.event_list.append(dyn_event)

        return dyn_pos

    def check_data(self, ctrl=ctrl_reg()):

        # check correctness of header
        res = self.rdh_header.check_data(ctrl)
        if res != 0: return res

        # check correctness of data
        for event in self.event_list:
            res = event.check_data()
            if res != 0: return res

        # check orbits in data
        for event in self.event_list:
            if event.orbit != self.rdh_header.orbit:
                return "event orbit != rdh orbit"
        return 0
