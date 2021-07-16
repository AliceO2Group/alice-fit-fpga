# testbench - run file


# simulation_data_class: file info
#  * list of run_sim_data_class (run parameters from inputs file)
#
# run_testbench_class: data reading + tesbench procedure + report per run






import lib.simulation_data as sim_data
import lib.run_testbench as run_test
import lib.inputs_gen as in_file_gen
import lib.RDH_data as rdh_data
import lib.control_reg as cntrl_reg
import lib.status_reg as status_reg




# generates inputs file
infile_gen = in_file_gen.input_generator_class()

infile_gen.control_reg.trg_data_select = 0x2
infile_gen.control_reg.bcid_delay = 0x0
infile_gen.control_reg.data_trg_respond_mask = 0x40
infile_gen.control_reg.trg_cont_val = 0x40

infile_gen.control_reg.data_bunch_pattern = 0x77777771
infile_gen.control_reg.trg_pattern_0 = 0xFFFFFFFF
infile_gen.control_reg.trg_pattern_1 = 0xAAAAAAAA

infile_gen.control_reg.data_bunch_freq = 0x37b
infile_gen.control_reg.trg_bunch_freq = 0xdec

infile_gen.control_reg.data_freq_offset = 0xdeb-3 - infile_gen.control_reg.bcid_delay
infile_gen.control_reg.trg_freq_offset = 0xdeb-16

# reset generators
infile_gen.gen_gsync_signal()

# normal continious
#infile_gen.gen_run(cntrl_reg.readout_cmd.continious)
infile_gen.gen_run_spam(cntrl_reg.readout_cmd.trigger)

# normal trigger
infile_gen.gen_run(cntrl_reg.readout_cmd.trigger)

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

