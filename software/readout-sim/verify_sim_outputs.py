'''

Main function to verify readout simulation outputs

Dmitry Finogeev dmitry.finogeev@cern.ch
07/2021

'''

import copy
import pickle

import lib.constants as cnst
from lib.control_reg import control_reg as ctrl_rec
from lib.control_reg import gen_mode, readout_cmd
from lib.run_generator import run_generator as run_generator
from lib.run_reader import run_reader

def generate_sim_inputs():

    # loading run metadata
    with open(cnst.filename_runmeta, 'rb') as f:
        run_list = pickle.load(f)

    # print generated runs
    for irun in run_list: irun.print_run_meta()


    # read simulation outputs
    sim_run = run_reader(run_list[1])
    for i in sim_run.gbt_data: print(hex(i))














if __name__ == '__main__':
    generate_sim_inputs()
