`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/07 10:47:49
// Design Name: 
// Module Name: sCLA4
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


module sCLA4(
    input [3:0]A,
    input [3:0]B,
    input Cin,
    output Cout, Gout, Pout,
    output [3:0]sum
    );
    
    wire [3:0]g, p;
    wire [3:1]c;
    
    CLL4 c0(.G(g), .P(p), .Cin(Cin), .C(c), .Gout(Gout), .Pout(Pout), .Cout(Cout));         // carry lookahead logic
    
    GPFA u0(.A(A[0]), .B(B[0]), .Cin(Cin), .G(g[0]), .P(p[0]), .Sum(sum[0]));
    GPFA u1(.A(A[1]), .B(B[1]), .Cin(c[1]), .G(g[1]), .P(p[1]), .Sum(sum[1]));
    GPFA u2(.A(A[2]), .B(B[2]), .Cin(c[2]), .G(g[2]), .P(p[2]), .Sum(sum[2]));
    GPFA u3(.A(A[3]), .B(B[3]), .Cin(c[3]), .G(g[3]), .P(p[3]), .Sum(sum[3]));              // G, P, sum generator
    
endmodule
