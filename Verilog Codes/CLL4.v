`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/28 23:35:45
// Design Name: 
// Module Name: CLL4
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


module CLL4(
    input [3:0]G, P,            // 4bit input
    input Cin,                  // 1bit input
    output Gout, Pout,          // 1bit output
    output [3:1]C,              // 4bit output
    output Cout                 // 1bit output
    );
    
    assign C[1] = G[0] | (P[0] & Cin);                                              // C1 = G0 + P0*Cin
    assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & Cin);                       // C2 = G1 + P1*C1
    assign C[3] = G[2] | (P[2] & G[1]) | (P[2]&P[1]&G[0]) | (P[2]&P[1]&P[0]&Cin);   // C3 = G2 + P2*C2
    
    assign Gout = G[3] | (P[3]&G[2]) | (P[3]&P[2]&G[1]) | (P[3]&P[2]&P[1]&G[0]) ;   // Gout = G3 + P3*G2 + P3*P2*G1 + P3*P2*P1*G0
    assign Pout = P[3]&P[2]&P[1]&P[0];                                              // Pout = P3*P2*P1*P0
    
    assign Cout = Gout | (Pout&Cin);    // Cout = Gout + Pout*Cin
    
endmodule
