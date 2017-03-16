/************************************************************
module name     : PICO_ICS_FDD
project         : AD936x FPGA
version         : 0.1
author          : Suncai
called by       : 
calling         :
description     : This program is the top module of FPGA

revision history:
---------------------------------------------------------------
1. 2016-09-09, initial version
---------------------------------------------------------------
*************************************************************/
`timescale 1ns/1ns
module	PICO_ICS_FDD
    (
    //input signals
    Fpga_clk1,          // Nexys Video provides a 100MHz clock to the pin R4 of Artix 7
    Ad80305_data_clk_p,
    Ad80305_rx_frame_p,
    Ad80305_p0_d,       // In CMOS Mode, P0 is output of AD80305, i.e., P0(CMOS) -> FPGA
    Ad80305_ctrl_out,
    Ad80305_spi_do,	

    //output signals
    Fpga_led,
    
    Ad80305_fb_clk_p,
    Ad80305_fb_clk_n,
    Ad80305_tx_frame_p,
    Ad80305_tx_frame_n,
    Ad80305_p1_d,
    Ad80305_ctrl_in,
    Ad80305_resetb,
    Ad80305_spi_enb,
    Ad80305_spi_clk,
    Ad80305_spi_di,
    Ad80305_en_agc,
    Ad80305_enable,
    Ad80305_txnrx,		
    Ad80305_sync_in,
    // Vadj
    set_vadj,
    vadj_en
    
    );
/*****************************************************/
/*------- Input and Output Ports declaration --------*/
/*****************************************************/
input			Fpga_clk1;
input			Ad80305_data_clk_p;
input			Ad80305_rx_frame_p;
input	[11:0]	Ad80305_p0_d;
input	[7:0]	Ad80305_ctrl_out;
input			Ad80305_spi_do;

output	[7:0]	Fpga_led;
output			Ad80305_fb_clk_p;
output			Ad80305_fb_clk_n;
output			Ad80305_tx_frame_p;
output			Ad80305_tx_frame_n;
output	[11:0]	Ad80305_p1_d;
output	[3:0]	Ad80305_ctrl_in;
output			Ad80305_resetb;
output			Ad80305_spi_enb;
output			Ad80305_spi_clk;
output			Ad80305_spi_di;
output			Ad80305_sync_in;
output			Ad80305_en_agc;
output			Ad80305_enable;
output			Ad80305_txnrx;

output  [1:0]   set_vadj;
output          vadj_en;	

/*****************************************************
			 Variable declaration              
*****************************************************/
//* Clk
wire           Clk;     // 30.72M, Main clock to perform data transmision
wire			Clk_40m; //40M,  Test
wire			Clk_80m; //80M,  Test
wire			Clk_160m;//160M, Test
reg		[25:0]	Cnt_40m; // Test
reg		[27:0]	Cnt_80m; // Test
reg		[27:0]	Cnt_160m;// Test 

wire			Reset;   // Soft reset
wire			Pll_lock;
wire			Pll_lock_dejitter;

//* Data Interface
wire	[11:0]	Data_out_i_ad80305;				
wire	[11:0]	Data_out_q_ad80305;				
wire	[11:0]	Data_in_i_ad80305;				
wire	[11:0]	Data_in_q_ad80305;

//* Initialization Parameters
// Freq
wire            Reconfig_freq;
wire            Ad80305_bbpll_lock;
wire            Ad80305_rxpll_lock;
wire            Ad80305_txpll_lock;
reg     [32:0]  Rx_freq;
reg     [32:0]  Tx_freq;
wire    [2:0]   Rx_VcoDivider;
wire    [10:0]  Rx_FreqInteger;
wire    [22:0]  Rx_FreqFractional;
wire    [2:0]   Tx_VcoDivider;
wire    [10:0]  Tx_FreqInteger;
wire    [22:0]  Tx_FreqFractional;
// Gain
reg    [6:0]   Ad80305_rxgain;
reg    [8:0]   Ad80305_txgain;
// Reconfig
reg             Reconfig_ad80305;
reg     [1:0]   Reconfig_ad80305_reg;
reg     [19:0]  Reconfig_cnt;
wire            Reconfig_ind;
wire            Reconfig_pulse;
// Test
reg 			Wr_en_1byte_ad80305;
reg 			Wr_ind_1byte_ad80305;
reg 	[9:0]	Wr_addr_1byte_ad80305;
reg 	[7:0]	Wr_data_1byte_ad80305;
reg 			Rd_en_1byte_ad80305;
reg 	[9:0]	Rd_addr_1byte_ad80305;
wire 	[7:0]	Rd_data_1byte_ad80305;
// Indica
wire            Config_initial_done_ad80305;
wire            Config_initial_error_ad80305;

wire            Barker_Code;
wire            I_src_bit;
wire            Q_src_bit;
wire    [11:0]  I_symb;
wire    [11:0]  Q_symb;

/*****************************************************/
/*-------               Main Code            --------*/
/*****************************************************/
//* Generate "Reset" signal
RESET       U_RESET
    (
    //input signals
    .Clk    ( Fpga_clk1 ),

    //output signals
    .Reset  ( Reset     )
    );

//* Set VADJ
VADJ_SET    U_VADJ_SET
	(
	//* Inputs
	.Clk       ( Fpga_clk1 ),
	.Reset     ( Reset     ),
	
	//* Outputs
	.SET_VADJ  ( set_vadj  ),
	.VADJ_EN   ( vadj_en   )
	);
	
//* MMCM
clk_wiz_0       U_PLL
   (
   // Clock in ports
    .clk_in1    (Fpga_clk1),        // input clk_in1
    // Clock out ports
    .clk_out1   ( Clk       ),      // output clk_out1, 30.72MHz
    .clk_out2   ( Clk_40m   ),      // output clk_out2, 40MHz
    .clk_out3   ( Clk_80m   ),      // output clk_out3, 80MHz
    .clk_out4   ( Clk_160m  ),      // output clk_out4, 160MHz
    // Status and control signals
    .reset      ( Reset     ),      // input reset
    .locked     ( Pll_lock  )       // output locked
    );
    
//* Wait 1s to dejitter clock generated by MMCM 
PLL_LD_DEJITTER		U_PLL_LD_DEJITTER
	(
    //input signals
	.Clk               ( Clk               ),
	.Pll_ld            ( Pll_lock          ),

    //output signals
	.Pll_ld_dejitter   ( Pll_lock_dejitter )
	);

//* LED Interface, Test for MMCM
assign Fpga_led[0] = ~Pll_lock_dejitter;                    //LED D0
assign Fpga_led[1] = Cnt_40m[25];                           //LED D1
assign Fpga_led[2] = Cnt_80m[26];                           //LED D2
assign Fpga_led[3] = Cnt_160m[27];                          //LED D3
assign Fpga_led[4] = Ad80305_bbpll_lock;                    //LED D4
assign Fpga_led[5] = Ad80305_rxpll_lock;                    //LED D5
assign Fpga_led[6] = Ad80305_txpll_lock;                    //LED D6
assign Fpga_led[7] = Config_initial_done_ad80305;           //LED D7

always @ ( posedge Clk_40m )
begin
	Cnt_40m <= Cnt_40m + 26'b01;
end
	
always @ ( posedge Clk_80m )
begin
	Cnt_80m <= Cnt_80m + 28'b01;
end

always @ ( posedge Clk_160m )
begin
	Cnt_160m <= Cnt_160m + 28'b01;
end

//* Parameter set
// 1, These signals can be set to "wire" for test using "chipscope",
// here, set to "reg" for initialization.
// 2, "Reconfig_freq"is an high active pusle signal, it is set in Module "FREQ_SET_40M" when SPI configuration has finished;
// and it is active not only after SPI configuration has finished, but also need "Reconfig_ad80305" is active, which can be seen in module "AD80305_SPI_INTF".
// Hence, "Reconfig_freq" is a test signal worked in "Reconfig" process.
always @ ( posedge Clk or posedge Reset )
begin
    if( Reset == 1'b1 )
    begin
        Rx_freq <= 33'd1900000000;
        Tx_freq <= 33'd1900000000;
        Reconfig_ad80305 <= 1'b0;			//* A high active pluse, write 1 then write 0 
        Wr_en_1byte_ad80305 = 1'b0; 		//* A high active pluse, write 1 then write 0   
        Wr_ind_1byte_ad80305 = 1'b0;   
        Wr_addr_1byte_ad80305 = 10'b0000000000;    
        Wr_data_1byte_ad80305 = 8'b00000000;
        Rd_en_1byte_ad80305 = 1'b0;		//* A high active pluse, write 1 then write 0
        Rd_addr_1byte_ad80305 = 10'b0;
        Ad80305_rxgain  = 7'd34;
        Ad80305_txgain  = 9'd0;
    end
    else
        ;
end

// Reconfig_ad80305, Test
always @ ( posedge Clk )
begin
    Reconfig_ad80305_reg <= {Reconfig_ad80305_reg[0],Reconfig_ad80305};
end

always @ ( posedge Clk )
begin
    if( ( Reconfig_ad80305_reg[0] == 1'b1 ) && ( Reconfig_ad80305_reg[1] == 1'b0 ) )
        Reconfig_cnt <= 20'd0;
    else if( Reconfig_cnt < 20'd307200 )
        Reconfig_cnt <= Reconfig_cnt + 20'd1;
    else
        ;
end

assign  Reconfig_ind   = ( Reconfig_cnt < 20'd15 ) ? 1'b0 : 1'b1;       // used to set signal "Ad80305_resetb"
assign  Reconfig_pulse = ( Reconfig_cnt < 20'd307200 ) ? 1'b0 : 1'b1;   // used in module "AD80305_SPI_INTF"

assign Ad80305_resetb = Pll_lock & Reconfig_ind;

//* Set RF LO Frequency
FREQ_SET_40M    U_FREQ_SET_40M
    (
    //input signals
    .Reset                  ( Reset                     ),
    .Clk                    ( Clk                       ),
    .Rx_freq                ( Rx_freq                   ),
    .Tx_freq                ( Tx_freq                   ),
    .Config_initial_done	( Config_initial_done_ad80305 ),	

    //output signals
    .Rx_VcoDivider          ( Rx_VcoDivider            ),
    .Rx_FreqInteger         ( Rx_FreqInteger           ),
    .Rx_FreqFractional      ( Rx_FreqFractional        ),
    .Tx_VcoDivider          ( Tx_VcoDivider            ),
    .Tx_FreqInteger         ( Tx_FreqInteger           ),
    .Tx_FreqFractional      ( Tx_FreqFractional        ),
    .Reconfig_freq          ( Reconfig_freq            )       
    );
    
//* AD80305 SPI read and write
//AD80305 configuration via spi interface
AD80305_SPI_INTF	U_AD80305_SPI_INTF
    (
    //input signals
    .Clk                    ( Clk                       ),
    .Reset					( Reset                     ),
    .Pll_locked				( Pll_lock_dejitter         ),
    .Reconfig_ad80305		( Reconfig_pulse            ),
    .Reconfig_freq          ( Reconfig_freq             ),
    .Wr_en_1byte			( Wr_en_1byte_ad80305       ),		
    .Wr_ind_1byte			( Wr_ind_1byte_ad80305      ),	
    .Wr_addr_1byte			( Wr_addr_1byte_ad80305     ),	
    .Wr_data_1byte			( Wr_data_1byte_ad80305     ), 
    .Rd_en_1byte			( Rd_en_1byte_ad80305       ),		
    .Rd_ind_1byte			( 1'b0                      ),
    .Rd_addr_1byte			( Rd_addr_1byte_ad80305     ),
    .Spi_do_ad80305			( Ad80305_spi_do            ),
    .RxVCO_divider          ( Rx_VcoDivider             ),
    .Freq_rx_integer        ( Rx_FreqInteger            ),
    .Freq_rx_fractional     ( Rx_FreqFractional         ),
    .TxVCO_divider          ( Tx_VcoDivider             ),
    .Freq_tx_integer        ( Tx_FreqInteger            ),
    .Freq_tx_fractional     ( Tx_FreqFractional         ),
    .Rx_gain_initial		( Ad80305_rxgain            ),      //( 7'd34                     ),      //* Address: 0x10C
    .Tx_gain_initial		( Ad80305_txgain            ),      //* ATT 0.25dB/LSB, Address: 0x075, 0x076 0~359
	.Rx_data_delay			( 4'hF                      ),      //* 0.3ns/LSB, so the RX data delay = Rx_data_delay * 0.3ns
	.Tx_data_delay			( 4'hF                      ),      //* 0.3ns/LSB, so the TX data delay = Tx_data_delay * 0.3ns 

    //output signals
    .Rd_data_1byte			( Rd_data_1byte_ad80305       ),
    .Config_initial_error	( Config_initial_error_ad80305),
    .Config_initial_done	( Config_initial_done_ad80305 ),	
    .Spi_clk_ad80305		( Ad80305_spi_clk             ),
    .Spi_enb_ad80305		( Ad80305_spi_enb             ),
    .Spi_di_ad80305			( Ad80305_spi_di              ),
    .Enable_ad80305			( Ad80305_enable              ),
    .Txnrx_ad80305			( Ad80305_txnrx               ),
    .En_agc_ad80305			( Ad80305_en_agc              )
    
    );

assign Ad80305_sync_in = 1'b0;		//* Must be set to 0 when you do not need SYNC multi-AD9361
assign Ad80305_bbpll_lock = Ad80305_ctrl_out[5];  
assign Ad80305_rxpll_lock = Ad80305_ctrl_out[6];  
assign Ad80305_txpll_lock = Ad80305_ctrl_out[7];

//* AD80305 data read and write
//* For test only
//*  	
//* RX Part
//* In FPGA, using the falling edge to sample the I data, rising edge to sample the Q data,
//* At rising edge, Align the I data to Q data
//* So we set a 4.5ns delay to data path in AD80305
//*
AD80305_DATA_INTF_RX	U_AD80305_DATA_INTF_RX
    (
    //input signals
    .Clk					( Clk                       ),
    .Reset                  ( Reset                     ),
    .Start_transfer			( Config_initial_done_ad80305 ),
    .Ad80305_clk_in			( Ad80305_data_clk_p        ),
    .Ad80305_frame_in		( Ad80305_rx_frame_p        ),
    .Ad80305_data_in		( Ad80305_p0_d              ),			

    //output signals
    .Clk_out                (                           ),
    .Data_in_i				( Data_in_i_ad80305         ),
    .Data_in_q				( Data_in_q_ad80305         )
    
    );

//* TX Part
//* In AD80305, using the falling edge to sample the I data, rising edge to sample the Q data,
//* At rising edge, Align the I data to Q data
//* So we set a 4.5ns delay to data path in AD80305
//*
//* According to datasheet, In CMOS mode, set these signals to GND
assign Ad80305_fb_clk_n = 1'b0;
assign Ad80305_tx_frame_n = 1'b0;
 
// assign Data_out_i_ad80305 = Data_in_i_ad80305;
// assign Data_out_q_ad80305 = Data_in_q_ad80305;
    
AD80305_DATA_INTF_TX	U_AD80305_DATA_INTF_TX
    (
    //input signals
    .Clk					( Clk                       ),
    .Reset					( Reset                     ),
    .Data_out_i				( Data_out_i_ad80305        ),
    .Data_out_q				( Data_out_q_ad80305        ),

    //output signals
    .Ad80305_clk_out		( Ad80305_fb_clk_p          ),
    .Ad80305_frame_out		( Ad80305_tx_frame_p        ),
    .Ad80305_data_out		( Ad80305_p1_d              )
    
    );  

/*****************************************************/
/*-------               Test Code            --------*/
/*****************************************************/
//* Generate Barker Code as I/Q source bit-stream
BARKER_GEN      U_BARKER_GEN
    (
    .Clk           ( Clk           ),
	.Reset         ( Reset         ),
	
	.Barker_Code   ( Barker_Code   )
    );
    
assign I_src_bit = Barker_Code;
assign Q_src_bit = Barker_Code; 
 
QPSK_I_Q_MAPPER     U_I_MAPPER
    (
    .Clk            ( Clk           ), 
    .Addr           ( I_src_bit     ), 
        
    .I_Q_Data       ( I_symb        )
    );
 
QPSK_I_Q_MAPPER     U_Q_MAPPER
    (
    .Clk            ( Clk           ), 
    .Addr           ( Q_src_bit     ), 
            
    .I_Q_Data       ( Q_symb        )
    );

assign Data_out_i_ad80305 = I_symb;
assign Data_out_q_ad80305 = Q_symb;

ila_0               U_ILA_RX_IQ
    (
	.clk       ( Clk                   ), // input wire clk


	.probe0    ( Data_out_i_ad80305    ), // input wire [11:0]  probe0  
	.probe1    ( Data_out_q_ad80305    )  // input wire [11:0]  probe1
    );

endmodule