'''

Check correctness of RUN data, report results

Dmitry Finogeev dmitry.finogeev@cern.ch
07/2021

'''

import lib.constants as cnst
import lib.pylog as pylog
from lib.rdh_data_packet import rdh_packet
from lib.run_reader import run_reader
from lib.control_reg import readout_cmd


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
                self.log.info(pylog.c_FAIL + "data reading error [pos: %i] : %s" % (
                    self.run.gbt_pos_iter[pos], check_res) + pylog.c_ENDC)
                return check_res

            self.rdh_packet_list.append(rdh)
            # rdh.print_struct(self.log)

        return 0

    # check RDH data and report result
    def test_data(self):

        # reading RDH packets and data:
        read_report = self.read_data()
        if read_report == 0:
            self.log.info(pylog.c_OKGREEN + "Data was successfully read ..." + pylog.c_ENDC)
        else:
            return 0

        #for i in self.rdh_packet_list: i.print_struct(self.log)

        # cheking HB rdh pattern
        trg_check_list = []
        for trg in self.run.trg_data:
            if (trg['trigger'] & cnst.TRG_const_HB) == 0: continue

            # collecting all rdh for current HB
            hb_rdh_list = []
            for irdh in self.rdh_packet_list:
                if irdh.rdh_header.orbit == trg['orbit'] and irdh.rdh_header.bc == trg['bc']:
                    hb_rdh_list.append(irdh)

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
                    self.log.info(
                        pylog.c_FAIL + "wrong counter in event [%i]: %i for %s" % (i, hb_rdh_list[i].rdh_header.page_counter, str(trg)) + pylog.c_ENDC)

        # strart / stop triggers
        run_cnt = self.run.run_meta.ctrl_reg.trg_rd_command == readout_cmd.continious
        if  (self.rdh_packet_list[0].rdh_header.trg_type & (cnst.TRG_const_SOC if run_cnt else cnst.TRG_const_SOT)) == 0:
            self.log.info(pylog.c_FAIL + "SOX not found" % () + pylog.c_ENDC)
        if  self.rdh_packet_list[-1].rdh_header.trg_type & (cnst.TRG_const_EOC if run_cnt else cnst.TRG_const_EOT) == 0:
            self.log.info(pylog.c_FAIL + "EOX not found" % () + pylog.c_ENDC)


            trg_check_list.append(trg)

        self.log.info(pylog.c_OKGREEN + "HB rdh pattern [hb response, stop bit, rdh counter, XOX] checked for HBs:%s" % (
            str(trg_check_list)) + pylog.c_ENDC)
