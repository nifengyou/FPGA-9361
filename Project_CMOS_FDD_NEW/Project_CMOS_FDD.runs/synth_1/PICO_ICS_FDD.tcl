# 
# Synthesis run script generated by Vivado
# 

set_param xicom.use_bs_reader 1
debug::add_scope template.lib 1
set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
create_project -in_memory -part xc7a200tsbg484-1

set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir D:/Suncai/Project_CMOS_FDD_NEW/Project_CMOS_FDD.cache/wt [current_project]
set_property parent.project_path D:/Suncai/Project_CMOS_FDD_NEW/Project_CMOS_FDD.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property board_part digilentinc.com:nexys_video:part0:1.1 [current_project]
add_files -quiet D:/Suncai/Project_CMOS_FDD_NEW/Project_CMOS_FDD.runs/clk_wiz_0_synth_1/clk_wiz_0.dcp
set_property used_in_implementation false [get_files D:/Suncai/Project_CMOS_FDD_NEW/Project_CMOS_FDD.runs/clk_wiz_0_synth_1/clk_wiz_0.dcp]
add_files -quiet D:/Suncai/Project_CMOS_FDD_NEW/Project_CMOS_FDD.runs/ila_0_synth_1/ila_0.dcp
set_property used_in_implementation false [get_files D:/Suncai/Project_CMOS_FDD_NEW/Project_CMOS_FDD.runs/ila_0_synth_1/ila_0.dcp]
read_verilog -library xil_defaultlib {
  D:/Suncai/Project_CMOS_FDD_NEW/Project_CMOS_FDD.srcs/sources_1/imports/SRC/AD80305_CONFIG_PART3_TX_FILTER.v
  D:/Suncai/Project_CMOS_FDD_NEW/Project_CMOS_FDD.srcs/sources_1/imports/SRC/AD80305_CONFIG_PART11_MIXER_SUBTABLE.v
  D:/Suncai/Project_CMOS_FDD_NEW/Project_CMOS_FDD.srcs/sources_1/imports/SRC/AD80305_CONFIG_PART10_RFVCO.v
  D:/Suncai/Project_CMOS_FDD_NEW/Project_CMOS_FDD.srcs/sources_1/imports/SRC/AD80305_CONFIG_PART21_RSSI_POWER_MEASURE.v
  D:/Suncai/Project_CMOS_FDD_NEW/Project_CMOS_FDD.srcs/sources_1/imports/SRC/AD80305_CONFIG_PART7_CONTROL_OUT.v
  D:/Suncai/Project_CMOS_FDD_NEW/Project_CMOS_FDD.srcs/sources_1/imports/SRC/AD80305_CONFIG_PART18_ADC_TUNE.v
  D:/Suncai/Project_CMOS_FDD_NEW/Project_CMOS_FDD.srcs/sources_1/imports/SRC/AD80305_CONFIG_PART19_TX_QUAD_CAL.v
  D:/Suncai/Project_CMOS_FDD_NEW/Project_CMOS_FDD.srcs/sources_1/imports/SRC/AD80305_SPI_READ_WRITE.v
  D:/Suncai/Project_CMOS_FDD_NEW/Project_CMOS_FDD.srcs/sources_1/imports/SRC/AD80305_CONFIG_PART12_RX_GAIN_TABLE.v
  D:/Suncai/Project_CMOS_FDD_NEW/Project_CMOS_FDD.srcs/sources_1/imports/SRC/AD80305_CONFIG_PART4_RX_FILTER.v
  D:/Suncai/Project_CMOS_FDD_NEW/Project_CMOS_FDD.srcs/sources_1/imports/SRC/AD80305_CONFIG_PART13_RX_MANUAL_GAIN.v
  D:/Suncai/Project_CMOS_FDD_NEW/Project_CMOS_FDD.srcs/sources_1/imports/SRC/AD80305_CONFIG_PART20_TX_ATT.v
  D:/Suncai/Project_CMOS_FDD_NEW/Project_CMOS_FDD.srcs/sources_1/imports/SRC/AD80305_CONFIG_PART8_GPO.v
  D:/Suncai/Project_CMOS_FDD_NEW/Project_CMOS_FDD.srcs/sources_1/imports/SRC/AD80305_CONFIG_PART2_BBPLL.v
  D:/Suncai/Project_CMOS_FDD_NEW/Project_CMOS_FDD.srcs/sources_1/imports/SRC/AD80305_CONFIG_PART15_TX_BB_FILTER_TUNE.v
  D:/Suncai/Project_CMOS_FDD_NEW/Project_CMOS_FDD.srcs/sources_1/imports/SRC/AD80305_CONFIG_PART17_TX_2ND_FILTER.v
  D:/Suncai/Project_CMOS_FDD_NEW/Project_CMOS_FDD.srcs/sources_1/imports/SRC/AD80305_CONFIG_PART1.v
  D:/Suncai/Project_CMOS_FDD_NEW/Project_CMOS_FDD.srcs/sources_1/imports/SRC/AD80305_CONFIG_PART5_PARALLEL_PORT.v
  D:/Suncai/Project_CMOS_FDD_NEW/Project_CMOS_FDD.srcs/sources_1/imports/SRC/AD80305_CONFIG_PART6_AUXDAC_AUXADC.v
  D:/Suncai/Project_CMOS_FDD_NEW/Project_CMOS_FDD.srcs/sources_1/imports/SRC/AD80305_CONFIG_PART9_ENSM.v
  D:/Suncai/Project_CMOS_FDD_NEW/Project_CMOS_FDD.srcs/sources_1/imports/SRC/AD80305_CONFIG_PART16_RX_TIA.v
  D:/Suncai/Project_CMOS_FDD_NEW/Project_CMOS_FDD.srcs/sources_1/imports/SRC/AD80305_CONFIG_PART14_RX_BB_FILTER_TUNE.v
  D:/Suncai/Project_CMOS_FDD_NEW/Project_CMOS_FDD.srcs/sources_1/imports/SRC/AD80305_CONFIG_PART22_END_ENABLE_RX_TX.v
  D:/Suncai/Project_CMOS_FDD_NEW/Project_CMOS_FDD.srcs/sources_1/imports/SRC/FREQ_SET_40M.v
  D:/Suncai/Project_CMOS_FDD_NEW/Project_CMOS_FDD.srcs/sources_1/imports/SRC/AD80305_SPI_INTF.v
  D:/Suncai/Project_CMOS_FDD_NEW/Project_CMOS_FDD.srcs/sources_1/imports/SRC/VADJ_SET.v
  D:/Suncai/Project_CMOS_FDD_NEW/Project_CMOS_FDD.srcs/sources_1/imports/SRC/PLL_LD_DEJITTER.v
  D:/Suncai/Project_CMOS_FDD_NEW/Project_CMOS_FDD.srcs/sources_1/imports/SRC/RESET.v
  D:/Suncai/Project_CMOS_FDD_NEW/Project_CMOS_FDD.srcs/sources_1/imports/SRC/PICO_ICS_FDD.v
}
read_xdc D:/Suncai/Project_CMOS_FDD_NEW/Project_CMOS_FDD.srcs/constrs_1/imports/SRC/NexysVideo_Master.xdc
set_property used_in_implementation false [get_files D:/Suncai/Project_CMOS_FDD_NEW/Project_CMOS_FDD.srcs/constrs_1/imports/SRC/NexysVideo_Master.xdc]

synth_design -top PICO_ICS_FDD -part xc7a200tsbg484-1
write_checkpoint -noxdef PICO_ICS_FDD.dcp
catch { report_utilization -file PICO_ICS_FDD_utilization_synth.rpt -pb PICO_ICS_FDD_utilization_synth.pb }
