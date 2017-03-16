@echo off
set xv_path=D:\\Xilinx\\Vivado\\2015.2\\bin
call %xv_path%/xsim SIM_DDR_IN_behav -key {Behavioral:sim_1:Functional:SIM_DDR_IN} -tclbatch SIM_DDR_IN.tcl -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
