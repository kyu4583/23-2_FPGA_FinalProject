`timescale 1ns / 1ps

module MPU(
    input clk,               // 시스템 클록 신호
    input [3:0] sw,          // 스위치 입력
    input [3:0] btn,         // 버튼 입력
    output [3:0] led,        // LED 출력
    output [6:0] seg12,      // 7-세그먼트 디스플레이 출력 1과 2
    output [6:0] seg34,      // 7-세그먼트 디스플레이 출력 3과 4
    output [1:0] seg_en      // 7-세그먼트 디스플레이 활성화 신호
);

    // 클록 신호 및 분발된 클록 정의
    wire clk_125M = clk;      // 기본 클록
    wire clk_100M, clk_1M;    // 분발된 클록 신호

    // 7-세그먼트 디스플레이를 위한 내부 연결
    wire [6:0] seg1_w, seg2_w, seg3_w, seg4_w; // 각 세그먼트의 와이어

    // 버튼 필터링을 위한 와이어
    wire [3:0] flted_btn;     // 필터링된 버튼 신호

    // MPU의 내부 로직 및 제어 신호
    wire [15:0] instruction;  // 명령어 레지스터
    wire ALU_OP_Write, ALU_OP_Read, ALU_OP_Copy,
        ALU_OP_not, ALU_OP_and, ALU_OP_or,
        ALU_OP_xor, ALU_OP_nand, ALU_OP_nor,
        ALU_OP_add, ALU_OP_sub, ALU_OP_LSF, ALU_OP_RSF; // ALU 작업 신호
    wire ALU_Src;             // ALU 소스 선택 신호
    wire CTRL_regwrite;       // CTRL모듈 레지스터 쓰기 신호
    wire IO_regwrite;         // IO모듈 레지스터 쓰기 신호
    wire Reg_Write;           // 레지스터 파일 쓰기 신호
    wire [3:0] ALU_Result;    // ALU 결과
    wire [3:0] Reg_Read_1, Reg_Read_2; // 레지스터 파일 읽기 데이터
    wire [3:0] Mux_Out;       // 멀티플렉서 출력
    wire overflow;            // 오버플로우 신호

    // 레지스터 쓰기 신호 결합
    assign Reg_Write = CTRL_regwrite && IO_regwrite;

    // 클록 분발
    clk_100M c0(.clk_125M(clk_125M), .reset(btn[2]), .clk_100M(clk_100M));
    freq_div_100 c1(.clk_ref(clk_100M), .rst(btn[2]), .clk_div(clk_1M));
    
    // btn[0]에 대한 버튼 필터링
    btn_filter f0(.clk(clk_100M), .btn(btn[0]), .flted_btn(flted_btn[0]));
    
    assign flted_btn[3:1] = btn[3:1]; // 나머지 버튼은 필터링 없이 직접 연결

    // MPU의 주요 컴포넌트 인스턴스화
    // IO, 제어 유닛(CTRL), 레지스터 파일(Reg4x16), 멀티플렉서(Mux_4x2), ALU
    IO u0(.overflow(overflow), .reg_write(IO_regwrite), .clk(clk_100M), .instruction(instruction), .sw(sw), .result(ALU_Result), .btn(flted_btn), .led(led), .seg1(seg1_w), .seg2(seg2_w), .seg3(seg3_w), .seg4(seg4_w)); 
    CTRL u1(.inst(instruction[15:12]), .ALU_OP_not(ALU_OP_not), .ALU_OP_and(ALU_OP_and), .ALU_OP_or(ALU_OP_or), 
                                        .ALU_OP_xor(ALU_OP_xor), .ALU_OP_nand(ALU_OP_nand), .ALU_OP_nor(ALU_OP_nor), .ALU_OP_add(ALU_OP_add), 
                                        .ALU_OP_sub(ALU_OP_sub), .ALU_OP_LSF(ALU_OP_LSF), .ALU_OP_RSF(ALU_OP_RSF), .ALU_Src(ALU_Src), .Reg_Write(CTRL_regwrite),
                                        .ALU_OP_Write(ALU_OP_Write), .ALU_OP_Read(ALU_OP_Read), .ALU_OP_Copy(ALU_OP_Copy));
    Reg4x16 u2(.clk(clk_100M), .instruction(instruction[11:0]), .reg_write(Reg_Write), .data_write(ALU_Result), .data_read_1(Reg_Read_1), .data_read_2(Reg_Read_2));
    Mux_4x2 u3(.select(ALU_Src), .src1(Reg_Read_2), .src2(instruction[7:4]), .data_out(Mux_Out));
    ALUU u4(.overflow(overflow), .Rd1(Reg_Read_1), .Rd2(Mux_Out), .result(ALU_Result), .wr_en(ALU_OP_Write), .read_en(ALU_OP_Read), .copy_en(ALU_OP_Copy), .not_en(ALU_OP_not), .and_en(ALU_OP_and), .or_en(ALU_OP_or), .xor_en(ALU_OP_xor), .nand_en(ALU_OP_nand), .nor_en(ALU_OP_nor), .add_en(ALU_OP_add), .sub_en(ALU_OP_sub), .LSF_en(ALU_OP_LSF), .RSF_en(ALU_OP_RSF));
    
    // 7-세그먼트 디스플레이 활성화 및 출력 제어
    assign  seg_en = clk_1M ? 2'b00 : 2'b11; // 클록에 따라 디스플레이 활성화
    assign  seg12 = clk_1M ? seg2_w : seg1_w; // 클록에 따라 1, 2번 세그먼트 출력 조절
    assign  seg34 = clk_1M ? seg4_w : seg3_w; // 클록에 따라 3, 4번 세그먼트 출력 조절
    
endmodule