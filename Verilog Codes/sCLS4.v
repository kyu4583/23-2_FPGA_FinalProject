`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/07 13:38:36
// Design Name: 
// Module Name: sCLS4
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

module sCLS4(
    input [3:0]A,
    input [3:0]B,
    input Cin,
    output Cout, Gout, Pout,
    output [3:0]sum,
    output overflow
    );
    
    wire [3:0]comp_B;
    wire [3:0]g, p;
    wire [3:1]c;
    
    
//    always@(*)
//    begin    
////    if(B[3]==1)
//    comp_B= ~B + 4'b0001;
//    end

    
    
    CLL4 c0(.G(g), .P(p), .Cin(Cin), .C(c), .Gout(Gout), .Pout(Pout), .Cout(Cout));
    
    GPFA u0(.A(A[0]), .B(comp_B[0]), .Cin(Cin), .G(g[0]), .P(p[0]), .Sum(sum[0]));
    GPFA u1(.A(A[1]), .B(comp_B[1]), .Cin(c[1]), .G(g[1]), .P(p[1]), .Sum(sum[1]));
    GPFA u2(.A(A[2]), .B(comp_B[2]), .Cin(c[2]), .G(g[2]), .P(p[2]), .Sum(sum[2]));
    GPFA u3(.A(A[3]), .B(comp_B[3]), .Cin(c[3]), .G(g[3]), .P(p[3]), .Sum(sum[3]));
    
    assign overflow = (A[3]!=B[3]) && (A[3]!=sum[3]);
    
endmodule
