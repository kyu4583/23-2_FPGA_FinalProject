`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/11 18:46:28
// Design Name: 
// Module Name: Write
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


module Write(
    input en,
    input [3:0]Rd1,
    input [3:0]Rd2,
    output [3:0]result
    );
    
    assign result = (en) * (Rd2);       // write�� ���, enable ��ȣ �ΰ���, Rd2 data write
    
endmodule
