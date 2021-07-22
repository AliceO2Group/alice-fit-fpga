'''

Testbench constants

Dmitry Finogeev dmitry.finogeev@cern.ch
07/2021

'''

# files path constants
# control register as simulation inputs
filename_ctrlreg = 'sim_data/sim_in_ctrlreg.txt'
# generated runs meta info
filename_runmeta = 'sim_data/runmeta.pickle'
# readout simulation ouput
filename_simout = 'sim_data/sim_out_data.txt'

# readout constants
TRG_const_void = 0x00000000
TRG_const_Orbit = 0x00000001  # 0
TRG_const_HB = 0x00000002  # 1
TRG_const_HBr = 0x00000004  # 2
TRG_const_HC = 0x00000008  # 3
TRG_const_Ph = 0x00000010  # 4
TRG_const_PP = 0x00000020  # 5
TRG_const_Cal = 0x00000040  # 6
TRG_const_SOT = 0x00000080  # 7
TRG_const_EOT = 0x00000100  # 8
TRG_const_SOC = 0x00000200  # 9
TRG_const_EOC = 0x00000400  # 10
TRG_const_TF = 0x00000800  # time frame delimiter
TRG_const_FErst = 0x00001000  # FEE reset
TRG_const_RT = 0x00002000  # Run Type; 1=Cont, 0=Trig
TRG_const_RS = 0x00004000  # Running State; 1=Running

orbit_size = 0xdec
