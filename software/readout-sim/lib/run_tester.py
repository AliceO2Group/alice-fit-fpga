'''

Check correctness of RUN data, report results

Dmitry Finogeev dmitry.finogeev@cern.ch
07/2021

'''
import copy

import lib.constants as cnst
import lib.pylog as pylog
from lib.control_reg import readout_cmd
from lib.rdh_data_packet import rdh_packet
from lib.run_reader import run_reader


class run_tester:
    def __init__(self, run=run_reader()):

        self.run = run
        self.rdh_packet_list = []

        self.log = pylog.log

    # read all RDH packets in RUN and check data consistency
    def read_data(self):

        # reading rdh packets
        pos = 0
        while pos < len(self.run.gbt_data):
            rdh = rdh_packet()
            pos = rdh.read_data(self.run.gbt_data, pos)

            # check RDH after reading
            check_res = rdh.check_data(self.run.run_meta.ctrl_reg)
            if check_res != 0:
                rdh.print_struct(self.log)
                self.log.info(pylog.c_FAIL + "data reading error [pos: %i] : %s" % (self.run.gbt_pos_iter[pos], check_res) + pylog.c_ENDC)
                return check_res

            self.rdh_packet_list.append(rdh)
            # rdh.print_struct(self.log)

        return 0

    # check RDH data and report result
    @property
    def test_data(self):

        # reading RDH packets and data:
        read_report = self.read_data()
        if read_report == 0:
            self.log.info(pylog.c_OKGREEN + "Data was successfully read ..." + pylog.c_ENDC)
        else:
            return 0

        # for irdh in self.rdh_packet_list: self.log.info("RDH %i, orbit %04x, events: %i" % (self.rdh_packet_list.index(irdh), irdh.rdh_header.orbit, len(irdh.event_list)))

        # cheking HB rdh pattern
        trg_check_list = []
        for trg in self.run.trg_data:
            if (trg['trigger'] & cnst.TRG_const_HB) == 0: continue

            # collecting all rdh for current HB
            hb_rdh_list = []
            for irdh in self.rdh_packet_list:
                if irdh.rdh_header.orbit == trg['orbit'] and irdh.rdh_header.bc == trg['bc']: hb_rdh_list.append(irdh)

            # HB response
            if len(hb_rdh_list) == 0:
                self.log.info(pylog.c_FAIL + "no RDH found for %s" % (str(trg)) + pylog.c_ENDC)
                return 0

            # stop bit
            if hb_rdh_list[-1].rdh_header.stop_bit != 1:
                self.log.info(pylog.c_FAIL + "wrong stop bit for %s" % (str(trg)) + pylog.c_ENDC)
                return 0
            for i in range(0, len(hb_rdh_list) - 1):
                if hb_rdh_list[i].rdh_header.stop_bit != 0:
                    self.log.info(
                        pylog.c_FAIL + "stop bit is 1 in not last event [%i] for %s" % (i, str(trg)) + pylog.c_ENDC)

            # rhd counter
            for i in range(0, len(hb_rdh_list)):
                if hb_rdh_list[i].rdh_header.page_counter != i:
                    self.log.info(pylog.c_FAIL + "wrong counter in event [%i]: %i for %s" % (i, hb_rdh_list[i].rdh_header.page_counter, str(trg)) + pylog.c_ENDC)

            trg_check_list.append(trg)

        # strart / stop triggers
        run_cnt = self.run.run_meta.ctrl_reg.trg_rd_command == readout_cmd.continious
        if (self.rdh_packet_list[0].rdh_header.trg_type & (cnst.TRG_const_SOC if run_cnt else cnst.TRG_const_SOT)) == 0:
            self.log.info(pylog.c_FAIL + "SOX not found" % () + pylog.c_ENDC)
        if self.rdh_packet_list[-1].rdh_header.trg_type & (cnst.TRG_const_EOC if run_cnt else cnst.TRG_const_EOT) == 0:
            self.log.info(pylog.c_FAIL + "EOX not found" % () + pylog.c_ENDC)

        self.log.info(pylog.c_OKGREEN + "HB rdh pattern [hb response, stop bit, rdh counter, XOR] checked for %i HBs:" % (len(trg_check_list)) + pylog.c_ENDC)
        if len(trg_check_list) != self.run.stop_ortbit - self.run.start_orbit + 1: self.log.info(pylog.c_FAIL + "HB trigger count is wrong" + pylog.c_ENDC)
        self.log.info([("trg: %x; orbc %04x:%03x" % (itrg['trigger'], itrg['orbit'], itrg['bc'])) for itrg in trg_check_list])

        # counting generated data including to RDH
        gen_data_list = copy.copy(self.run.gen_data)
        read_data_list = [ievent for irdh in self.rdh_packet_list for ievent in irdh.event_list]
        read_data_count = len(read_data_list)
        for igen in copy.copy(gen_data_list):
            for ievent in copy.copy(read_data_list):
                if ievent.pck_num == igen['pck_num'] and ievent.orbit == igen['orbit'] and ievent.bc == igen['bc'] and ievent.size == igen['size']:
                    gen_data_list.remove(igen)
                    read_data_list.remove(ievent)

        if len(gen_data_list) > 0:
            self.log.info("Generated data not found in RDH packets: %i; %s" % (
                len(gen_data_list), [("[pnum: %x; orbc %04x:%03x; sz: %i]" % (idat['pck_num'], idat['bc'], idat['orbit'], idat['size'])) for idat in gen_data_list]))
        if len(read_data_list) > 0:
            self.log.info(pylog.c_FAIL + "RDH data not found in generated data: %i; %s" % (
                len(read_data_list), [("[pnum: %x; orbc %04x:%03x; sz: %i]" % (iev.pck_num, iev.bc, iev.orbit, iev.size)) for iev in read_data_list]) + pylog.c_ENDC)

        is_correct = len(self.run.gen_data) == read_data_count + self.run.last_status.sel_drop_cnt
        self.log.info((pylog.c_OKGREEN if is_correct else pylog.c_FAIL) + "Generated data: %i; Readed data: %i; missed data: %i; dropped data: %i" % (
            len(self.run.gen_data), read_data_count, len(gen_data_list), self.run.last_status.sel_drop_cnt) + pylog.c_ENDC)
