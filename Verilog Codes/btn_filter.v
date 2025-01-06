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
    input btn,           // �Է� ��ư ��ȣ
    input clk,           // �ý��� Ŭ�� ��ȣ
    output flted_btn     // ���͸��� ��ư ��ȣ
);

    // ���ļ� �й߱� ����� ���� Ŭ�� ��ȣ ����
    wire clk_1M, clk_10K, clk_100; // �йߵ� Ŭ�� ��ȣ

    freq_div_100 c1(.clk_ref(clk), .clk_div(clk_1M));     // clk�� 1MHz�� �й�
    freq_div_100 c2(.clk_ref(clk_1M), .clk_div(clk_10K)); // 1MHz Ŭ���� 10kHz�� �й�
    freq_div_100 c3(.clk_ref(clk_10K), .clk_div(clk_100)); // 10kHz Ŭ���� 100Hz�� �й�

    // ��ư ��ȣ ����ȭ �� ��ٿ
    wire s_btn; // ����ȭ�� ��ư ��ȣ

    synchronizer s0(.clk(clk_100), .async_in(btn), .sync_out(s_btn)); // �񵿱� ��ư ��ȣ�� ����ȭ
    debouncer d0(.clk(clk_100), .noisy(s_btn), .debounced(flted_btn)); // ����ȭ�� ��ȣ�� ��ٿ
    
endmodule