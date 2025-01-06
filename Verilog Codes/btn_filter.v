`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/11 17:12:29
// Design Name: 
// Module Name: btn_filter
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

module btn_filter(
    input btn,           // 입력 버튼 신호
    input clk,           // 시스템 클록 신호
    output flted_btn     // 필터링된 버튼 신호
);

    // 주파수 분발기 모듈을 통한 클록 신호 생성
    wire clk_1M, clk_10K, clk_100; // 분발된 클록 신호

    freq_div_100 c1(.clk_ref(clk), .clk_div(clk_1M));     // clk를 1MHz로 분발
    freq_div_100 c2(.clk_ref(clk_1M), .clk_div(clk_10K)); // 1MHz 클록을 10kHz로 분발
    freq_div_100 c3(.clk_ref(clk_10K), .clk_div(clk_100)); // 10kHz 클록을 100Hz로 분발

    // 버튼 신호 동기화 및 디바운스
    wire s_btn; // 동기화된 버튼 신호

    synchronizer s0(.clk(clk_100), .async_in(btn), .sync_out(s_btn)); // 비동기 버튼 신호를 동기화
    debouncer d0(.clk(clk_100), .noisy(s_btn), .debounced(flted_btn)); // 동기화된 신호를 디바운스
    
endmodule