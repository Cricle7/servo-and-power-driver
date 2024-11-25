module lpf(
    input wire clk,          // 时钟信号
    input wire clk_samp,     // 采样时钟
    input wire nrst,         // 复位信号

    input   [15:0] in,
    output  reg [15:0] out
);

    always @(posedge clk or negedge nrst) begin
        if (!nrst) begin
            out <= 0;  // 复位时将 out 清零
        end else if (clk_samp) begin
            out <= (out + (out << 1) + in) >> 2;  // 采样时更新 out
            // 移位加法，相当于 out = (out * 3 + in) / 4
        end
    end

endmodule