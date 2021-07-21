# testbench - run file


# simulation_data_class: file info
#  * list of run_sim_data_class (run parameters from inputs file)
#
# run_testbench_class: data reading + tesbench procedure + report per run






from lib.control_reg import control_reg_class as ctrl_rec_c
from lib.control_reg import gen_mode, readout_cmd

test_ctrl_reg = ctrl_rec_c()

test_ctrl_reg.data_gen = gen_mode.main_gen
test_ctrl_reg.data_trg_respond_mask = 0xFAFA
test_ctrl_reg.data_bunch_pattern = 0x00123456
test_ctrl_reg.data_bunch_freq = 0x789
test_ctrl_reg.data_bc_start = 0xabc

test_ctrl_reg.trg_gen = gen_mode.main_gen
test_ctrl_reg.trg_rd_command = readout_cmd.continious
test_ctrl_reg.trg_single_val = 0x1234
test_ctrl_reg.trg_pattern_0 = 0x5678
test_ctrl_reg.trg_pattern_1 = 0x9abc
test_ctrl_reg.trg_cont_val = 0x555
test_ctrl_reg.trg_bunch_freq = 0x666
test_ctrl_reg.trg_bc_start = 0x777

test_ctrl_reg.rd_bypass = 0
test_ctrl_reg.is_hb_response = 1
test_ctrl_reg.trg_data_select = 0x1111
test_ctrl_reg.force_idle = 1

test_ctrl_reg.bcid_offset = 0xFFF

test_ctrl_reg.reset_orbc_sync = 0
test_ctrl_reg.reset_data_counters = 1
test_ctrl_reg.reset_gensync = 0
test_ctrl_reg.reset_gbt_rxerror = 1
test_ctrl_reg.reset_readout = 0
test_ctrl_reg.reset_gbt = 1
test_ctrl_reg.reset_rxph_error = 0

test_ctrl_reg.RDH_FEEID = 0x1111
test_ctrl_reg.RDH_SYS_ID = 0x2222
test_ctrl_reg.RDH_PRT_BIT = 0xAA


test_ctrl_reg.print_struct()

reg_line = test_ctrl_reg.get_reg_line_16()
print(reg_line)

test_ctrl_reg1 = ctrl_rec_c()
test_ctrl_reg1.set_reg_line_16(reg_line)
test_ctrl_reg1.print_struct()



exit(1)



# generates inputs file
infile_gen = in_file_gen.input_generator_class()

infile_gen.control_reg.trg_data_select = 0x2
infile_gen.control_reg.bcid_offset = 0x50
infile_gen.control_reg.data_trg_respond_mask = 0x40
infile_gen.control_reg.trg_cont_val = 0x40

infile_gen.control_reg.data_bunch_pattern = 0x77777771
infile_gen.control_reg.trg_pattern_0 = 0xFFFFFFFF
infile_gen.control_reg.trg_pattern_1 = 0xAAAAAAAA
#infile_gen.control_reg.trg_pattern_0 = 0x0
#infile_gen.control_reg.trg_pattern_1 = 0x0

infile_gen.control_reg.data_bunch_freq = 0x37b
infile_gen.control_reg.trg_bunch_freq = 0xdec

infile_gen.control_reg.data_bc_start = 0xdeb - 3 - infile_gen.control_reg.bcid_offset
infile_gen.control_reg.trg_bc_start = 0xdeb - 16

# reset generators
infile_gen.gen_gsync_signal()

# normal continious
#infile_gen.gen_run(cntrl_reg.readout_cmd.continious)
infile_gen.gen_run_spam(cntrl_reg.readout_cmd.continious)

# normal trigger
infile_gen.gen_run_spam(cntrl_reg.readout_cmd.trigger)

# reset generators
infile_gen.control_reg.data_bunch_freq = 0x100
infile_gen.control_reg.max_data_payload = 0xFF
infile_gen.gen_gsync_signal()

# load continious
infile_gen.gen_run(cntrl_reg.readout_cmd.continious)

# spam continious
infile_gen.gen_run_spam(cntrl_reg.readout_cmd.continious)

# stop idle
infile_gen.gen_empty_cicle()



#=======================================================
# vivado simulation should be run here
#=======================================================





# run testbench
simulation_data = sim_data.simulation_data_class()
for irun in range(0, len(simulation_data.runs_list)):
    run_testbench = run_test.run_testbench_class(simulation_data, irun)

