module dir2angle(
    input wire clk,          // 时钟信号
    input wire nrst,         // 复位信号

    input wire neg_dir,
    input wire pos_dir,
    output reg [7:0] angle
);

// 定义状态
parameter POS_ANGLE = 8'd110,
            NEG_ANGLE = 8'd70,
            CENTER_ANGLE = 8'd90;

always @(posedge clk or negedge nrst) begin
    if (!nrst) begin
        angle <= CENTER_ANGLE;
    end else begin
        if (pos_dir) begin
            angle <= POS_ANGLE;
        end else if (neg_dir) begin
            angle <= NEG_ANGLE;
        end else begin
			angle <= CENTER_ANGLE;
		end
    end
end

endmodule