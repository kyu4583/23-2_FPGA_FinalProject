`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/08 17:56:21
// Design Name: 
// Module Name: CTRL
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


module CTRL(
    input [3:0]inst,                                                                                    // instruction[15:12]
    output  ALU_OP_Write, ALU_OP_Read, ALU_OP_Copy, ALU_OP_not, ALU_OP_and, ALU_OP_or,  
            ALU_OP_xor, ALU_OP_nand, ALU_OP_nor, ALU_OP_add, ALU_OP_sub, ALU_OP_LSF, ALU_OP_RSF,        // ALU가 동작할 때에 따른 동작 신호들 
    output  ALU_Src,                                                                                   // ALU 동작에 따른 MUX select 신호
    output  Reg_Write                                                                                  // 결과를 레지스터에 write 여부
    );  
    
     assign ALU_OP_Write = (inst == 4'd1) ? 1'b1 : 1'b0;
     assign ALU_OP_Read = (inst == 4'd2) ? 1'b1 : 1'b0;
     assign ALU_OP_Copy = (inst == 4'd3) ? 1'b1 : 1'b0;   
     assign ALU_OP_not = (inst == 4'd4) ? 1'b1 : 1'b0;
     assign ALU_OP_and = (inst == 4'd5) ? 1'b1 : 1'b0;
     assign ALU_OP_or = (inst == 4'd6) ? 1'b1 : 1'b0;
     assign ALU_OP_xor = (inst == 4'd7) ? 1'b1 : 1'b0;
     assign ALU_OP_nand = (inst == 4'd8) ? 1'b1 : 1'b0;
     assign ALU_OP_nor = (inst == 4'd9) ? 1'b1 : 1'b0;
     assign ALU_OP_add = (inst == 4'd10 || inst == 4'd12) ? 1'b1 : 1'b0;
     assign ALU_OP_sub = (inst == 4'd11 || inst == 4'd13) ? 1'b1 : 1'b0;
     assign ALU_OP_LSF = (inst == 4'd14) ? 1'b1 : 1'b0;
     assign ALU_OP_RSF = (inst == 4'd15) ? 1'b1 : 1'b0;                                             // instructuin[15:12] 디코딩 후 ALU 동작 신호 인가
                                  
     assign ALU_Src = ( inst >= 4'd5 && inst <= 4'd11 ) ? 1'b0 : 1'b1;                              // and or xor nand nor add sub 동작에서는 reg[Rd2] 사용, 이외에서는 Rd2 data 사용
     assign Reg_Write = (inst == 4'd0 || inst == 4'd2) ? 1'b0 : 1'b1;                               // nop과 read를 제외한 모든 동작에서 write
    

endmodule