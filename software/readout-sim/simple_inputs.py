# this file generate simple text file
# used as inputs source in vhdl simulation
# data used as control register @40 MHz data clock

#Dmitry Finogeev dmitry.fiongeev@cern.ch

import lib.control_reg as cntrl_reg

control_reg = cntrl_reg.control_reg_class()


sigin_file = open('simulation_inputs/simple_sig_inputs.txt', 'w')



# start empty cycle ===========================
control_reg.trg_gen = cntrl_reg.gen_mode.main_gen


for i in range(2*0xdec):
    sigin_file.write(control_reg.get_reg_line_16() + '\n')

# continious run ===========================
control_reg.trg_rd_command = cntrl_reg.readout_cmd.continious
control_reg.data_gen = cntrl_reg.gen_mode.main_gen
control_reg.trg_gen = cntrl_reg.gen_mode.main_gen

print("continious run =================== ")

for i in range(5*0xdec):
    sigin_file.write(control_reg.get_reg_line_16() + '\n')

# end empty cycle ===========================
control_reg.trg_rd_command = cntrl_reg.readout_cmd.idle
for i in range(2*0xdec):
    sigin_file.write(control_reg.get_reg_line_16() + '\n')


sigin_file.close()
