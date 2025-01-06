`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/07 13:52:18
// Design Name: 
// Module Name: LSF
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


module LSF(
    input en,
    input [3:0]Rd1,
    input [3:0]Rd2,
    output [3:0]result
    );
    
    assign result = en * (Rd1 << Rd2);          // enable 신호 인가시, Rd1을 Rd2만큼 shift left

endmodule
