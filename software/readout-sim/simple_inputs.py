# this file generate simple text file
# used as inputs source in vhdl simulation
# data used as control register @40 MHz data clock

#Dmitry Finogeev dmitry.fiongeev@cern.ch

import lib.control_reg as cntrl_reg

control_reg = cntrl_reg.control_reg_class()
control_reg.data_gen = cntrl_reg.gen_mode.no_gen
control_reg.data_trg_respond_mask = 0xa
control_reg.data_bunch_pattern = 0xb
control_reg.data_bunch_freq = 0xF0
control_reg.data_freq_offset = 0xc

control_reg.trg_gen = cntrl_reg.gen_mode.no_gen
control_reg.trg_rd_command = cntrl_reg.readout_cmd.idle
control_reg.trg_single_val = 0xe
control_reg.trg_pattern_0 = 0xa
control_reg.trg_pattern_1 = 0xb
control_reg.trg_cont_val = 0xc
control_reg.trg_bunch_freq = 0xd
control_reg.trg_freq_offset = 0xe

control_reg.rd_bypass = 0
control_reg.is_hb_response = 1
control_reg.trg_data_select = 0xa
control_reg.strt_rdmode_lock = 1

control_reg.bcid_delay = 0xF
control_reg.crutrg_delay_comp = 0xf
control_reg.max_data_payload = 0xff

control_reg.reset_orbc_sync = 1
control_reg.reset_drophit_counter = 0
control_reg.reset_gen_offset = 1
control_reg.reset_gbt_rxerror = 0
control_reg.reset_gbt = 1
control_reg.reset_rxph_error = 0

control_reg.RDH_feeid = 0xAAAA
control_reg.RDH_par = 0xCCCC
control_reg.RDH_detf = 0xDDDD

control_reg.print_struct()
control_reg.print_raw()

sigin_file = open('simulation_inputs/simple_sig_inputs.txt', 'w')
sigin_file.write(control_reg.get_reg_line_16() + '\n')

exit(0)




# start empty cycle ===========================
control_reg.trg_gen = cntrl_reg.gen_mode.main_gen


for i in range(0x1000):
    sigin_file.write(control_reg.get_reg_line_16() + '\n')

# continious run ===========================
control_reg.trg_rd_command = cntrl_reg.readout_cmd.continious
control_reg.data_gen = cntrl_reg.gen_mode.main_gen
control_reg.trg_gen = cntrl_reg.gen_mode.main_gen

print("continious run =================== ")

for i in range(0x30000):
    sigin_file.write(control_reg.get_reg_line_16() + '\n')

# end empty cycle ===========================
control_reg.trg_rd_command = cntrl_reg.readout_cmd.idle
for i in range(0xff):
    sigin_file.write(control_reg.get_reg_line_16() + '\n')


sigin_file.close()
