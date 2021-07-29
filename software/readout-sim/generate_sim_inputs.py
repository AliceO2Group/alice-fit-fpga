'''

Main function for generating inputs for readout simulation

Dmitry Finogeev dmitry.finogeev@cern.ch
07/2021

'''

import copy
import pickle

import lib.constants as cnst
from lib.control_reg import control_reg as ctrl_rec
from lib.control_reg import gen_mode, readout_cmd
from lib.run_generator import run_generator as run_generator


def generate_sim_inputs():
    run_len = 10

    # class instances
    test_ctrl_reg = ctrl_rec()
    run_gen = run_generator(test_ctrl_reg)
    run_gen.reset_file()
    run_list = []

    # common control registers parameters
    test_ctrl_reg.data_gen = gen_mode.main_gen
    test_ctrl_reg.trg_gen = gen_mode.main_gen
    test_ctrl_reg.trg_single_val = 0
    test_ctrl_reg.rd_bypass = 0
    test_ctrl_reg.is_hb_response = 1
    test_ctrl_reg.force_idle = 0
    test_ctrl_reg.reset_orbc_sync = 0
    test_ctrl_reg.reset_data_counters = 0
    test_ctrl_reg.reset_gensync = 0
    test_ctrl_reg.reset_gbt_rxerror = 0
    test_ctrl_reg.reset_readout = 0
    test_ctrl_reg.reset_gbt = 0
    test_ctrl_reg.reset_rxph_error = 0
    test_ctrl_reg.RDH_FEEID = 0xAAAA
    test_ctrl_reg.RDH_SYS_ID = 0xBB
    test_ctrl_reg.RDH_PRT_BIT = 0xCC

    # RENERATING RUN ========================================
    run_gen.run_comment = """
        - CONTINIOUS RUN
        - DATA GEN TEST
        - 2 packets per orbit
           - no gaps
           - lenght 16
           - lenght 1
        - 48 CLB triggers with data response
           - without gaps
           - gap = 1
           - 0xFFAFFAA...
        """
    test_ctrl_reg.trg_rd_command = readout_cmd.continious
    test_ctrl_reg.bcid_offset = 0x50
    test_ctrl_reg.data_trg_respond_mask = cnst.TRG_const_Cal
    test_ctrl_reg.data_bunch_pattern = 0xFF011777
    test_ctrl_reg.data_bunch_freq = cnst.orbit_size
    test_ctrl_reg.data_bc_start = 0x100
    test_ctrl_reg.trg_pattern_0 = 0xAAFAAFAF
    test_ctrl_reg.trg_pattern_1 = 0xFFAFFAFF
    test_ctrl_reg.trg_cont_val = cnst.TRG_const_Cal
    test_ctrl_reg.trg_bunch_freq = cnst.orbit_size
    test_ctrl_reg.trg_bc_start = 0x600
    test_ctrl_reg.trg_data_select = cnst.TRG_const_Cal
    run_gen.ctrl_reg = copy.copy(test_ctrl_reg)
    run_gen.generate_ctrl_pattern(run_len)
    run_list.append(copy.copy(run_gen))
    # =======================================================

    # RENERATING RUN ========================================
    run_gen.run_comment = """
        - CONTINIOUS RUN
        - data in first RDH
        - 4 X 8 packets per orbit
           - no gaps
           - lenght 16
           - lenght 1
        - 48 CLB triggers with data response
           - without gaps
           - gap = 1
           - 0xFFAFFAA...
        """
    test_ctrl_reg.trg_rd_command = readout_cmd.continious
    test_ctrl_reg.bcid_offset = 0x0
    test_ctrl_reg.data_trg_respond_mask = cnst.TRG_const_Cal
    test_ctrl_reg.data_bunch_pattern = 0xFF011777
    test_ctrl_reg.data_bunch_freq = int(cnst.orbit_size / 4)
    test_ctrl_reg.data_bc_start = cnst.orbit_size - 2 - test_ctrl_reg.bcid_offset
    test_ctrl_reg.trg_pattern_0 = 0xAAFAAFAA
    test_ctrl_reg.trg_pattern_1 = 0xFFAFFAFF
    test_ctrl_reg.trg_cont_val = cnst.TRG_const_Cal
    test_ctrl_reg.trg_bunch_freq = int(cnst.orbit_size / 4)
    test_ctrl_reg.trg_bc_start = cnst.orbit_size - 2 - cnst.orbit_size / 2
    test_ctrl_reg.trg_data_select = cnst.TRG_const_Cal
    run_gen.ctrl_reg = copy.copy(test_ctrl_reg)
    run_gen.generate_ctrl_pattern(run_len)
    run_list.append(copy.copy(run_gen))
    # =======================================================

    # RENERATING RUN ========================================
    run_gen.run_comment = """
        - TRIGGER RUN
        - data in first RDH
        - 4 X 8 packets per orbit
           - no gaps
           - lenght 16
           - lenght 1
        - 48 CLB triggers with data response
           - without gaps
           - gap = 1
           - 0xFFAFFAA...
        """
    test_ctrl_reg.trg_rd_command = readout_cmd.trigger
    test_ctrl_reg.bcid_offset = 0x0
    test_ctrl_reg.data_trg_respond_mask = cnst.TRG_const_Cal
    test_ctrl_reg.data_bunch_pattern = 0xFF011777
    test_ctrl_reg.data_bunch_freq = int(cnst.orbit_size / 4)
    test_ctrl_reg.data_bc_start = cnst.orbit_size - 2 - test_ctrl_reg.bcid_offset
    test_ctrl_reg.trg_pattern_0 = 0xAAFAAFAA
    test_ctrl_reg.trg_pattern_1 = 0xFFAFFAFF
    test_ctrl_reg.trg_cont_val = cnst.TRG_const_Cal
    test_ctrl_reg.trg_bunch_freq = int(cnst.orbit_size / 4)
    test_ctrl_reg.trg_bc_start = cnst.orbit_size - 2 - cnst.orbit_size / 2
    test_ctrl_reg.trg_data_select = cnst.TRG_const_Cal
    run_gen.ctrl_reg = copy.copy(test_ctrl_reg)
    run_gen.generate_ctrl_pattern(run_len)
    run_list.append(copy.copy(run_gen))
    # =======================================================

    # RENERATING RUN ========================================
    run_gen.run_comment = """
        - CONTINIOUS RUN
        - high rate 2MHz, dropping data
           - lenght 7
        - 48 CLB triggers with data response
           - without gaps
           - gap = 1
           - 0xFFAFFAA...
        """
    test_ctrl_reg.trg_rd_command = readout_cmd.continious
    test_ctrl_reg.bcid_offset = 0x0
    test_ctrl_reg.data_trg_respond_mask = cnst.TRG_const_Cal
    test_ctrl_reg.data_bunch_pattern = 0xFF011777
    test_ctrl_reg.data_bunch_freq = 20
    test_ctrl_reg.data_bc_start = cnst.orbit_size - 2 - test_ctrl_reg.bcid_offset
    test_ctrl_reg.trg_pattern_0 = 0xAAFAAFAA
    test_ctrl_reg.trg_pattern_1 = 0xFFAFFAFF
    test_ctrl_reg.trg_cont_val = cnst.TRG_const_Cal
    test_ctrl_reg.trg_bunch_freq = int(cnst.orbit_size / 4)
    test_ctrl_reg.trg_bc_start = cnst.orbit_size - 2 - cnst.orbit_size / 2
    test_ctrl_reg.trg_data_select = cnst.TRG_const_Cal
    run_gen.ctrl_reg = copy.copy(test_ctrl_reg)
    run_gen.generate_ctrl_pattern(run_len)
    run_list.append(copy.copy(run_gen))
    # =======================================================

    # RENERATING RUN ========================================
    run_gen.run_comment = """
        - TRIGGER RUN
        - high rate 2MHz, dropping data
           - lenght 7
        - 48 CLB triggers with data response
           - without gaps
           - gap = 1
           - 0xFFAFFAA...
        """
    test_ctrl_reg.trg_rd_command = readout_cmd.trigger
    test_ctrl_reg.bcid_offset = 0x0
    test_ctrl_reg.data_trg_respond_mask = cnst.TRG_const_Cal
    test_ctrl_reg.data_bunch_pattern = 0xFF011777
    test_ctrl_reg.data_bunch_freq = 20
    test_ctrl_reg.data_bc_start = cnst.orbit_size - 2 - test_ctrl_reg.bcid_offset
    test_ctrl_reg.trg_pattern_0 = 0xAAFAAFAA
    test_ctrl_reg.trg_pattern_1 = 0xFFAFFAFF
    test_ctrl_reg.trg_cont_val = cnst.TRG_const_Cal
    test_ctrl_reg.trg_bunch_freq = int(cnst.orbit_size / 4)
    test_ctrl_reg.trg_bc_start = cnst.orbit_size - 2 - cnst.orbit_size / 2
    test_ctrl_reg.trg_data_select = cnst.TRG_const_Cal
    run_gen.ctrl_reg = copy.copy(test_ctrl_reg)
    run_gen.generate_ctrl_pattern(run_len)
    run_list.append(copy.copy(run_gen))
    # =======================================================

    # RENERATING RUN ========================================
    run_gen.run_comment = """
        - CONTINIOUS RUN
        - max rate, should not drop data
        - data size 6 (max PM)
        
        - 6 * 508 = 3048 detector words
        - 0xdec - 6*514 = 480
        - 3048 + 480-4= 3524
        - 3524/7 = 503 PM packets per orbit
        - 503/8 = 62 banch
        - 0xdec/62 = 57 freq
        
        - 48 CLB triggers; no data response
           - without gaps
           - gap = 1
           - 0xFFAFFAA...
        """
    test_ctrl_reg.trg_rd_command = readout_cmd.trigger
    test_ctrl_reg.bcid_offset = 0x0
    test_ctrl_reg.data_trg_respond_mask = 0
    test_ctrl_reg.data_bunch_pattern = 0x66666666
    test_ctrl_reg.data_bunch_freq = 57
    test_ctrl_reg.data_bc_start = cnst.orbit_size - 2 - test_ctrl_reg.bcid_offset
    test_ctrl_reg.trg_pattern_0 = 0xAAFAAFAA
    test_ctrl_reg.trg_pattern_1 = 0xFFAFFAFF
    test_ctrl_reg.trg_cont_val = cnst.TRG_const_Cal
    test_ctrl_reg.trg_bunch_freq = int(cnst.orbit_size / 20)
    test_ctrl_reg.trg_bc_start = cnst.orbit_size - 2 - cnst.orbit_size / 2
    test_ctrl_reg.trg_data_select = cnst.TRG_const_Cal
    run_gen.ctrl_reg = copy.copy(test_ctrl_reg)
    run_gen.generate_ctrl_pattern(run_len)
    run_list.append(copy.copy(run_gen))
    # =======================================================

    # print generated runs
    for irun in run_list: irun.print_run_meta()

    # saving run metadata
    with open(cnst.filename_runmeta, 'wb') as f:
        pickle.dump(run_list, f)


if __name__ == '__main__':
    generate_sim_inputs()
