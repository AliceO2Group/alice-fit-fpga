import lib.RDH_data as rdh_data
import lib.control_reg as cntrl_reg



gbt_out_file = open('simulation_outputs/readout_gbt_output.txt', 'r')
reg_in_file = open('simulation_inputs/simple_sig_inputs.txt', 'r')

file_lines = list(gbt_out_file)
ctrl_reg_lines = list(reg_in_file)


dynamic_cntrl_reg = cntrl_reg.control_reg_class()
dynamic_cntrl_reg.read_reg_line_16(ctrl_reg_lines[0])
dynamic_cntrl_reg.print_struct()

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
