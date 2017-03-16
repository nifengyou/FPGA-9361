`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/02/28 11:00:35
// Design Name: 
// Module Name: Test4ddr
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module SIM_DDR_IN(

    );
    /* DDR_IN */
// Input
reg             Clk;
reg             Reset;

reg             Ad80305_frame_in;
reg     [11:0]  Ad80305_data_in;
reg             Ad80305_clk_in;            
// Outputs
wire            Clk_out;
wire    [25:0]  data_in_to_device;
    /* DDR_OUT */
// Input
wire     [11:0]  Data_out_i;
wire     [11:0]  Data_out_q;
reg	    [11:0]	 Data_out_i_core;
reg     [11:0]  Data_out_q_core;
// Output
wire     [12:0] data_out_to_pins;
wire            Ad80305_clk_out;
wire     [11:0] Ad80305_data_out;
wire            Ad80305_frame_out;
   
// Counter
reg     [11:0]  Data_in_i;
reg     [11:0]  Data_in_q;

wire     [11:0]  DDR_Q1;
wire     [11:0]  DDR_Q2;

reg             Clk_aux_early;
reg             Clk_aux_later;
reg     [11:0]  counter_data_in;
    
/* Initail for Clk & Reset */
initial begin
/* Initialize Inputs */
    Clk = 0;
    Reset = 0;
    Ad80305_clk_in = 1;
    Ad80305_frame_in = 0;
    Ad80305_data_in = 12'b0;

    Clk_aux_early = 0;
    Clk_aux_later = 0;
    counter_data_in = 12'b0;
    Data_in_i = 12'b0;
    Data_in_q = 12'b0;            
       
// Wait 100 ns for global reset to finish
    #100;
                   
    Reset = 1;
    #100 Reset = 0;                  
end

always begin
    #2.5 Clk_aux_early = 0;
    #2.5 Clk_aux_early = 1;
end
        
always begin
    #2.5 Clk_aux_later = 1;
    #2.5 Clk_aux_later = 0;
end

always begin
    #5 Clk = 0;
    #5 Clk = 1;
end

always @ ( posedge Clk_aux_later )
begin
    Ad80305_clk_in = ~Ad80305_clk_in;
end
    
always begin
    #5 Ad80305_frame_in = 0;
    #5 Ad80305_frame_in = 1;
end
                
always @ ( posedge Clk_aux_early )
begin
    counter_data_in = counter_data_in + 12'd1;
end
        
always @ ( posedge Clk_aux_early )
begin
    Ad80305_data_in <= counter_data_in;
end
/* DDR_IN */
DDR_FDD_IN      SIM_DDR_IN (
  .data_in_from_pins    ( { Ad80305_frame_in, Ad80305_data_in } ),  // input wire [12 : 0] data_in_from_pins
  .clk_in               ( Ad80305_clk_in                        ),  // input wire clk_in
  .io_reset             ( Reset                                 ),  // input wire io_reset
  .clk_out              ( Clk_out                               ),  // output wire clk_out
  .data_in_to_device    ( data_in_to_device                     )   // output wire [25 : 0] data_in_to_device
); 

assign DDR_Q1 = data_in_to_device[24:13];
assign DDR_Q2 = data_in_to_device[11:0];
//* No FIFO Test
always @ ( posedge Clk )
begin
    if ( ( data_in_to_device[25] == 1'b1 ) && ( data_in_to_device[12] == 1'b0 ) )
        Data_in_q <= data_in_to_device[11:0];
    else if ( ( data_in_to_device[25] == 1'b0 ) && ( data_in_to_device[12] == 1'b1 ) )
        Data_in_q <= data_in_to_device[24:13];
    else
        Data_in_q <= 12'b0;
end

always @ ( posedge Clk )
begin
    if ( ( data_in_to_device[25] == 1'b1 ) && ( data_in_to_device[12] == 1'b0 ) )
        Data_in_i <= data_in_to_device[24:13];
    else if ( ( data_in_to_device[25] == 1'b0 ) && ( data_in_to_device[12] == 1'b1 ) )
        Data_in_i <= data_in_to_device[11:0];
    else
        Data_in_i <= 12'b0;
end

/* DDR_OUT */
assign Data_out_i = Data_in_i;
assign Data_out_q = Data_in_q;

always @ ( posedge Clk or posedge Reset )
begin
	if ( Reset == 1'b1 )
		Data_out_i_core <= 12'b0;
	else
		Data_out_i_core <= Data_out_i;
end	

always @ ( posedge Clk or posedge Reset )
begin
	if ( Reset == 1'b1 )
		Data_out_q_core <= 12'b0;
	else
        Data_out_q_core <= Data_out_q;
end			   

//* [2]
//* Send data to AD80305
//*
DDR_FDD_OUT         SIM_DDR_OUT (
  .data_out_to_pins     ( data_out_to_pins                                   ),          // output wire [12 : 0] data_out_to_pins
  .clk_in               ( Clk                                                ),                              // input wire clk_in
  .data_out_from_device ( { 1'b0,Data_out_q_core, 1'b1, Data_out_i_core }    ),  // input wire [25 : 0] data_out_from_device
  .io_reset             ( Reset                                              ),                          // input wire io_reset
  .clk_out              ( Ad80305_clk_out                                    )                            // output wire clk_out
);

assign Ad80305_data_out = data_out_to_pins[11:0];
assign Ad80305_frame_out = data_out_to_pins[12];

endmodule
