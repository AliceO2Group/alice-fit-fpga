'''

Main function to verify readout simulation outputs

Dmitry Finogeev dmitry.finogeev@cern.ch
07/2021

'''

import pickle

import lib.constants as cnst
import lib.pylog as pylog
from lib.run_reader import run_reader
from lib.run_tester import run_tester

log = pylog.log


def verify_sim_outputs():
    # loading run metadata
    with open(cnst.filename_runmeta, 'rb') as f:
        run_list = pickle.load(f)

    for irun in run_list:
        log.info("============================================")
        irun.print_run_meta()
        log.info("============================================")

        sim_run = run_reader(irun)
        if not sim_run.run_valid:
            log.info(pylog.c_FAIL + "RUN reader failed\n\n\n\n" + pylog.c_ENDC)
            continue

        sim_run.print_run_info()
        run_test = run_tester(sim_run)
        run_test.test_data
        log.info("============================================\n\n\n\n")


if __name__ == '__main__':
    verify_sim_outputs()
