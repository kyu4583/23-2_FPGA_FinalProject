`timescale 1ns / 1ps

module IO(
    // �ý��� Ŭ���� ����� �������̽� �Է�
    input clk,                // �ý��� Ŭ��
    input [3:0] sw,           // 4���� ����ġ �Է�
    input [3:0] btn,          // 4���� ��ư �Է�
    input [3:0] result,       // ���� ��� �Է�
    input overflow,           // �����÷ο� �÷��� �Է�
    output reg[3:0] led,      // 4���� LED ���
    output wire[6:0] seg1,    // 7-���׸�Ʈ ���÷��� ��� 1
    output wire[6:0] seg2,    // 7-���׸�Ʈ ���÷��� ��� 2
    output wire[6:0] seg3,    // 7-���׸�Ʈ ���÷��� ��� 3
    output wire[6:0] seg4,    // 7-���׸�Ʈ ���÷��� ��� 4
    output reg[15:0] instruction, // ��ɾ� ���� ��������

    output reg_write          // �������� ���� ��ȣ
);

    // ���� ����
    parameter [2:0] IDLE = 3'b000,
                    INS_1 = 3'b001,
                    INS_2 = 3'b010,
                    INS_3 = 3'b011,
                    INS_4 = 3'b100,
                    DONE = 3'b101;

    // ���� �� ���� ����
    reg [2:0] state, next_state; // ���� ���¿� ���� ����
    reg last_button_state;       // ������ ��ư ���� ����

    // �������� ���� ��ȣ�� DONE ���¿����� Ȱ��ȭ
    assign reg_write = (state == DONE) ? 1'b1 : 1'b0;

    // 7-���׸�Ʈ ���÷��� ����� ���� ����
    reg [3:0] ssd_hex1;
    reg [3:0] ssd_hex2;
    reg [3:0] ssd_hex3;
    reg [3:0] ssd_hex4;   

    // 7-���׸�Ʈ ���÷��� ��� �ν��Ͻ�ȭ
    SSD u0(.hex(ssd_hex1), .seg(seg1));
    SSD u1(.hex(ssd_hex2), .seg(seg2));
    SSD u2(.hex(ssd_hex3), .seg(seg3));
    SSD u3(.hex(ssd_hex4), .seg(seg4));

    // �ʱ� ���� ����
    initial begin
        state <= IDLE;
        last_button_state <= 0;
    end

    // ���� ���� �ӽ�
    always @(posedge clk) begin
        case(state)
            // IDLE ����: ��� ��°� ��ɾ �ʱ�ȭ
            IDLE:  begin
                led <= 4'b0000;
                ssd_hex1 <= 4'b0000;
                ssd_hex2 <= 4'b0000;
                ssd_hex3 <= 4'b0000;
                ssd_hex4 <= 4'b0000;
                instruction <= 16'b0;
                next_state <= INS_1;
            end
            // INS_1 ~ INS_4: ����ڷκ��� ��ɾ� �Է� ����
            INS_1:  begin
                led <= 4'b1000;
                instruction[15:12] <= sw;
                ssd_hex1 <= sw;
                next_state <= INS_2;
            end
            INS_2:  begin
                led <= 4'b0100;
                instruction[11:8] <= sw;
                ssd_hex2 <= sw;
                next_state <= INS_3;
            end
            INS_3:  begin
                led <= 4'b0010;
                instruction[7:4] <= sw;
                ssd_hex3 <= sw;
                next_state <= INS_4;
            end
            INS_4:  begin
                led <= 4'b0001;
                instruction[3:0] <= sw;
                ssd_hex4 <= sw;
                next_state <= DONE;
            end
            // DONE ����: ���� ��� ǥ�� �� �����÷ο� üũ
            DONE:   begin
                if(overflow) led <= 4'b1010;
                else led <= 4'b1111;
                // ��ư 1�� ������ ��ɾ� ǥ��
                if(!btn[1]) begin
                    ssd_hex1 <= result[3];
                    ssd_hex2 <= result[2];
                    ssd_hex3 <= result[1];
                    ssd_hex4 <= result[0];
                end else begin
                    ssd_hex1 <= instruction[15:12];
                    ssd_hex2 <= instruction[11:8];
                    ssd_hex3 <= instruction[7:4];
                    ssd_hex4 <= instruction[3:0];
                end
                next_state <= IDLE;
            end
        endcase
    end

    // ��ư ���� ����
    always @(posedge clk) begin
        if(btn[3]) state <= IDLE; // ���� ��ư
        else if (btn[0]) last_button_state <= 1; // ��ư ���� ����
        else if (last_button_state && !btn[0]) begin
            // ��ư�� falling edge���� ���� ��ȯ
            state <= next_state;
            last_button_state <= 0;
        end
    end
endmodule