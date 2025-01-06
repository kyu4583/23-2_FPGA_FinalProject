`timescale 1ns / 1ps

module Mux_4x2(
    input select,            // ���� ��ȣ (1��Ʈ)
    input [3:0] src1,        // ù ��° �ҽ� �Է� (4��Ʈ)
    input [3:0] src2,        // �� ��° �ҽ� �Է� (4��Ʈ)
    output wire [3:0] data_out // ��� ������ (4��Ʈ)
);

    // ������ ��� ����: select ��ȣ�� 1�̸� src2��, 0�̸� src1�� ���
    assign data_out = (select) ? src2 : src1;
        
endmodule