# this file generate simple text file
# used as inputs source in vhdl simulation
# data used as control register @40 MHz data clock

#Dmitry Finogeev dmitry.fiongeev@cern.ch

import lib.control_reg as cntrl_reg




control_reg = cntrl_reg.control_reg_class()
control_reg.print_struct()



sigin_file = open('simulation_inputs/simple_sig_inputs.txt', 'w')

# start empty cycle ===========================
for i in range(50):
    sigin_file.write(control_reg.get_reg_line() + '\n')


sigin_file.close()
