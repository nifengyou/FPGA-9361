// Copyright 1986-2015 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2015.2.1 (win64) Build 1302555 Wed Aug  5 13:06:02 MDT 2015
// Date        : Sat Oct 22 20:04:08 2016
// Host        : user-PC running 64-bit Service Pack 1  (build 7601)
// Command     : write_verilog -force -mode synth_stub
//               D:/Project_CMOS_FDD/Project_CMOS_FDD.srcs/sources_1/ip/ila_0/ila_0_stub.v
// Design      : ila_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a200tsbg484-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "ila,Vivado 2015.2.1" *)
module ila_0(clk, probe0, probe1, probe2, probe3, probe4, probe5, probe6)
/* synthesis syn_black_box black_box_pad_pin="clk,probe0[0:0],probe1[0:0],probe2[11:0],probe3[0:0],probe4[25:0],probe5[11:0],probe6[11:0]" */;
  input clk;
  input [0:0]probe0;
  input [0:0]probe1;
  input [11:0]probe2;
  input [0:0]probe3;
  input [25:0]probe4;
  input [11:0]probe5;
  input [11:0]probe6;
endmodule
