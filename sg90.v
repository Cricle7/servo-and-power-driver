`include "pwm16b.v"

module sg90(
    input wire clk,          // 时钟信号
    input wire clk_90khz,    // 舵机分频时钟
    input wire clk_1khz,     // 采样时钟
    input wire nrst,         // 复位信号

    input wire [7:0] angle_raw,
    output wire pwm
);

    wire [7:0] angle;
    wire [15:0] cvr = {angle + 45};
    // 45/1800 = 2.5% least
    // (180 + 45) / 1800 = 12.5% full

    lpf lpf_inst (
        .clk(clk),
        .clk_samp(clk_1khz),
        .nrst(nrst),
        .in(angle_raw),
        .out(angle)
    );


    pwm16b pwm_inst (
        .clk(clk_90khz),
        .nrst(nrst),
        .cvr(cvr),
        .arr(16'd1800),
        .pwm(pwm)
    );

endmodule