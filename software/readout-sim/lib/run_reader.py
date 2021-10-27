'''

The class read simulation outputs and decode run data
take run_generator object as run metadata

Dmitry Finogeev dmitry.finogeev@cern.ch
07/2021

'''

import copy

import lib.constants as cnst
import lib.pylog as pylog
from lib.constants import TRG_const_HBr
from lib.constants import filename_simout
from lib.control_reg import readout_cmd
from lib.run_generator import run_generator
from lib.status_reg import status_reg


class run_reader:
    def __init__(self, run_meta=run_generator()):
        self.run_meta = run_meta
        self.filename_simout = filename_simout

        self.gbt_data = []
        self.gbt_pos_iter = []  # gbt words position in simulation data flow
        self.gen_data = []
        self.trg_data = []
        self.last_status = 0

        self.run_valid = False
        self.start_orbit = 0
        self.stop_ortbit = 0

        self.log = pylog.log

        self.read_run()

    def print_run_info(self):
        self.log.info("RUN VALID: %s" % (str(self.run_valid)))
        self.log.info("GBT data size: %i" % (len(self.gbt_data)))
        self.log.info("GEN data size: %i" % (len(self.gen_data)))
        self.log.info("TRG data size: %i" % (len(self.trg_data)))
        self.log.info("ORBIT RANGE %i [%04x : %04x]" % (self.stop_ortbit - self.start_orbit + 1, self.start_orbit, self.stop_ortbit))

    def read_run(self):
        self.run_valid = False
        simout_list = list(open(self.filename_simout, 'r'))
        if self.run_meta.run_pos_stop > len(simout_list):
            self.log.error("Simulation ountput is to short. len: %i, run_stop: %i. Check that simulation was finished" % (len(simout_list), self.run_meta.run_pos_stop))

        self.gbt_data = []
        self.gen_data = []
        self.trg_data = []
        trg_run_ongoing = False
        sending_mode = False

        # iteration through simulation outputs
        for iline in range(self.run_meta.run_pos_start, self.run_meta.run_pos_stop):
            if iline >= len(simout_list):
                self.log.info(pylog.c_FAIL + "End of simulation output file reached, check that vivado simulation finished" + pylog.c_ENDC)
                return 0

            line_regs = simout_list[iline].replace('X', '0').split("   ")[:-1]

            # readout status in cycle
            istatus = status_reg(line_regs[2:])

            # check fsm error
            if (istatus.fsm_errors & 0x7FFF) > 0 and iline > 10:
                self.log.info("FSM ERROR in run found: %s" % istatus.get_fsm_err_msg())
                return 0

            # collecting GBT data
            is_gbt_word = int(line_regs[0], base=16)
            gbt_word = line_regs[1]
            if is_gbt_word > 0:  self.gbt_data.append(gbt_word); self.gbt_pos_iter.append(iline); self.last_status = istatus

            # collecting generated data
            if istatus.data_gen_size > 0:
                # select data by data_enabled
                if istatus.data_enabled: self.gen_data.append(
                    # size is +1 for zero packets indication
                    {'size': istatus.data_gen_size, 'pck_num': istatus.data_gen_packnum, 'bc': istatus.data_gen_bc, 'orbit': istatus.data_gen_orbit})

            # collecting trigger data
            if istatus.cru_trigger > 0:
                if (istatus.cru_trigger & cnst.TRG_const_SOC) or (istatus.cru_trigger & cnst.TRG_const_SOT): trg_run_ongoing = True; self.start_orbit = istatus.cru_orbit
                if trg_run_ongoing and istatus.readout_mode != readout_cmd.idle: self.trg_data.append({'trigger': istatus.cru_trigger, 'bc': istatus.cru_bc, 'orbit': istatus.cru_orbit})
                if (istatus.cru_trigger & cnst.TRG_const_EOC) or (istatus.cru_trigger & cnst.TRG_const_EOT): trg_run_ongoing = False; self.stop_ortbit = istatus.cru_orbit

        # deleting data in HBr orbits
        if self.run_meta.ctrl_reg.is_hb_reject:
            for itrg in self.trg_data:
                if (itrg['trigger'] & TRG_const_HBr) > 0:
                    for igen in copy.copy(self.gen_data):
                        if igen['orbit'] == itrg['orbit']:
                            self.gen_data.remove(igen)

        # deleting data not matched to trigger in trg run
        if self.run_meta.ctrl_reg.trg_rd_command == readout_cmd.trigger:
            for igen in copy.copy(self.gen_data):
                trg_found = False
                for itrg in self.trg_data:
                    if itrg['orbit'] == igen['orbit'] and itrg['bc'] == igen['bc'] and (itrg['trigger'] & self.run_meta.ctrl_reg.trg_data_select) > 0: trg_found = True
                if not trg_found: self.gen_data.remove(igen)

        self.run_valid = True
        return 1
