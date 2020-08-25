import lib.RDH_data as rdh_data




gbt_out_file = open('simulation_outputs/readout_gbt_output.txt', 'r')

file_lines = list(gbt_out_file)



print( file_lines )
dynamic_rdh = rdh_data.rdh_class()

dynamic_rdh.read_rdh(file_lines, pos = 0)
dynamic_rdh.print_raw()
dynamic_rdh.print_struct()
