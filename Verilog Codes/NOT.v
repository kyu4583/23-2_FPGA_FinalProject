`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/07 14:30:19
// Design Name: 
// Module Name: NOT
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


module NOT(
    input en,
    input [3:0]Rd1,
    input [3:0]Rd2,
    output [3:0]result
    );
    
    assign result = en * (~Rd1);        // enable �ΰ���, NOT operation

endmodule
