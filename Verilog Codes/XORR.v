`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/07 14:58:58
// Design Name: 
// Module Name: XORR
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


module XORR(
    input en,
    input [3:0]Rd1,
    input [3:0]Rd2,
    output [3:0]result
    );
    
    assign result[3] = en  && (Rd1[3] ^ Rd2[3]);
    assign result[2] = en  && (Rd1[2] ^ Rd2[2]);
    assign result[1] = en  && (Rd1[1] ^ Rd2[1]);
    assign result[0] = en  && (Rd1[0] ^ Rd2[0]);        // enable ¿Œ∞°Ω√, XOR operation
    
endmodule