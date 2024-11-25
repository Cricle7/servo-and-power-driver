`define GRAY_WIDTH 8
`define OUTPUT_WIDTH 8

module light_ctrl(
    input wire clk,          // 时钟信号
    input wire clk_1khz,     // 控制周期时钟
    input wire nrst,         // 复位信号

    input wire [`GRAY_WIDTH-1:0] current,   // 计数器值
    input wire [`GRAY_WIDTH-1:0] target,    // 比较值
    output wire pwm
);

    reg [`OUTPUT_WIDTH-1:0] cvr;

    pwm16b pwm_inst (
        .clk(clk),
        .nrst(nrst),
        .cvr({8'b0, cvr}),
        .arr(16'd255),
        .pwm(pwm)
    );

    // 定义状态
    parameter IDLE = 8'b00,
              RUNNING = 8'b01;

    // 定义最大和最小输出值
    parameter MAX_CVR = `OUTPUT_WIDTH'hFE,
              MIN_CVR = `OUTPUT_WIDTH'h01;

    reg [7:0] state, next_state;
    // 内部寄存器
    reg signed [7:0] diff;  // 8位有符号计数器

    // 状态寄存器和状态转移逻辑
    always @(posedge clk or negedge nrst) begin
        if (nrst == 0) begin
            state <= IDLE;
            next_state <= IDLE;
        end else begin
            state <= next_state;
            case (state)
                IDLE: begin
                    next_state = RUNNING;
                end
                RUNNING: begin
                    next_state = RUNNING;
                end
            endcase
        end
    end

    // 输出逻辑
    always @(posedge clk_1khz or negedge nrst) begin
        if (nrst == 0) begin
            cvr <=8'b00;
        end else begin
            case (state)
                IDLE: begin
                    cvr <= MIN_CVR;  // 可选：在IDLE状态下初始化cvr
                end
                RUNNING: begin
                    diff <= target - current;
                    if (diff > 0 && cvr < MAX_CVR) begin
                        cvr <= cvr + 1'b1;
                    end else if (diff < 0 && cvr > MIN_CVR) begin
                        cvr <= cvr - 1'b1;
                    end
                end
            endcase
        end
    end
endmodule