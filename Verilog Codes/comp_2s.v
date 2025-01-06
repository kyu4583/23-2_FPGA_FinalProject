`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/12 19:33:15
// Design Name: 
// Module Name: comp_2s
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


module comp_2s(
    input [3:0]a,
    output [3:0]comp_a
    );
    
    assign comp_a = ~a + 4'b0001;       // 4bit 수를 2의 보수화
    
endmodule
