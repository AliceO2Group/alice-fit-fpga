# this file generate simple text file
# used as inputs source in vhdl simulation
# data used as control register @40 MHz data clock

#Dmitry Finogeev dmitry.fiongeev@cern.ch

import lib.control_reg as cntrl_reg

control_reg = cntrl_reg.control_reg_class()


sigin_file = open('simulation_inputs/simple_sig_inputs.txt', 'w')


# generators setup ============================
control_reg.data_gen = cntrl_reg.gen_mode.main_gen
control_reg.data_trg_respond_mask = 0
control_reg.data_bunch_pattern = 0x11111111
control_reg.data_bunch_freq = 0xdec
control_reg.data_freq_offset = 0xdeb-5
control_reg.trg_gen = cntrl_reg.gen_mode.main_gen
control_reg.trg_pattern_0 = 0x0
control_reg.trg_pattern_1 = 0x0
control_reg.trg_cont_val = 0x0
control_reg.trg_bunch_freq = 0x0
control_reg.trg_freq_offset = 0x0
control_reg.trg_rd_command = cntrl_reg.readout_cmd.idle
control_reg.trg_data_select = 0xFFFFFFFF
control_reg.bcid_delay = 0x2

control_reg.print_struct()
control_reg.print_raw()



# start empty cycle ===========================
for i in range(1*0xdec):
    sigin_file.write(control_reg.get_reg_line_16() + '\n')



# gen offset sync =============================
control_reg.reset_gen_offset = 0x1
for i in range(10): sigin_file.write(control_reg.get_reg_line_16() + '\n')
control_reg.reset_gen_offset = 0x0
for i in range(10): sigin_file.write(control_reg.get_reg_line_16() + '\n')
for i in range(2*0xdec):
    sigin_file.write(control_reg.get_reg_line_16() + '\n')



# continious run ===========================
print("continious run =================== ")
control_reg.trg_rd_command = cntrl_reg.readout_cmd.continious
for i in range(5*0xdec):
    sigin_file.write(control_reg.get_reg_line_16() + '\n')



# end empty cycle ===========================
control_reg.trg_rd_command = cntrl_reg.readout_cmd.idle
for i in range(2*0xdec):
    sigin_file.write(control_reg.get_reg_line_16() + '\n')



# start empty cycle ===========================
for i in range(2*0xdec):
    sigin_file.write(control_reg.get_reg_line_16() + '\n')



# trigger run ===========================
print("trigger run =================== ")
control_reg.trg_rd_command = cntrl_reg.readout_cmd.trigger
for i in range(5*0xdec):
    sigin_file.write(control_reg.get_reg_line_16() + '\n')



# end empty cycle ===========================
control_reg.trg_rd_command = cntrl_reg.readout_cmd.idle
for i in range(2*0xdec):
    sigin_file.write(control_reg.get_reg_line_16() + '\n')




sigin_file.close()
