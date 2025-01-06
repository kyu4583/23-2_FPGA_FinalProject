`timescale 1ns / 1ps

module Reg4x16(
    input clk,                  // �ý��� Ŭ��
    input [11:0] instruction,   // ��ɾ� �Է� (12��Ʈ)
    input reg_write,            // �������� ���� ��ȣ
    input [3:0] data_write,     // �������Ϳ� �� ������
    output [3:0] data_read_1,   // ù ��° �������� �б� ������
    output [3:0] data_read_2    // �� ��° �������� �б� ������
);

    // ��ɾ�� �б� �� ���� �������� ��ȣ ����
    wire [3:0] rd1 = instruction[11:8]; // ù ��° �б� ��������
    wire [3:0] rd2 = instruction[7:4];  // �� ��° �б� ��������
    wire [3:0] wr = instruction[3:0];   // ���� ��������

    // 4��Ʈ 16�� �������� �迭 ����
    reg [3:0] regs[15:0];

    // �б� �����Ϳ� �������� �� �Ҵ�
    assign data_read_1 = regs[rd1];
    assign data_read_2 = regs[rd2];

    // �ʱ�ȭ: ��� �������͸� 0���� ����
    integer i;       
    initial begin
       for( i = 0; i < 16; i = i + 1 ) begin
            regs[i] <= 4'b0000;
       end
    end

    // Ŭ���� ��� �������� �������� ���� ���� ����
    always@(posedge clk) begin
        if (reg_write) begin
            regs[wr] = data_write;   // ���� ��ȣ�� Ȱ��ȭ�Ǹ� ������ ����
           regs[0] <= 4'b0000;       // 0�� �������ʹ� �׻� 0�� ����
        end
    end
    
endmodule