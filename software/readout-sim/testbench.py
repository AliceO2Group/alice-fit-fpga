# testbench - run file


# simulation_data_class: file info
#  * list of run_sim_data_class (run parameters from inputs file)
#
# run_testbench_class: data reading + tesbench procedure + report per run






import lib.simulation_data as sim_data
import lib.run_testbench as run_test
import lib.RDH_data as rdh_data
import lib.control_reg as cntrl_reg
import lib.status_reg as status_reg


simulation_data = sim_data.simulation_data_class()
run_testbench = run_test.run_testbench_class(simulation_data, 0)
run_testbench = run_test.run_testbench_class(simulation_data, 1)

# run_testbench.rdh_data_list[1].print_struct()
# run_testbench.rdh_data_list[1].print_struct()

# gbt_out_file = open('simulation_outputs/readout_gbt_output.txt', 'r')
# status_reg_out_file = open('simulation_outputs/readout_status_reg_output.txt', 'r')
# ctrl_reg_in_file = open('simulation_inputs/simple_sig_inputs.txt', 'r')
#
# flines_status = list(status_reg_out_file)
#
# dynamic_status_reg = status_reg.status_reg_class()
# dynamic_status_reg.read_reg_line_hex(flines_status[30200])
# dynamic_status_reg.print_struct()



# file_lines = list(gbt_out_file)
# ctrl_reg_lines = list(ctrl_reg_in_file)


# dynamic_cntrl_reg = cntrl_reg.control_reg_class()
# dynamic_cntrl_reg.read_reg_line_16(ctrl_reg_lines[0])
# dynamic_cntrl_reg.print_struct()

# print( file_lines )
#dynamic_rdh = rdh_data.rdh_header_class()
#dynamic_ddata = rdh_data.detector_event_class()

# newp = dynamic_rdh.read_rdh(file_lines, pos = 0)
# dynamic_rdh.print_raw()
# dynamic_rdh.print_struct()
#
# dynamic_ddata.read_data(file_lines, newp)
# dynamic_ddata.print_raw()
# dynamic_ddata.print_struct()

# dyn_event = rdh_data.rdh_data_class()
# pos = dyn_event.read_data(file_lines, 0)
# dyn_event.print_raw()
# dyn_event.print_struct()
#
# print(file_lines[pos])
