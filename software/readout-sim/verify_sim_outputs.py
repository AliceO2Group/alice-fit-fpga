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
        sim_run = run_reader(irun)
        sim_run.print_run_info()
        run_test = run_tester(sim_run)
        run_test.test_data


if __name__ == '__main__':
    verify_sim_outputs()
