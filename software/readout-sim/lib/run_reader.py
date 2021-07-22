'''

Class read simulation outputs and decode run data
take run_generato object as run metadata

Dmitry Finogeev dmitry.finogeev@cern.ch
07/2021

'''
import lib.pylog as pylog
from lib.control_reg import control_reg as ctrl_reg
from lib.control_reg import gen_mode, readout_cmd
from lib.constants import filename_ctrlreg
from lib.constants import filename_simout
from lib.constants import orbit_size
from lib.run_generator import run_generator
from lib.status_reg import status_reg

class run_reader:
    def __init__(self, run_meta = run_generator()):
        self.run_meta = run_meta
        self.filename_simout = filename_simout

        self.gbt_data=[]

        self.run_valid = False

        self.log = pylog.log

        self.read_run()

    def read_run(self):
        simout_list = list( open(self.filename_simout, 'r') )
        self.gbt_data = []

        for iline in range(self.run_meta.run_pos_start, self.run_meta.run_pos_stop):
            line = simout_list[iline].replace('X', '0')
            line_regs = line.split("   ")[:-1]

            istatus = status_reg(line_regs[1:])
            if istatus.data_gen_size>0:  istatus.print_struct()

            gbt_word = int(line_regs[0], base=16)
            if gbt_word > 0: self.gbt_data.append(gbt_word)


            # check fsm error
            if istatus.fsm_errors > 0:
                self.log.info("FSM ERROR in run found: %s"%istatus.get_fsm_err_msg())
                return


