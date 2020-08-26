import lib.RDH_data as rdh_data




gbt_out_file = open('simulation_outputs/readout_gbt_output.txt', 'r')

file_lines = list(gbt_out_file)



print( file_lines )
#dynamic_rdh = rdh_data.rdh_header_class()
#dynamic_ddata = rdh_data.detector_event_class()

# newp = dynamic_rdh.read_rdh(file_lines, pos = 0)
# dynamic_rdh.print_raw()
# dynamic_rdh.print_struct()
#
# dynamic_ddata.read_data(file_lines, newp)
# dynamic_ddata.print_raw()
# dynamic_ddata.print_struct()

dyn_event = rdh_data.rdh_data_class()
pos = dyn_event.read_data(file_lines, 0)
dyn_event.print_raw()
dyn_event.print_struct()

print(file_lines[pos])
