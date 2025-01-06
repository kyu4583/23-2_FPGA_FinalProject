`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/07 10:23:34
// Design Name: 
// Module Name: add
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

module add(
    input en,
    input [3:0]Rd1,
    input [3:0]Rd2,
    output [3:0]result,
    output overflow
    );
    
    wire [3:0]sum;
    wire overflow_w;
    
    sCLA4 s0(.A(Rd1), .B(Rd2), .Cin(1'b0), .sum(sum));                  // Carry Lookahead Adder를 통한 덧셈 구현
    
    assign result[3] = en && sum[3];
    assign result[2] = en && sum[2];
    assign result[1] = en && sum[1];
    assign result[0] = en && sum[0];                                // enable 신호 인가시, ADD operation 출력 생성
    assign overflow = en && ((Rd1[3]==Rd2[3])&&(Rd1[3]!=sum[3]));   // signed 연산시, overflow
endmodule
