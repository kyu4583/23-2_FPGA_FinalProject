module edge_detector(
    input clk,
    input [3:0] btn,
    output reg [3:0] edged
);
    integer i;

    reg [3:0] cnt; // 각 버튼에 대한 상태를 저장하는 레지스터 변수
    
    always @(posedge clk)
    begin
        edged = 4'b0000; // 버튼 떼어짐 상태로 초기화
        
        // 각 버튼에 대한 동작
        for ( i = 0; i < 4; i = i + 1) begin
            if (btn[i]) begin
                if (cnt[i] == 0) begin
                    edged[i] <= 1;
                    cnt[i] <= 1;
                end else if (cnt[i] == 1) begin
                    edged[i] <= 0;
                end
            end else begin
                cnt[i] <= 0;
            end
        end
    end

endmodule