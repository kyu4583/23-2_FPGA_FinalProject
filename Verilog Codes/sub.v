`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/07 13:17:07
// Design Name: 
// Module Name: sub
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


module sub(
    input en,
    input [3:0]Rd1,
    input [3:0]Rd2,
    output [3:0]result,
    output overflow
    );
    
    wire [3:0]sum;
    wire [3:0]comp_Rd2;
    
    comp_2s c1(.a(Rd2), .comp_a(comp_Rd2));                     // 2의 보수화 모듈
    sCLA4 s0(.A(Rd1), .B(comp_Rd2), .Cin(1'b0), .sum(sum));     // 2의 보수화 모듈과 Carry Lookahead Adder를 통한 뺄셈 구현
    
    assign result[3] = en && sum[3];
    assign result[2] = en && sum[2];
    assign result[1] = en && sum[1];
    assign result[0] = en && sum[0];                                // enable 신호 인가시, SUB operation
    assign overflow = en && ((Rd1[3]!=Rd2[3])&&(Rd1[3]!=sum[3]));   // signed 연산시, overflow

endmodule
