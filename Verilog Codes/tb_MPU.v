`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/13 15:58:24
// Design Name: 
// Module Name: tb_MPU
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
module tb_MPU();
    reg clk;
    reg [3:0]sw;
    reg [3:0]btn;
    wire [3:0]led;
    wire [6:0]seg12;
    wire [6:0]seg34;
    wire [1:0]seg_en;
    
    MPU uut(clk, sw, btn, led, seg12, seg34, seg_en);
    
    always #4 clk = ~clk;
    
    initial begin
            clk<=0;  sw<=0;         btn<=4'b0100;
    #20                             btn[2]<=0;
    #300                             btn[0]<=1;
    #20                             btn[0]<=0;
    #20             sw<=4'h1;
    #20                             btn[0]<=1;
    #20                             btn[0]<=0;
    #20             sw<=4'h0;
    #20                             btn[0]<=1;
    #20                             btn[0]<=0;
    #20             sw<=4'hA;        
    #20                             btn[0]<=1;
    #20                             btn[0]<=0;
    #20             sw<=4'h5;        
    #20                             btn[0]<=1;
    #20                             btn[0]<=0;   //done
    #20                             btn[0]<=1;
    #20                             btn[0]<=0;   //idle
    #20                             btn[0]<=1;
    #20                             btn[0]<=0;
    #20             sw<=4'h1;
    #20                             btn[0]<=1;
    #20                             btn[0]<=0;
    #20             sw<=4'h0;
    #20                             btn[0]<=1;
    #20                             btn[0]<=0;
    #20             sw<=4'hC;        
    #20                             btn[0]<=1;
    #20                             btn[0]<=0;
    #20             sw<=4'h3;        
    #20                             btn[0]<=1;
    #20                             btn[0]<=0;   // done
    #20                             btn[0]<=1;
    #20                             btn[0]<=0;   // idle
    #20                             btn[0]<=1;
    #20                             btn[0]<=0;
    #20             sw<=4'hA;
    #20                             btn[0]<=1;
    #20                             btn[0]<=0;
    #20             sw<=4'h3;
    #20                             btn[0]<=1;
    #20                             btn[0]<=0;
    #20             sw<=4'h5;        
    #20                             btn[0]<=1;
    #20                             btn[0]<=0;
    #20             sw<=4'h8;      
    #20                             btn[0]<=1;
    #20                             btn[0]<=0;
    #20 $finish;  
    end
endmodule
