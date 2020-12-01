#*****************************************************************************************
# Vivado (TM) v2018.1 (64-bit)
#
# make.tcl: Tcl script for re-creating and building the bitstream for the project 'FIT_TESTMODULE_v1'
#
# IP Build 2185939 on Wed Apr  4 20:55:05 MDT 2018
#
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/GBT_project/gbt_bank/xilinx_k7v7/gbt_tx/tx_dpram/xlx_k7v7_tx_dpram.xci"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/GBT_project/IP/xlx_k7v7_gbt_rx_frameclk_phalgnr_mmcm/xlx_k7v7_gbt_rx_frameclk_phalgnr_mmcm.xci"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/sources_1/ip/fifo_generator_0/fifo_generator_0.xci"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/sources_1/ip/raw_data_fifo/raw_data_fifo.xci"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/sources_1/ip/COUNTER_FIFO/COUNTER_FIFO.xci"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/sources_1/ip/gig_ethernet_pcs_pma_0/gig_ethernet_pcs_pma_0.xci"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/sources_1/ip/tri_mode_ethernet_mac_0/tri_mode_ethernet_mac_0.xci"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/sources_1/ip/MMCM320_PH_1/MMCM320_PH.xci"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/sources_1/ip/CDM_Clk_pll/CDM_Clk_pll.xci"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/sources_1/ip/PmClockPll/PmClockPll.xci"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/sources_1/ip/spi_mem/spi_mem.xci"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/sources_1/ip/TCM_PLL320/TCM_PLL320.xci"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/FIT_IPBUS/ipbus_slaves/spi_clgen.v"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/FIT_IPBUS/ipbus_slaves/spi_shift.v"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/FIT_IPBUS/ipbus_slaves/spi_top.v"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/fit_gbt_common_package.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/BC_counter.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/fit_gbt_boardPM_package.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/CRU_ORBC_Gen.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/DataCLK_strobe.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/DataConverter_PM.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/FIT_TESTMODULE_IPBUS_sender.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/Module_Data_Gen_PM.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/GBT_DATA_sender.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/TX_Data_Gen.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/FIT_TESTMODULE_core.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/FIT_IPBUS/ipbus_core/ipbus_package.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/FIT_IPBUS/ipbus_clock_div.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/FIT_IPBUS/clocks_7s_serdes.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/FIT_IPBUS/led_stretcher.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/FIT_IPBUS/emac_hostbus_decl.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/FIT_IPBUS/eth_7s_1000basex.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/FIT_IPBUS/ipbus_core/ipbus_trans_decl.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/FIT_IPBUS/ipbus_core/udp_build_arp.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/FIT_IPBUS/ipbus_core/udp_build_ping.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/FIT_IPBUS/ipbus_core/udp_ipaddr_block.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/FIT_IPBUS/ipbus_core/udp_build_payload.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/FIT_IPBUS/ipbus_core/udp_build_resend.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/FIT_IPBUS/ipbus_core/udp_build_status.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/FIT_IPBUS/ipbus_core/udp_status_buffer.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/FIT_IPBUS/ipbus_core/udp_byte_sum.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/FIT_IPBUS/ipbus_core/udp_do_rx_reset.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/FIT_IPBUS/ipbus_core/udp_packet_parser.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/FIT_IPBUS/ipbus_core/udp_rxram_mux.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/FIT_IPBUS/ipbus_core/udp_dualportram.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/FIT_IPBUS/ipbus_core/udp_buffer_selector.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/FIT_IPBUS/ipbus_core/udp_rxram_shim.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/FIT_IPBUS/ipbus_core/udp_dualportram_rx.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/FIT_IPBUS/ipbus_core/udp_rxtransactor_if_simple.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/FIT_IPBUS/ipbus_core/udp_dualportram_tx.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/FIT_IPBUS/ipbus_core/udp_tx_mux.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/FIT_IPBUS/ipbus_core/udp_txtransactor_if_simple.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/FIT_IPBUS/ipbus_core/udp_clock_crossing_if.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/FIT_IPBUS/ipbus_core/udp_if_flat.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/FIT_IPBUS/ipbus_core/transactor_if.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/FIT_IPBUS/ipbus_core/transactor_sm.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/FIT_IPBUS/ipbus_core/transactor_cfg.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/FIT_IPBUS/ipbus_core/transactor.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/FIT_IPBUS/ipbus_core/ipbus_ctrl.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/FIT_IPBUS/kc705_basex_infra.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/FIT_IPBUS/ipbus_slaves/ipbus_spi.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/PLL_Reset_Generator.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/Reset_Generator.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/GBT_project/gbt_bank/xilinx_k7v7/xlx_k7v7_gbt_bank_package.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/GBT_project/gbt_bank/xilinx_k7v7/xlx_k7v7_gbt_banks_user_setup.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/GBT_project/gbt_bank/core_sources/gbt_bank_package.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/GBT_project/core_sources/phaligner_mmcm_controller.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/GBT_project/core_sources/rxframeclk_phalgnr/phaligner_phase_computing.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/GBT_project/core_sources/rxframeclk_phalgnr/phaligner_phase_comparator.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/GBT_project/core_sources/xlx_k7v7_phalgnr_std_mmcm.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/GBT_project/core_sources/rxframeclk_phalgnr/gbt_rx_frameclk_phalgnr.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/GBT_project/core_sources/gbt_bank_reset.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/GBT_project/gbt_bank/core_sources/gbt_tx/gbt_tx_scrambler_21bit.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/GBT_project/gbt_bank/core_sources/gbt_tx/gbt_tx_scrambler.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/GBT_project/gbt_bank/core_sources/gbt_tx/gbt_tx_encoder_gbtframe_polydiv.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/GBT_project/gbt_bank/core_sources/gbt_tx/gbt_tx_encoder_gbtframe_rsencode.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/GBT_project/gbt_bank/core_sources/gbt_tx/gbt_tx_encoder_gbtframe_intlver.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/GBT_project/gbt_bank/core_sources/gbt_tx/gbt_tx_encoder.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/GBT_project/gbt_bank/core_sources/gbt_tx/gbt_tx_gearbox_std_rdwrctrl.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/GBT_project/gbt_bank/xilinx_k7v7/gbt_tx/xlx_k7v7_gbt_tx_gearbox_std_dpram.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/GBT_project/gbt_bank/core_sources/gbt_tx/gbt_tx_gearbox_std.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/GBT_project/gbt_bank/core_sources/gbt_tx/gbt_tx_gearbox.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/GBT_project/gbt_bank/core_sources/gbt_tx/gbt_tx_gearbox_phasemon.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/GBT_project/gbt_bank/core_sources/gbt_tx/gbt_tx.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/GBT_project/gbt_bank/xilinx_k7v7/mgt/mgt_ip_vhd/xlx_k7v7_mgt_ip.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/GBT_project/gbt_bank/core_sources/mgt/mgt_latopt_bitslipctrl.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/GBT_project/gbt_bank/xilinx_k7v7/mgt/xlx_k7v7_mgt_latopt.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/GBT_project/gbt_bank/core_sources/mgt/multi_gigabit_transceivers.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/GBT_project/gbt_bank/core_sources/gbt_rx/gbt_rx_framealigner_wraddr.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/GBT_project/gbt_bank/core_sources/gbt_rx/gbt_rx_framealigner_pattsearch.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/GBT_project/gbt_bank/core_sources/gbt_rx/gbt_rx_framealigner_bscounter.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/GBT_project/gbt_bank/core_sources/gbt_rx/gbt_rx_framealigner_rightshift.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/GBT_project/gbt_bank/core_sources/gbt_rx/gbt_rx_framealigner.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/GBT_project/gbt_bank/core_sources/gbt_rx/gbt_rx_gearbox_latopt.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/GBT_project/gbt_bank/core_sources/gbt_rx/gbt_rx_gearbox.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/GBT_project/gbt_bank/core_sources/gbt_rx/gbt_rx_decoder_gbtframe_deintlver.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/GBT_project/gbt_bank/core_sources/gbt_rx/gbt_rx_decoder_gbtframe_syndrom.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/GBT_project/gbt_bank/core_sources/gbt_rx/gbt_rx_decoder_gbtframe_lmbddet.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/GBT_project/gbt_bank/core_sources/gbt_rx/gbt_rx_decoder_gbtframe_errlcpoly.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/GBT_project/gbt_bank/core_sources/gbt_rx/gbt_rx_decoder_gbtframe_elpeval.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/GBT_project/gbt_bank/core_sources/gbt_rx/gbt_rx_decoder_gbtframe_chnsrch.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/GBT_project/gbt_bank/core_sources/gbt_rx/gbt_rx_decoder_gbtframe_rs2errcor.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/GBT_project/gbt_bank/core_sources/gbt_rx/gbt_rx_decoder_gbtframe_rsdec.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/GBT_project/gbt_bank/core_sources/gbt_rx/gbt_rx_decoder.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/GBT_project/gbt_bank/core_sources/gbt_rx/gbt_rx_descrambler_21bit.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/GBT_project/gbt_bank/core_sources/gbt_rx/gbt_rx_descrambler.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/GBT_project/gbt_bank/core_sources/gbt_rx/gbt_rx_status.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/GBT_project/gbt_bank/core_sources/gbt_rx/gbt_rx.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/GBT_project/gbt_bank/core_sources/gbt_bank.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/GBT_project/GBT_TXRX5.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/sources_1/new/TCM_SPI.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/pm-spi.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/sources_1/new/tcm_sc.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/tcm_sync.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/GBT_project/gbt_bank/xilinx_k7v7/mgt/mgt_ip_vhd/xlx_k7v7_mgt_ip_auto_phase_align.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/GBT_project/gbt_bank/xilinx_k7v7/mgt/mgt_ip_vhd/xlx_k7v7_mgt_ip_cpll_railing.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/GBT_project/gbt_bank/xilinx_k7v7/mgt/mgt_ip_vhd/xlx_k7v7_mgt_ip_gt.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/GBT_project/gbt_bank/xilinx_k7v7/mgt/mgt_ip_vhd/xlx_k7v7_mgt_ip_init.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/GBT_project/gbt_bank/xilinx_k7v7/mgt/mgt_ip_vhd/xlx_k7v7_mgt_ip_multi_gt.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/GBT_project/gbt_bank/xilinx_k7v7/mgt/mgt_ip_vhd/xlx_k7v7_mgt_ip_rx_startup_fsm.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/GBT_project/gbt_bank/xilinx_k7v7/mgt/mgt_ip_vhd/xlx_k7v7_mgt_ip_sync_block.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/GBT_project/gbt_bank/xilinx_k7v7/mgt/mgt_ip_vhd/xlx_k7v7_mgt_ip_sync_pulse.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/GBT_project/gbt_bank/xilinx_k7v7/mgt/mgt_ip_vhd/xlx_k7v7_mgt_ip_tx_manual_phase_align.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/GBT_project/gbt_bank/xilinx_k7v7/mgt/mgt_ip_vhd/xlx_k7v7_mgt_ip_tx_startup_fsm.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/FIT_TESTMODULE_v2.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/FIT_IPBUS/ipbus_core/dss_package.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/FIT_IPBUS/ipbus_slaves/ipbus_reg_types.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/sim_1/testbench_FITTESTMODULE.vhd"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/constrs_1/FIT_GBT_kc705_io.xdc"
#    "/home/cmayer/20200311/FIT_TESTMODULE_v20_lsfix_2020-03-04/FIT_TESTMODULE_v1.srcs/constrs_1/FIT_GBT_project_cnstrs.xdc"
#
# 3. The following remote source files that were added to the original project:-
#
#    <none>
#
#*****************************************************************************************
set part "xc7k325tffg900-2"

source ../../tcl/fit.tcl

# Set the reference directory for source file relative paths (by default the value is script directory path)
set origin_dir "."

# Use origin directory path location variable, if specified in the tcl shell
if { [info exists ::origin_dir_loc] } {
  set origin_dir $::origin_dir_loc
}

# Set the project name
set project_name "FIT_TESTMODULE_TCM"

# Use project name variable, if specified in the tcl shell
if { [info exists ::user_project_name] } {
  set project_name $::user_project_name
}

variable script_file
set script_file "make.tcl"

# Help information for this script
proc help {} {
  variable script_file
  puts "\nDescription:"
  puts "Recreate a Vivado project from this script. The created project will be"
  puts "functionally equivalent to the original project for which this script was"
  puts "generated. The script contains commands for creating a project, filesets,"
  puts "runs, adding/importing sources and setting properties on various objects.\n"
  puts "Syntax:"
  puts "$script_file"
  puts "$script_file -tclargs \[--origin_dir <path>\]"
  puts "$script_file -tclargs \[--project_name <name>\]"
  puts "$script_file -tclargs \[--help\]\n"
  puts "Usage:"
  puts "Name                   Description"
  puts "-------------------------------------------------------------------------"
  puts "\[--origin_dir <path>\]  Determine source file paths wrt this path. Default"
  puts "                       origin_dir path value is \".\", otherwise, the value"
  puts "                       that was set with the \"-paths_relative_to\" switch"
  puts "                       when this script was generated.\n"
  puts "\[--project_name <name>\] Create project with the specified name. Default"
  puts "                       name is the name of the project from where this"
  puts "                       script was generated.\n"
  puts "\[--help\]               Print help information for this script"
  puts "-------------------------------------------------------------------------\n"
  exit 0
}

if { $::argc > 0 } {
  for {set i 0} {$i < $::argc} {incr i} {
    set option [string trim [lindex $::argv $i]]
    switch -regexp -- $option {
      "--origin_dir"   { incr i; set origin_dir [lindex $::argv $i] }
      "--project_name" { incr i; set project_name [lindex $::argv $i] }
      "--help"         { help }
      default {
        if { [regexp {^-} $option] } {
          puts "ERROR: Unknown option '$option' specified, please type '$script_file -tclargs --help' for usage info.\n"
          return 1
        }
      }
    }
  }
}

# Set the directory path for the original project from where this script was exported
set orig_proj_dir "[file normalize "$origin_dir/build"]"

if {[string equal [open_project -quiet "build/FIT_TESTMODULE_v1.xpr"] ""]} {
    set proj_create "yes"
    puts ${proj_create}
    puts ${project_name}
    create_project ${project_name} ./build -part $part
} else {
    set proj_create "no"
    puts ${proj_create}
}

puts "ok"
puts current_project
# Set the directory path for the new project
set proj_dir [get_property directory [current_project]]

# Reconstruct message rules
# None

# Set project properties
set obj [current_project]
set_property \
    -dict [list \
	       "board_part"            "xilinx.com:kc705:part0:1.5" \
	       "corecontainer.enable"  "1" \
	       "default_lib"           "xil_defaultlib" \
	       "ip_cache_permissions"  "read write" \
	       "ip_output_repo"        "$proj_dir/${project_name}.cache/ip" \
	       "sim.ip.auto_export_scripts"  "1" \
	       "simulator_language"    "Mixed" \
	       "target_language"       "VHDL" \
	       "xpm_libraries"         "XPM_CDC XPM_MEMORY" ] \
    [current_project]

# Create 'sources_1' fileset (if not found)
if {[string equal [get_filesets -quiet sources_1] ""]} {
  create_fileset -srcset sources_1
}


# Import local files from the original project
set files [list \
 [file normalize "${origin_dir}/../../common/ftm/hdl/FIT_TESTMODULE_IPBUS_sender.vhd" ]\
 [file normalize "${origin_dir}/../../common/ftm/hdl/PLL_Reset_Generator.vhd" ]\
 [file normalize "${origin_dir}/../../common/ftm/hdl/TCM_SPI.vhd" ]\
 [file normalize "${origin_dir}/../../common/ftm/hdl/tcm_sc.vhd" ]\
 [file normalize "${origin_dir}/../../common/ftm/hdl/pm-spi.vhd" ]\
 [file normalize "${origin_dir}/../../common/ftm/hdl/tcm_sync.vhd" ]\
 [file normalize "${origin_dir}/../../common/ftm/hdl/FIT_TESTMODULE_v2.vhd" ]\
 [file normalize "${origin_dir}/../../common/ipbus/hdl/ipbus_clock_div.vhd" ]\
 [file normalize "${origin_dir}/../../common/ipbus/hdl/led_stretcher.vhd" ]\
 [file normalize "${origin_dir}/../../common/ipbus/hdl/emac_hostbus_decl.vhd" ]\
 [file normalize "${origin_dir}/../../common/ipbus/hdl/IPBUS_basex.vhd" ]\
 [file normalize "${origin_dir}/../../common/ipbus/hdl/clocks_7s_serdes.vhd" ]\
 [file normalize "${origin_dir}/../../common/ipbus/hdl/eth_7s_1000basex.vhd" ]\
 [file normalize "${origin_dir}/../../common/ipbus/hdl/ipbus_core/ipbus_trans_decl.vhd" ]\
 [file normalize "${origin_dir}/../../common/ipbus/hdl/ipbus_core/udp_build_arp.vhd" ]\
 [file normalize "${origin_dir}/../../common/ipbus/hdl/ipbus_core/udp_build_ping.vhd" ]\
 [file normalize "${origin_dir}/../../common/ipbus/hdl/ipbus_core/udp_ipaddr_block.vhd" ]\
 [file normalize "${origin_dir}/../../common/ipbus/hdl/ipbus_core/udp_build_payload.vhd" ]\
 [file normalize "${origin_dir}/../../common/ipbus/hdl/ipbus_core/udp_build_resend.vhd" ]\
 [file normalize "${origin_dir}/../../common/ipbus/hdl/ipbus_core/udp_build_status.vhd" ]\
 [file normalize "${origin_dir}/../../common/ipbus/hdl/ipbus_core/udp_status_buffer.vhd" ]\
 [file normalize "${origin_dir}/../../common/ipbus/hdl/ipbus_core/udp_byte_sum.vhd" ]\
 [file normalize "${origin_dir}/../../common/ipbus/hdl/ipbus_core/udp_do_rx_reset.vhd" ]\
 [file normalize "${origin_dir}/../../common/ipbus/hdl/ipbus_core/udp_packet_parser.vhd" ]\
 [file normalize "${origin_dir}/../../common/ipbus/hdl/ipbus_core/udp_rxram_mux.vhd" ]\
 [file normalize "${origin_dir}/../../common/ipbus/hdl/ipbus_core/udp_dualportram.vhd" ]\
 [file normalize "${origin_dir}/../../common/ipbus/hdl/ipbus_core/udp_buffer_selector.vhd" ]\
 [file normalize "${origin_dir}/../../common/ipbus/hdl/ipbus_core/udp_rxram_shim.vhd" ]\
 [file normalize "${origin_dir}/../../common/ipbus/hdl/ipbus_core/udp_dualportram_rx.vhd" ]\
 [file normalize "${origin_dir}/../../common/ipbus/hdl/ipbus_core/udp_rxtransactor_if_simple.vhd" ]\
 [file normalize "${origin_dir}/../../common/ipbus/hdl/ipbus_core/udp_dualportram_tx.vhd" ]\
 [file normalize "${origin_dir}/../../common/ipbus/hdl/ipbus_core/udp_tx_mux.vhd" ]\
 [file normalize "${origin_dir}/../../common/ipbus/hdl/ipbus_core/udp_txtransactor_if_simple.vhd" ]\
 [file normalize "${origin_dir}/../../common/ipbus/hdl/ipbus_core/udp_clock_crossing_if.vhd" ]\
 [file normalize "${origin_dir}/../../common/ipbus/hdl/ipbus_core/udp_if_flat.vhd" ]\
 [file normalize "${origin_dir}/../../common/ipbus/hdl/ipbus_core/transactor_if.vhd" ]\
 [file normalize "${origin_dir}/../../common/ipbus/hdl/ipbus_core/transactor_sm.vhd" ]\
 [file normalize "${origin_dir}/../../common/ipbus/hdl/ipbus_core/transactor_cfg.vhd" ]\
 [file normalize "${origin_dir}/../../common/ipbus/hdl/ipbus_core/transactor.vhd" ]\
 [file normalize "${origin_dir}/../../common/ipbus/hdl/ipbus_core/ipbus_ctrl.vhd" ]\
 [file normalize "${origin_dir}/../../common/ipbus/hdl/ipbus_core/ipbus_package.vhd" ]\
 [file normalize "${origin_dir}/../../common/ipbus/hdl/ipbus_core/dss_package.vhd" ]\
 [file normalize "${origin_dir}/../../common/ipbus/hdl/ipbus_slaves/ipbus_reg_types.vhd" ]\
 [file normalize "${origin_dir}/../../common/ipbus/hdl/ipbus_slaves/spi_defines.v" ]\
 [file normalize "${origin_dir}/../../common/ipbus/hdl/ipbus_slaves/timescale.v" ]\
 [file normalize "${origin_dir}/../../common/ipbus/hdl/ipbus_slaves/spi_clgen.v" ]\
 [file normalize "${origin_dir}/../../common/ipbus/hdl/ipbus_slaves/spi_shift.v" ]\
 [file normalize "${origin_dir}/../../common/ipbus/hdl/ipbus_slaves/spi_top.v" ]\
 [file normalize "${origin_dir}/../../common/ipbus/hdl/ipbus_slaves/ipbus_spi.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-readout/hdl/GBT_TXRX5.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/core_sources/phaligner_mmcm_controller.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/core_sources/xlx_k7v7_phalgnr_std_mmcm.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/core_sources/rxframeclk_phalgnr/phaligner_phase_computing.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/core_sources/rxframeclk_phalgnr/phaligner_phase_comparator.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/core_sources/gbt_bank_reset.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/core_sources/rxframeclk_phalgnr/gbt_rx_frameclk_phalgnr.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/core_sources/gbt_bank_package.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/core_sources/gbt_tx/gbt_tx_scrambler_21bit.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/core_sources/gbt_tx/gbt_tx_scrambler.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/core_sources/gbt_tx/gbt_tx_encoder_gbtframe_polydiv.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/core_sources/gbt_tx/gbt_tx_encoder_gbtframe_rsencode.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/core_sources/gbt_tx/gbt_tx_encoder_gbtframe_intlver.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/core_sources/gbt_tx/gbt_tx_encoder.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/core_sources/gbt_tx/gbt_tx_gearbox_std_rdwrctrl.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/core_sources/gbt_tx/gbt_tx_gearbox_std.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/core_sources/gbt_tx/gbt_tx_gearbox.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/core_sources/gbt_tx/gbt_tx_gearbox_phasemon.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/core_sources/gbt_tx/gbt_tx.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/core_sources/mgt/mgt_latopt_bitslipctrl.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/core_sources/mgt/multi_gigabit_transceivers.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/core_sources/gbt_rx/gbt_rx_framealigner_wraddr.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/core_sources/gbt_rx/gbt_rx_framealigner_pattsearch.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/core_sources/gbt_rx/gbt_rx_framealigner_bscounter.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/core_sources/gbt_rx/gbt_rx_framealigner_rightshift.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/core_sources/gbt_rx/gbt_rx_framealigner.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/core_sources/gbt_rx/gbt_rx_gearbox_latopt.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/core_sources/gbt_rx/gbt_rx_gearbox.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/core_sources/gbt_rx/gbt_rx_decoder_gbtframe_deintlver.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/core_sources/gbt_rx/gbt_rx_decoder_gbtframe_syndrom.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/core_sources/gbt_rx/gbt_rx_decoder_gbtframe_lmbddet.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/core_sources/gbt_rx/gbt_rx_decoder_gbtframe_errlcpoly.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/core_sources/gbt_rx/gbt_rx_decoder_gbtframe_elpeval.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/core_sources/gbt_rx/gbt_rx_decoder_gbtframe_chnsrch.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/core_sources/gbt_rx/gbt_rx_decoder_gbtframe_rs2errcor.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/core_sources/gbt_rx/gbt_rx_decoder_gbtframe_rsdec.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/core_sources/gbt_rx/gbt_rx_decoder.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/core_sources/gbt_rx/gbt_rx_descrambler_21bit.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/core_sources/gbt_rx/gbt_rx_descrambler.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/core_sources/gbt_rx/gbt_rx_status.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/core_sources/gbt_rx/gbt_rx.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/core_sources/gbt_bank.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/xilinx_k7v7/xlx_k7v7_gbt_bank_package.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/xilinx_k7v7/xlx_k7v7_gbt_banks_user_setup.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/xilinx_k7v7/gbt_tx/xlx_k7v7_gbt_tx_gearbox_std_dpram.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/xilinx_k7v7/mgt/xlx_k7v7_mgt_latopt.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/xilinx_k7v7/mgt/mgt_ip_vhd/xlx_k7v7_mgt_ip.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/xilinx_k7v7/mgt/mgt_ip_vhd/xlx_k7v7_mgt_ip_init.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/xilinx_k7v7/mgt/mgt_ip_vhd/xlx_k7v7_mgt_ip_auto_phase_align.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/xilinx_k7v7/mgt/mgt_ip_vhd/xlx_k7v7_mgt_ip_cpll_railing.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/xilinx_k7v7/mgt/mgt_ip_vhd/xlx_k7v7_mgt_ip_gt.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/xilinx_k7v7/mgt/mgt_ip_vhd/xlx_k7v7_mgt_ip_multi_gt.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/xilinx_k7v7/mgt/mgt_ip_vhd/xlx_k7v7_mgt_ip_rx_startup_fsm.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/xilinx_k7v7/mgt/mgt_ip_vhd/xlx_k7v7_mgt_ip_sync_block.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/xilinx_k7v7/mgt/mgt_ip_vhd/xlx_k7v7_mgt_ip_sync_pulse.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/xilinx_k7v7/mgt/mgt_ip_vhd/xlx_k7v7_mgt_ip_tx_manual_phase_align.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-fpga/hdl/gbt_bank/xilinx_k7v7/mgt/mgt_ip_vhd/xlx_k7v7_mgt_ip_tx_startup_fsm.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-readout/hdl/GBT_TXRX5.vhd"] \
 [file normalize "${origin_dir}/../../common/gbt-readout/hdl/DataCLK_strobe.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-readout/hdl/DataConverter_TCM.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-readout/hdl/RX_Data_Decoder.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-readout/hdl/BC_counter.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-readout/hdl/Reset_Generator.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-readout/hdl/fit_gbt_boardTCM_package.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-readout/hdl/FIT_GBT_project.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-readout/hdl/Module_Data_Gen_TCM.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-readout/hdl/CRU_ORBC_Gen.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-readout/hdl/TX_Data_Gen.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-readout/hdl/Event_selector.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-readout/hdl/fit_gbt_common_package.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-readout/hdl/RXDataClkSync.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-readout/hdl/CRU_packet_Builder.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-readout/hdl/Data_Packager.vhd" ]\
]

#set imported_files [import_files -fileset sources_1 $files]
add_files -norecurse -fileset sources_1 $files
#set imported_files [add_files -norecurse  -fileset sources_1 $files]
#-------------------------------------------------------------------------------
if {[string equal $proj_create "yes"]} {
    # Set 'sources_1' fileset object
    set obj [get_filesets sources_1]
    add_files -norecurse -fileset $obj $files

    set_property -name "file_type" -value "VHDL" -objects [get_files [list "*.vhd"]]
    set_property -name "file_type" -value "Verilog" -objects [get_files [list "*.v"]]

    # reconstruct all IP cores from the text data in ipcore_properties/
    fit::make_ipcores "${proj_dir}/generated"

    # the following is needed in order to have parallel IP synthesis and implementation runs
    set_property GENERATE_SYNTH_CHECKPOINT TRUE [get_files "*.xci"]

    # Set 'sources_1' fileset properties
    set_property \
	-dict [list \
		   "top" "tcm"] \
	[get_filesets sources_1]

    # Create 'constrs_1' fileset (if not found)
    if {[string equal [get_filesets -quiet constrs_1] ""]} {
	create_fileset -constrset constrs_1
    }

    # Add/Import constrs file and set constrs file properties
    set file "[file normalize "$origin_dir/xdc/FIT_GBT_kc705_io.xdc"]"
    add_files -fileset constrs_1 [list $file]

    set file "[file normalize "$origin_dir/xdc/FIT_GBT_project_cnstrs.xdc"]"
    add_files -fileset constrs_1 [list $file]

    set_property -name "file_type" -value "XDC" -objects [get_files -of_objects [get_filesets constrs_1] [list "*/xdc/*.xdc"]]

    # Set 'constrs_1' fileset properties
    set_property -name "target_constrs_file" -value "[get_files *xdc/FIT_GBT_kc705_io.xdc]" -objects [get_filesets constrs_1]
}
#-------------------------------------------------------------------------------

# upgrade_ip [get_ips]
generate_target synthesis [get_ips] -force

foreach ip [get_ips] {
    puts $ip
    create_ip_run [get_files ${ip}.xci]
	set_property generate_synth_checkpoint false [get_files ${ip}.xci]
    generate_target all [get_files ${ip}.xci]
}










# Create 'sim_1' fileset (if not found)
if {[string equal [get_filesets -quiet sim_1] ""]} {
  create_fileset -simset sim_1
}


# Set 'sim_1' fileset object
set obj [get_filesets sim_1]
# Import local files from the original project
set files [list \
 [file normalize "${origin_dir}/../../common/gbt-readout/sim/readout_simulation.vhd" ]\
 [file normalize "${origin_dir}/../../common/gbt-readout/sim/main_signals.wcfg" ]\
]
#set imported_files [import_files -fileset sim_1 $files]
add_files -norecurse -fileset sim_1 $files

# Set 'sim_1' fileset properties
set obj [get_filesets sim_1]
set_property -name "top" -value "testbench_readout" -objects $obj












# Create 'synth_1' run (if not found)
if {[string equal [get_runs -quiet synth_1] ""]} {
    create_run -name synth_1 -part xc7k325tffg900-2 -flow {Vivado Synthesis 2019} -strategy "Flow_PerfOptimized_high" -report_strategy {No Reports} -constrset constrs_1
} else {
  set_property strategy "Flow_PerfOptimized_high" [get_runs synth_1]
  set_property flow "Vivado Synthesis 2018" [get_runs synth_1]
}
set obj [get_runs synth_1]
set_property set_report_strategy_name 1 $obj
set_property report_strategy {Vivado Synthesis Default Reports} $obj
set_property set_report_strategy_name 0 $obj

proc gen_report {name type steps runs} {
    if { [ string equal [get_report_configs -of_objects [get_runs ${runs}] ${name}] "" ] } {
	create_report_config -report_name ${name} -report_type ${type} -steps ${steps} -runs ${runs}
    }
    set obj [get_report_configs -of_objects [get_runs ${runs}] ${name}]
    if { $obj != "" } {
	set_property -name "is_enabled" -value "0" -objects $obj
    }
}
gen_report synth_1_synth_report_utilization_0 report_utilization:1.0 synth_design synth_1

set obj [get_runs synth_1]
set_property -name "needs_refresh" -value "1" -objects $obj
set_property -name "strategy" -value "Flow_PerfOptimized_high" -objects $obj
set_property -name "steps.synth_design.args.fanout_limit" -value "400" -objects $obj
set_property -name "steps.synth_design.args.fsm_extraction" -value "one_hot" -objects $obj
set_property -name "steps.synth_design.args.keep_equivalent_registers" -value "1" -objects $obj
set_property -name "steps.synth_design.args.resource_sharing" -value "off" -objects $obj
set_property -name "steps.synth_design.args.no_lc" -value "1" -objects $obj
set_property -name "steps.synth_design.args.shreg_min_size" -value "5" -objects $obj

# set the current synth run
current_run -synthesis [get_runs synth_1]

# Create 'impl_1' run (if not found)
if {[string equal [get_runs -quiet impl_1] ""]} {
    create_run -name impl_1 -part xc7k325tffg900-2 -flow {Vivado Implementation 2019} -strategy "Performance_NetDelay_low" -report_strategy {No Reports} -constrset constrs_1 -parent_run synth_1
} else {
  set_property strategy "Performance_NetDelay_low" [get_runs impl_1]
  set_property flow "Vivado Implementation 2019" [get_runs impl_1]
}
set obj [get_runs impl_1]
set_property set_report_strategy_name 1 $obj
set_property report_strategy {Vivado Implementation Default Reports} $obj
set_property set_report_strategy_name 0 $obj

gen_report impl_1_init_report_timing_summary_0 report_timing_summary:1.0 init_design impl_1
gen_report impl_1_opt_report_drc_0 report_drc:1.0 opt_design impl_1
gen_report impl_1_opt_report_timing_summary_0 report_timing_summary:1.0 opt_design impl_1
gen_report impl_1_power_opt_report_timing_summary_0 report_timing_summary:1.0 power_opt_design impl_1
gen_report impl_1_place_report_io_0 report_io:1.0 place_design impl_1
gen_report impl_1_place_report_utilization_0 report_utilization:1.0 place_design impl_1
gen_report impl_1_place_report_control_sets_0 report_control_sets:1.0 place_design impl_1
gen_report impl_1_place_report_incremental_reuse_0 report_incremental_reuse:1.0 place_design impl_1
gen_report impl_1_place_report_incremental_reuse_1 report_incremental_reuse:1.0 place_design impl_1
gen_report impl_1_place_report_timing_summary_0 report_timing_summary:1.0 place_design impl_1
gen_report impl_1_post_place_power_opt_report_timing_summary_0 report_timing_summary:1.0 post_place_power_opt_design impl_1
gen_report impl_1_phys_opt_report_timing_summary_0 report_timing_summary:1.0 phys_opt_design impl_1
gen_report impl_1_route_report_drc_0 report_drc:1.0 route_design impl_1
gen_report impl_1_route_report_methodology_0 report_methodology:1.0 route_design impl_1
gen_report impl_1_route_report_power_0 report_power:1.0 route_design impl_1
gen_report impl_1_route_report_route_status_0 report_route_status:1.0 route_design impl_1
gen_report impl_1_route_report_timing_summary_0 report_timing_summary:1.0 route_design impl_1
gen_report impl_1_route_report_incremental_reuse_0 report_incremental_reuse:1.0 route_design impl_1
gen_report impl_1_route_report_clock_utilization_0 report_clock_utilization:1.0 route_design impl_1
gen_report impl_1_route_report_bus_skew_0 report_bus_skew:1.1 route_design impl_1
gen_report impl_1_post_route_phys_opt_report_timing_summary_0 report_timing_summary:1.0 post_route_phys_opt_design impl_1
gen_report impl_1_post_route_phys_opt_report_bus_skew_0 report_bus_skew:1.1 post_route_phys_opt_design impl_1


set obj [get_runs impl_1]
set_property -name "strategy" -value "Performance_NetDelay_low" -objects $obj
set_property -name "steps.opt_design.args.directive" -value "Explore" -objects $obj
set_property -name "steps.place_design.args.directive" -value "ExtraNetDelay_low" -objects $obj
set_property -name "steps.phys_opt_design.is_enabled" -value "1" -objects $obj
set_property -name "steps.phys_opt_design.args.directive" -value "AggressiveExplore" -objects $obj
set_property -name "steps.route_design.args.directive" -value "NoTimingRelaxation" -objects $obj
set_property -name "steps.write_bitstream.args.readback_file" -value "0" -objects $obj
set_property -name "steps.write_bitstream.args.verbose" -value "0" -objects $obj

# set the current impl run
current_run -implementation [get_runs impl_1]

puts "INFO: Project created:${project_name}"

update_compile_order -fileset sources_1
reset_run -quiet synth_1
launch_runs impl_1 -to_step write_bitstream -jobs 7
wait_on_run impl_1
