proc start_step { step } {
  set stopFile ".stop.rst"
  if {[file isfile .stop.rst]} {
    puts ""
    puts "*** Halting run - EA reset detected ***"
    puts ""
    puts ""
    return -code error
  }
  set beginFile ".$step.begin.rst"
  set platform "$::tcl_platform(platform)"
  set user "$::tcl_platform(user)"
  set pid [pid]
  set host ""
  if { [string equal $platform unix] } {
    if { [info exist ::env(HOSTNAME)] } {
      set host $::env(HOSTNAME)
    }
  } else {
    if { [info exist ::env(COMPUTERNAME)] } {
      set host $::env(COMPUTERNAME)
    }
  }
  set ch [open $beginFile w]
  puts $ch "<?xml version=\"1.0\"?>"
  puts $ch "<ProcessHandle Version=\"1\" Minor=\"0\">"
  puts $ch "    <Process Command=\".planAhead.\" Owner=\"$user\" Host=\"$host\" Pid=\"$pid\">"
  puts $ch "    </Process>"
  puts $ch "</ProcessHandle>"
  close $ch
}

proc end_step { step } {
  set endFile ".$step.end.rst"
  set ch [open $endFile w]
  close $ch
}

proc step_failed { step } {
  set endFile ".$step.error.rst"
  set ch [open $endFile w]
  close $ch
}

set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000

start_step init_design
set rc [catch {
  create_msg_db init_design.pb
  set_param xicom.use_bs_reader 1
  debug::add_scope template.lib 1
  create_project -in_memory -part xc7a200tsbg484-1
  set_property board_part digilentinc.com:nexys_video:part0:1.1 [current_project]
  set_property design_mode GateLvl [current_fileset]
  set_property webtalk.parent_dir D:/Suncai/Project_CMOS_FDD_NEW/Project_CMOS_FDD.cache/wt [current_project]
  set_property parent.project_path D:/Suncai/Project_CMOS_FDD_NEW/Project_CMOS_FDD.xpr [current_project]
  set_property ip_repo_paths d:/Suncai/Project_CMOS_FDD_NEW/Project_CMOS_FDD.cache/ip [current_project]
  set_property ip_output_repo d:/Suncai/Project_CMOS_FDD_NEW/Project_CMOS_FDD.cache/ip [current_project]
  add_files -quiet D:/Suncai/Project_CMOS_FDD_NEW/Project_CMOS_FDD.runs/synth_1/PICO_ICS_FDD.dcp
  add_files -quiet D:/Suncai/Project_CMOS_FDD_NEW/Project_CMOS_FDD.runs/clk_wiz_0_synth_1/clk_wiz_0.dcp
  set_property netlist_only true [get_files D:/Suncai/Project_CMOS_FDD_NEW/Project_CMOS_FDD.runs/clk_wiz_0_synth_1/clk_wiz_0.dcp]
  add_files -quiet D:/Suncai/Project_CMOS_FDD_NEW/Project_CMOS_FDD.runs/ila_0_synth_1/ila_0.dcp
  set_property netlist_only true [get_files D:/Suncai/Project_CMOS_FDD_NEW/Project_CMOS_FDD.runs/ila_0_synth_1/ila_0.dcp]
  read_xdc -mode out_of_context -ref clk_wiz_0 -cells inst d:/Suncai/Project_CMOS_FDD_NEW/Project_CMOS_FDD.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0_ooc.xdc
  set_property processing_order EARLY [get_files d:/Suncai/Project_CMOS_FDD_NEW/Project_CMOS_FDD.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0_ooc.xdc]
  read_xdc -prop_thru_buffers -ref clk_wiz_0 -cells inst d:/Suncai/Project_CMOS_FDD_NEW/Project_CMOS_FDD.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0_board.xdc
  set_property processing_order EARLY [get_files d:/Suncai/Project_CMOS_FDD_NEW/Project_CMOS_FDD.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0_board.xdc]
  read_xdc -ref clk_wiz_0 -cells inst d:/Suncai/Project_CMOS_FDD_NEW/Project_CMOS_FDD.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.xdc
  set_property processing_order EARLY [get_files d:/Suncai/Project_CMOS_FDD_NEW/Project_CMOS_FDD.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.xdc]
  read_xdc -mode out_of_context -ref ila_0 d:/Suncai/Project_CMOS_FDD_NEW/Project_CMOS_FDD.srcs/sources_1/ip/ila_0/ila_0_ooc.xdc
  set_property processing_order EARLY [get_files d:/Suncai/Project_CMOS_FDD_NEW/Project_CMOS_FDD.srcs/sources_1/ip/ila_0/ila_0_ooc.xdc]
  read_xdc -ref ila_0 d:/Suncai/Project_CMOS_FDD_NEW/Project_CMOS_FDD.srcs/sources_1/ip/ila_0/ila_v5_1/constraints/ila.xdc
  set_property processing_order EARLY [get_files d:/Suncai/Project_CMOS_FDD_NEW/Project_CMOS_FDD.srcs/sources_1/ip/ila_0/ila_v5_1/constraints/ila.xdc]
  read_xdc D:/Suncai/Project_CMOS_FDD_NEW/Project_CMOS_FDD.srcs/constrs_1/imports/SRC/NexysVideo_Master.xdc
  link_design -top PICO_ICS_FDD -part xc7a200tsbg484-1
  close_msg_db -file init_design.pb
} RESULT]
if {$rc} {
  step_failed init_design
  return -code error $RESULT
} else {
  end_step init_design
}

start_step opt_design
set rc [catch {
  create_msg_db opt_design.pb
  catch {write_debug_probes -quiet -force debug_nets}
  opt_design 
  write_checkpoint -force PICO_ICS_FDD_opt.dcp
  catch {report_drc -file PICO_ICS_FDD_drc_opted.rpt}
  close_msg_db -file opt_design.pb
} RESULT]
if {$rc} {
  step_failed opt_design
  return -code error $RESULT
} else {
  end_step opt_design
}

start_step place_design
set rc [catch {
  create_msg_db place_design.pb
  catch {write_hwdef -file PICO_ICS_FDD.hwdef}
  place_design 
  write_checkpoint -force PICO_ICS_FDD_placed.dcp
  catch { report_io -file PICO_ICS_FDD_io_placed.rpt }
  catch { report_utilization -file PICO_ICS_FDD_utilization_placed.rpt -pb PICO_ICS_FDD_utilization_placed.pb }
  catch { report_control_sets -verbose -file PICO_ICS_FDD_control_sets_placed.rpt }
  close_msg_db -file place_design.pb
} RESULT]
if {$rc} {
  step_failed place_design
  return -code error $RESULT
} else {
  end_step place_design
}

start_step route_design
set rc [catch {
  create_msg_db route_design.pb
  route_design 
  write_checkpoint -force PICO_ICS_FDD_routed.dcp
  catch { report_drc -file PICO_ICS_FDD_drc_routed.rpt -pb PICO_ICS_FDD_drc_routed.pb }
  catch { report_timing_summary -warn_on_violation -max_paths 10 -file PICO_ICS_FDD_timing_summary_routed.rpt -rpx PICO_ICS_FDD_timing_summary_routed.rpx }
  catch { report_power -file PICO_ICS_FDD_power_routed.rpt -pb PICO_ICS_FDD_power_summary_routed.pb }
  catch { report_route_status -file PICO_ICS_FDD_route_status.rpt -pb PICO_ICS_FDD_route_status.pb }
  catch { report_clock_utilization -file PICO_ICS_FDD_clock_utilization_routed.rpt }
  close_msg_db -file route_design.pb
} RESULT]
if {$rc} {
  step_failed route_design
  return -code error $RESULT
} else {
  end_step route_design
}

start_step write_bitstream
set rc [catch {
  create_msg_db write_bitstream.pb
  write_bitstream -force PICO_ICS_FDD.bit 
  catch { write_sysdef -hwdef PICO_ICS_FDD.hwdef -bitfile PICO_ICS_FDD.bit -meminfo PICO_ICS_FDD.mmi -ltxfile debug_nets.ltx -file PICO_ICS_FDD.sysdef }
  close_msg_db -file write_bitstream.pb
} RESULT]
if {$rc} {
  step_failed write_bitstream
  return -code error $RESULT
} else {
  end_step write_bitstream
}

