# 
# Synthesis run script generated by Vivado
# 

debug::add_scope template.lib 1
set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
create_project -in_memory -part xc7a200tsbg484-1

set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir D:/Project_CMOS_FDD/Project_CMOS_FDD.cache/wt [current_project]
set_property parent.project_path D:/Project_CMOS_FDD/Project_CMOS_FDD.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property board_part digilentinc.com:nexys_video:part0:1.1 [current_project]
read_ip D:/Project_CMOS_FDD/Project_CMOS_FDD.srcs/sources_1/ip/ila_0/ila_0.xci
set_property used_in_implementation false [get_files -all d:/Project_CMOS_FDD/Project_CMOS_FDD.srcs/sources_1/ip/ila_0/ila_0.dcp]
set_property is_locked true [get_files D:/Project_CMOS_FDD/Project_CMOS_FDD.srcs/sources_1/ip/ila_0/ila_0.xci]

synth_design -top ila_0 -part xc7a200tsbg484-1 -mode out_of_context
rename_ref -prefix_all ila_0_
write_checkpoint -noxdef ila_0.dcp
catch { report_utilization -file ila_0_utilization_synth.rpt -pb ila_0_utilization_synth.pb }
if { [catch {
  file copy -force D:/Project_CMOS_FDD/Project_CMOS_FDD.runs/ila_0_synth_1/ila_0.dcp D:/Project_CMOS_FDD/Project_CMOS_FDD.srcs/sources_1/ip/ila_0/ila_0.dcp
} _RESULT ] } { 
  error "ERROR: Unable to successfully create or copy the sub-design checkpoint file."
}
if { [catch {
  write_verilog -force -mode synth_stub D:/Project_CMOS_FDD/Project_CMOS_FDD.srcs/sources_1/ip/ila_0/ila_0_stub.v
} _RESULT ] } { 
  puts "CRITICAL WARNING: Unable to successfully create a Verilog synthesis stub for the sub-design. This may lead to errors in top level synthesis of the design. Error reported: $_RESULT"
}
if { [catch {
  write_vhdl -force -mode synth_stub D:/Project_CMOS_FDD/Project_CMOS_FDD.srcs/sources_1/ip/ila_0/ila_0_stub.vhdl
} _RESULT ] } { 
  puts "CRITICAL WARNING: Unable to successfully create a VHDL synthesis stub for the sub-design. This may lead to errors in top level synthesis of the design. Error reported: $_RESULT"
}
if { [catch {
  write_verilog -force -mode funcsim D:/Project_CMOS_FDD/Project_CMOS_FDD.srcs/sources_1/ip/ila_0/ila_0_funcsim.v
} _RESULT ] } { 
  puts "CRITICAL WARNING: Unable to successfully create the Verilog functional simulation sub-design file. Post-Synthesis Functional Simulation with this file may not be possible or may give incorrect results. Error reported: $_RESULT"
}
if { [catch {
  write_vhdl -force -mode funcsim D:/Project_CMOS_FDD/Project_CMOS_FDD.srcs/sources_1/ip/ila_0/ila_0_funcsim.vhdl
} _RESULT ] } { 
  puts "CRITICAL WARNING: Unable to successfully create the VHDL functional simulation sub-design file. Post-Synthesis Functional Simulation with this file may not be possible or may give incorrect results. Error reported: $_RESULT"
}
