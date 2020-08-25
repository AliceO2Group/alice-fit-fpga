# this file generate simple text file
# used as inputs source in vhdl simulation
# data used as control register @40 MHz data clock

#Dmitry Finogeev dmitry.fiongeev@cern.ch

import lib.control_reg as cntrl_reg




control_reg = cntrl_reg.control_reg_class()
control_reg.print_struct()



sigin_file = open('simulation_inputs/simple_sig_inputs.txt', 'w')

# start empty cycle ===========================
control_reg.trg_gen = cntrl_reg.gen_mode.main_gen

for i in range(0x1000):
    sigin_file.write(control_reg.get_reg_line_16() + '\n')

# continious run ===========================
control_reg.trg_rd_command = cntrl_reg.readout_cmd.continious
control_reg.data_gen = cntrl_reg.gen_mode.main_gen
control_reg.trg_gen = cntrl_reg.gen_mode.main_gen

print("continious run =================== ")
print(control_reg.get_reg_line_hex())

for i in range(0x30000):
    sigin_file.write(control_reg.get_reg_line_16() + '\n')

# end empty cycle ===========================
control_reg.trg_rd_command = cntrl_reg.readout_cmd.idle
for i in range(0xff):
    sigin_file.write(control_reg.get_reg_line_16() + '\n')


sigin_file.close()
