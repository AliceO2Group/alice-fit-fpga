'''

Check correctness of RUN data, report results

Dmitry Finogeev dmitry.finogeev@cern.ch
07/2021

'''

import lib.pylog as pylog

import lib.constants as cnst
from lib.run_reader import run_reader
from lib.rdh_data_packet import rdh_packet



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
                self.log.info(pylog.c_FAIL + "data reading error [pos: %i] : %s" %(self.run.gbt_pos_iter[pos], check_res) + pylog.c_ENDC)
                return check_res

            self.rdh_packet_list.append(rdh)
            #rdh.print_struct(self.log)


        return 0

    # check RDH data and report result
    def test_data(self):

        # reading RDH packets and data:
        read_report = self.read_data()
        if read_report == 0:
            self.log.info(pylog.c_OKGREEN + "Data was successfully read ..." + pylog.c_ENDC)
        else:
            return 0

        for i in self.rdh_packet_list: i.print_struct(self.log)

        #cheking HB rdh pattern
        trg_check_list = []
        for trg in self.run.trg_data:
            if (trg['trigger'] & cnst.TRG_const_HB) == 0: continue

            # collecting all rdh for current HB
            hb_rdh_list = []
            for irdh in self.rdh_packet_list:
                if irdh.rdh_header.orbit == trg['orbit'] and irdh.rdh_header.bc == trg['bc']:
                    hb_rdh_list.append(irdh)

            if len(hb_rdh_list) == 0:
                self.log.info(pylog.c_FAIL + "no RDH found for %s"%(str(trg)) + pylog.c_ENDC)
                return 0

            trg_check_list.append(trg)

        self.log.info(pylog.c_OKGREEN + "HB rdh pattern checked for HBs:%s"%(str(trg_check_list)) + pylog.c_ENDC)



