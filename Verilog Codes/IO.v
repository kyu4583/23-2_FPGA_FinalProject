`timescale 1ns / 1ps

module IO(
    // 시스템 클럭과 사용자 인터페이스 입력
    input clk,                // 시스템 클럭
    input [3:0] sw,           // 4개의 스위치 입력
    input [3:0] btn,          // 4개의 버튼 입력
    input [3:0] result,       // 연산 결과 입력
    input overflow,           // 오버플로우 플래그 입력
    output reg[3:0] led,      // 4개의 LED 출력
    output wire[6:0] seg1,    // 7-세그먼트 디스플레이 출력 1
    output wire[6:0] seg2,    // 7-세그먼트 디스플레이 출력 2
    output wire[6:0] seg3,    // 7-세그먼트 디스플레이 출력 3
    output wire[6:0] seg4,    // 7-세그먼트 디스플레이 출력 4
    output reg[15:0] instruction, // 명령어 저장 레지스터

    output reg_write          // 레지스터 쓰기 신호
);

    // 상태 정의
    parameter [2:0] IDLE = 3'b000,
                    INS_1 = 3'b001,
                    INS_2 = 3'b010,
                    INS_3 = 3'b011,
                    INS_4 = 3'b100,
                    DONE = 3'b101;

    // 상태 및 내부 변수
    reg [2:0] state, next_state; // 현재 상태와 다음 상태
    reg last_button_state;       // 마지막 버튼 상태 저장

    // 레지스터 쓰기 신호는 DONE 상태에서만 활성화
    assign reg_write = (state == DONE) ? 1'b1 : 1'b0;

    // 7-세그먼트 디스플레이 출력을 위한 변수
    reg [3:0] ssd_hex1;
    reg [3:0] ssd_hex2;
    reg [3:0] ssd_hex3;
    reg [3:0] ssd_hex4;   

    // 7-세그먼트 디스플레이 모듈 인스턴스화
    SSD u0(.hex(ssd_hex1), .seg(seg1));
    SSD u1(.hex(ssd_hex2), .seg(seg2));
    SSD u2(.hex(ssd_hex3), .seg(seg3));
    SSD u3(.hex(ssd_hex4), .seg(seg4));

    // 초기 상태 설정
    initial begin
        state <= IDLE;
        last_button_state <= 0;
    end

    // 메인 상태 머신
    always @(posedge clk) begin
        case(state)
            // IDLE 상태: 모든 출력과 명령어를 초기화
            IDLE:  begin
                led <= 4'b0000;
                ssd_hex1 <= 4'b0000;
                ssd_hex2 <= 4'b0000;
                ssd_hex3 <= 4'b0000;
                ssd_hex4 <= 4'b0000;
                instruction <= 16'b0;
                next_state <= INS_1;
            end
            // INS_1 ~ INS_4: 사용자로부터 명령어 입력 받음
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
            // DONE 상태: 연산 결과 표시 및 오버플로우 체크
            DONE:   begin
                if(overflow) led <= 4'b1010;
                else led <= 4'b1111;
                // 버튼 1을 누르면 명령어 표시
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

    // 버튼 제어 로직
    always @(posedge clk) begin
        if(btn[3]) state <= IDLE; // 리셋 버튼
        else if (btn[0]) last_button_state <= 1; // 버튼 상태 갱신
        else if (last_button_state && !btn[0]) begin
            // 버튼의 falling edge에서 상태 전환
            state <= next_state;
            last_button_state <= 0;
        end
    end
endmodule