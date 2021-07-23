'''

The class read simulation outputs and decode run data
take run_generator object as run metadata

Dmitry Finogeev dmitry.finogeev@cern.ch
07/2021

'''
import lib.pylog as pylog
from lib.constants import filename_simout
from lib.run_generator import run_generator
from lib.status_reg import status_reg


class run_reader:
    def __init__(self, run_meta=run_generator()):
        self.run_meta = run_meta
        self.filename_simout = filename_simout

        self.gbt_data = []
        self.gen_data = []
        self.trg_data = []

        self.run_valid = False

        self.log = pylog.log

        self.read_run()

    def print_run_info(self):
        self.log.info("============================================")
        self.run_meta.print_run_meta()
        self.log.info("============================================")
        self.log.info("RUN VALID: %s" % (str(self.run_valid)))
        self.log.info("GBT data size: %i" % (len(self.gbt_data)))
        self.log.info("GEN data size: %i" % (len(self.gen_data)))
        self.log.info("TRG data size: %i" % (len(self.trg_data)))

    def read_run(self):
        simout_list = list(open(self.filename_simout, 'r'))
        if self.run_meta.run_pos_stop > len(simout_list):
            self.log.error(
                "Simulation ountput is to short. len: %i, run_stop: %i. Check that simulation was finished" % (
                    len(simout_list), self.run_meta.run_pos_stop))

        self.gbt_data = []
        self.gen_data = []
        self.trg_data = []

        # iteration through simulation outputs
        for iline in range(self.run_meta.run_pos_start, self.run_meta.run_pos_stop):
            line = simout_list[iline].replace('X', '0')
            line_regs = line.split("   ")[:-1]

            # readout status in cycle
            istatus = status_reg(line_regs[1:])

            # collecting GBT data
            gbt_word = line_regs[0]
            gbt_word_int = int(gbt_word, base=16)
            if gbt_word_int != 0x10000000000000000000 and gbt_word_int != 0x20000000000000000000 and gbt_word_int > 0: self.gbt_data.append(
                gbt_word)

            # collecting generated data
            if istatus.data_gen_size > 0:
                self.gen_data.append(
                    {'size': istatus.data_gen_size, 'bc': istatus.data_gen_bc, 'orbit': istatus.data_gen_orbit})

            # collecting trigger data
            if istatus.cru_trigger > 0:
                self.trg_data.append({'trigger': istatus.cru_trigger, 'bc': istatus.cru_bc, 'orbit': istatus.cru_orbit})

            # check fsm error
            if istatus.fsm_errors > 0:
                self.log.info("FSM ERROR in run found: %s" % istatus.get_fsm_err_msg())
                return

        self.run_valid = True
