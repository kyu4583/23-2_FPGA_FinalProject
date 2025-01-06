`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/07 16:20:25
// Design Name: 
// Module Name: debouncer
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


module debouncer #(parameter N = 3, parameter K = 32)(
    input clk,
    input noisy,
    output debounced
);

reg [K-1:0] cnt;

always @(posedge clk)
begin
    if(noisy) cnt <= cnt + 1'b1;
    else cnt <= 0;
end

assign debounced = (cnt == N) ? 1'b1 : 1'b0;

endmodule