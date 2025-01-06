`timescale 1ns / 1ps

module Mux_4x2(
    input select,            // 선택 신호 (1비트)
    input [3:0] src1,        // 첫 번째 소스 입력 (4비트)
    input [3:0] src2,        // 두 번째 소스 입력 (4비트)
    output wire [3:0] data_out // 출력 데이터 (4비트)
);

    // 데이터 출력 결정: select 신호가 1이면 src2를, 0이면 src1을 출력
    assign data_out = (select) ? src2 : src1;
        
endmodule