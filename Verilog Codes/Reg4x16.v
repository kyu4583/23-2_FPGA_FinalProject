`timescale 1ns / 1ps

module Reg4x16(
    input clk,                  // 시스템 클록
    input [11:0] instruction,   // 명령어 입력 (12비트)
    input reg_write,            // 레지스터 쓰기 신호
    input [3:0] data_write,     // 레지스터에 쓸 데이터
    output [3:0] data_read_1,   // 첫 번째 레지스터 읽기 데이터
    output [3:0] data_read_2    // 두 번째 레지스터 읽기 데이터
);

    // 명령어에서 읽기 및 쓰기 레지스터 번호 추출
    wire [3:0] rd1 = instruction[11:8]; // 첫 번째 읽기 레지스터
    wire [3:0] rd2 = instruction[7:4];  // 두 번째 읽기 레지스터
    wire [3:0] wr = instruction[3:0];   // 쓰기 레지스터

    // 4비트 16개 레지스터 배열 선언
    reg [3:0] regs[15:0];

    // 읽기 데이터에 레지스터 값 할당
    assign data_read_1 = regs[rd1];
    assign data_read_2 = regs[rd2];

    // 초기화: 모든 레지스터를 0으로 설정
    integer i;       
    initial begin
       for( i = 0; i < 16; i = i + 1 ) begin
            regs[i] <= 4'b0000;
       end
    end

    // 클록의 상승 에지에서 레지스터 쓰기 동작 수행
    always@(posedge clk) begin
        if (reg_write) begin
            regs[wr] = data_write;   // 쓰기 신호가 활성화되면 데이터 쓰기
           regs[0] <= 4'b0000;       // 0번 레지스터는 항상 0을 유지
        end
    end
    
endmodule