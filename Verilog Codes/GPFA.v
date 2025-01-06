`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/28 23:31:48
// Design Name: 
// Module Name: GPFA
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


module GPFA(
    input A, B, Cin,        // 1bit input
    output G, P, Sum        // 1bit output
    );
    
    assign G = A & B;       // G = AB
    assign P = A ^ B;       // P = A^B
    assign Sum = P ^ Cin;   // Sum = P^Cin = A^B^Cin
    
endmodule
