`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/08 17:25:39
// Design Name: 
// Module Name: ALUU
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

module ALUU(
    input wr_en, read_en, copy_en, not_en, and_en, or_en, xor_en, nand_en, nor_en, add_en, sub_en, LSF_en, RSF_en,                                                                  // 각 동작에 맞는 모듈 실행 신호
    input [3:0]Rd1,
    input [3:0]Rd2,
    output[3:0]result,
    output overflow
    );
    
    wire [3:0] read_result, wr_result, copy_result, not_result, and_result, or_result, xor_result, nand_result, nor_result, add_result, sub_result, LSF_result, RSF_result;         // 각 모듈 결과
    wire add_overflow, sub_overflow;                                                                                                                                                // 덧뺄셈 간 오버플로우
    
    Write   u10(wr_en, Rd1, Rd2, wr_result);
    Read    u11(read_en, Rd1, Rd2, read_result);
    Copy    u12(copy_en, Rd1, Rd2, copy_result);
    NOT     u0(not_en, Rd1, Rd2, not_result);
    ANDD    u1(and_en, Rd1, Rd2, and_result);
    ORR     u2(or_en, Rd1, Rd2, or_result);
    XORR    u3(xor_en, Rd1, Rd2, xor_result);
    NANDD   u4(nand_en, Rd1, Rd2, nand_result);
    NORR    u5(nor_en, Rd1, Rd2, nor_result);
    add     u6(add_en, Rd1, Rd2, add_result, add_overflow);
    sub     u7(sub_en, Rd1, Rd2, sub_result, sub_overflow);                                         
    LSF     u8(LSF_en, Rd1, Rd2, LSF_result);
    RSF     u9(RSF_en, Rd1, Rd2, RSF_result);                                                                                                                                       // 디코딩된 신호와 데이터를 넣고 결과 출력,
                                                                                                                                                                                    //  덧뺄셈의 경우 오버플로우 출력
    assign result = (wr_en) ? (wr_result) : (read_en) ? (read_result) : (copy_en) ? (copy_result) : 
                    (not_en) ? (not_result) : (and_en) ? (and_result) : (or_en) ? (or_result) : 
                    (xor_en) ? (xor_result) : (nand_en) ? (nand_result) : (nor_en) ? (nor_result) : 
                    (add_en) ? (add_result) : (sub_en) ? (sub_result) : (LSF_en) ? (LSF_result) : 
                    (RSF_en) ? (RSF_result) : 0;                                                                                                                                    // 모듈 신호가 인가되었을 경우, 
                                                                                                                                                                                    // 그 모듈의 신호를 출력으로 사용
    
    assign overflow = (add_overflow && add_en) || (sub_overflow && sub_en);                                                                                                         // 덧뺄셈 간의 오버플로우 신호 구분
    
endmodule