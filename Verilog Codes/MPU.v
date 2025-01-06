`timescale 1ns / 1ps

module MPU(
    input clk,               // �ý��� Ŭ�� ��ȣ
    input [3:0] sw,          // ����ġ �Է�
    input [3:0] btn,         // ��ư �Է�
    output [3:0] led,        // LED ���
    output [6:0] seg12,      // 7-���׸�Ʈ ���÷��� ��� 1�� 2
    output [6:0] seg34,      // 7-���׸�Ʈ ���÷��� ��� 3�� 4
    output [1:0] seg_en      // 7-���׸�Ʈ ���÷��� Ȱ��ȭ ��ȣ
);

    // Ŭ�� ��ȣ �� �йߵ� Ŭ�� ����
    wire clk_125M = clk;      // �⺻ Ŭ��
    wire clk_100M, clk_1M;    // �йߵ� Ŭ�� ��ȣ

    // 7-���׸�Ʈ ���÷��̸� ���� ���� ����
    wire [6:0] seg1_w, seg2_w, seg3_w, seg4_w; // �� ���׸�Ʈ�� ���̾�

    // ��ư ���͸��� ���� ���̾�
    wire [3:0] flted_btn;     // ���͸��� ��ư ��ȣ

    // MPU�� ���� ���� �� ���� ��ȣ
    wire [15:0] instruction;  // ��ɾ� ��������
    wire ALU_OP_Write, ALU_OP_Read, ALU_OP_Copy,
        ALU_OP_not, ALU_OP_and, ALU_OP_or,
        ALU_OP_xor, ALU_OP_nand, ALU_OP_nor,
        ALU_OP_add, ALU_OP_sub, ALU_OP_LSF, ALU_OP_RSF; // ALU �۾� ��ȣ
    wire ALU_Src;             // ALU �ҽ� ���� ��ȣ
    wire CTRL_regwrite;       // CTRL��� �������� ���� ��ȣ
    wire IO_regwrite;         // IO��� �������� ���� ��ȣ
    wire Reg_Write;           // �������� ���� ���� ��ȣ
    wire [3:0] ALU_Result;    // ALU ���
    wire [3:0] Reg_Read_1, Reg_Read_2; // �������� ���� �б� ������
    wire [3:0] Mux_Out;       // ��Ƽ�÷��� ���
    wire overflow;            // �����÷ο� ��ȣ

    // �������� ���� ��ȣ ����
    assign Reg_Write = CTRL_regwrite && IO_regwrite;

    // Ŭ�� �й�
    clk_100M c0(.clk_125M(clk_125M), .reset(btn[2]), .clk_100M(clk_100M));
    freq_div_100 c1(.clk_ref(clk_100M), .rst(btn[2]), .clk_div(clk_1M));
    
    // btn[0]�� ���� ��ư ���͸�
    btn_filter f0(.clk(clk_100M), .btn(btn[0]), .flted_btn(flted_btn[0]));
    
    assign flted_btn[3:1] = btn[3:1]; // ������ ��ư�� ���͸� ���� ���� ����

    // MPU�� �ֿ� ������Ʈ �ν��Ͻ�ȭ
    // IO, ���� ����(CTRL), �������� ����(Reg4x16), ��Ƽ�÷���(Mux_4x2), ALU
    IO u0(.overflow(overflow), .reg_write(IO_regwrite), .clk(clk_100M), .instruction(instruction), .sw(sw), .result(ALU_Result), .btn(flted_btn), .led(led), .seg1(seg1_w), .seg2(seg2_w), .seg3(seg3_w), .seg4(seg4_w)); 
    CTRL u1(.inst(instruction[15:12]), .ALU_OP_not(ALU_OP_not), .ALU_OP_and(ALU_OP_and), .ALU_OP_or(ALU_OP_or), 
                                        .ALU_OP_xor(ALU_OP_xor), .ALU_OP_nand(ALU_OP_nand), .ALU_OP_nor(ALU_OP_nor), .ALU_OP_add(ALU_OP_add), 
                                        .ALU_OP_sub(ALU_OP_sub), .ALU_OP_LSF(ALU_OP_LSF), .ALU_OP_RSF(ALU_OP_RSF), .ALU_Src(ALU_Src), .Reg_Write(CTRL_regwrite),
                                        .ALU_OP_Write(ALU_OP_Write), .ALU_OP_Read(ALU_OP_Read), .ALU_OP_Copy(ALU_OP_Copy));
    Reg4x16 u2(.clk(clk_100M), .instruction(instruction[11:0]), .reg_write(Reg_Write), .data_write(ALU_Result), .data_read_1(Reg_Read_1), .data_read_2(Reg_Read_2));
    Mux_4x2 u3(.select(ALU_Src), .src1(Reg_Read_2), .src2(instruction[7:4]), .data_out(Mux_Out));
    ALUU u4(.overflow(overflow), .Rd1(Reg_Read_1), .Rd2(Mux_Out), .result(ALU_Result), .wr_en(ALU_OP_Write), .read_en(ALU_OP_Read), .copy_en(ALU_OP_Copy), .not_en(ALU_OP_not), .and_en(ALU_OP_and), .or_en(ALU_OP_or), .xor_en(ALU_OP_xor), .nand_en(ALU_OP_nand), .nor_en(ALU_OP_nor), .add_en(ALU_OP_add), .sub_en(ALU_OP_sub), .LSF_en(ALU_OP_LSF), .RSF_en(ALU_OP_RSF));
    
    // 7-���׸�Ʈ ���÷��� Ȱ��ȭ �� ��� ����
    assign  seg_en = clk_1M ? 2'b00 : 2'b11; // Ŭ�Ͽ� ���� ���÷��� Ȱ��ȭ
    assign  seg12 = clk_1M ? seg2_w : seg1_w; // Ŭ�Ͽ� ���� 1, 2�� ���׸�Ʈ ��� ����
    assign  seg34 = clk_1M ? seg4_w : seg3_w; // Ŭ�Ͽ� ���� 3, 4�� ���׸�Ʈ ��� ����
    
endmodule