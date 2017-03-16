`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/09/28 15:17:47
// Design Name: 
// Module Name: BARKER_GEN
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


module BARKER_GEN(
    Clk,
	Reset,
	
	Barker_Code
    );
// INPUTS
input           Clk;            // Clock
input           Reset;          // Reset
    
 // OUTPUTS
output          Barker_Code;    // LFSR data
    
// SIGNAL DECLARATIONS
reg             Barker_Code;
reg     [27:0]   shf_reg = 28'b1111111111110000000011110000;// LFSR data
    
// MAIN CODE
always @(posedge Clk or posedge Reset)
begin
    if (Reset)
        begin
            shf_reg <= 28'b1111111111110000000011110000;
            Barker_Code <= 1'b0;
        end
    else
        begin
            shf_reg[27:1] <= shf_reg[26:0];
            shf_reg[0]   <= shf_reg[27];
            Barker_Code  <= shf_reg[27];
        end
end
        
endmodule
