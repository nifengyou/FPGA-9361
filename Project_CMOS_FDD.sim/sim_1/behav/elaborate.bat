@echo off
set xv_path=D:\\Xilinx\\Vivado\\2015.2\\bin
call %xv_path%/xelab  -wto c5df76784e6e4be497fef5e042b1b9b4 -m64 --debug typical --relax --mt 2 --include "../../../Project_CMOS_FDD.srcs/sources_1/ip/ila_0/ila_v5_1/hdl/verilog" --include "../../../Project_CMOS_FDD.srcs/sources_1/ip/ila_0/ltlib_v1_0/hdl/verilog" --include "../../../Project_CMOS_FDD.srcs/sources_1/ip/ila_0/xsdbs_v1_0/hdl/verilog" -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip --snapshot SIM_DDR_IN_behav xil_defaultlib.SIM_DDR_IN xil_defaultlib.glbl -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
