
module eyes(
    input wire clk,          // 时钟信号
    input wire clk_90khz,     // 舵机分频时钟
    input wire clk_1khz,     // 采样时钟
    input wire nrst,         // 复位信号

    input wire left_dir,
    input wire right_dir,
    input wire up_dir,
    input wire down_dir,

    output wire pwm_x,
    output wire pwm_y
);

    wire [7:0] angle_x_raw;
    wire [7:0] angle_y_raw;

    dir2angle dir2angle_x (
        .clk(clk),
        .nrst(nrst),
        .neg_dir(left_dir),
        .pos_dir(right_dir),
        .angle(angle_x_raw)
    );

    dir2angle dir2angle_y (
        .clk(clk),
        .nrst(nrst),
        .neg_dir(down_dir),
        .pos_dir(up_dir),
        .angle(angle_y_raw)
    );

    sg90 servo_x (
        .clk(clk),
        .clk_90khz(clk_90khz),
        .clk_1khz(clk_1khz),
        .nrst(nrst),
        .angle_raw(angle_x_raw),
        .pwm(pwm_x)		
    );

    sg90 servo_y(
        .clk(clk),
        .clk_90khz(clk_90khz),
        .clk_1khz(clk_1khz),
        .nrst(nrst),
        .angle_raw(angle_y_raw),
        .pwm(pwm_y)		
    );
endmodule