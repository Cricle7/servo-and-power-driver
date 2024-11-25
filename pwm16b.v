`define WIDTH 16

module pwm16b (
    input wire clk,          // 时钟信号
    input wire nrst,         // 复位信号
    input wire [`WIDTH-1:0] cvr,   // 计数器值
    input wire [`WIDTH-1:0] arr,   // 比较值
    output reg pwm,           // PWM信号输出
    output reg [`WIDTH-1:0] cnt    // 计数器
);


    // 定义状态
    parameter IDLE = 8'b00,
              COUNTING = 8'b01;
  
    reg [7:0] state, next_state;

    // 状态寄存器 
    always @(posedge clk or negedge nrst) begin
        if (nrst == 0) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // 状态转移逻辑
    always @(*) begin
        case (state)
            IDLE: begin
                if (nrst == 1) begin
                    next_state = COUNTING;
                end else begin
                    next_state = IDLE; 
                end
            end
            COUNTING: begin
                next_state = COUNTING;
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end

    // 输出逻辑
    always @(posedge clk or negedge nrst) begin
        if (nrst == 0) begin
            cnt <= {`WIDTH{1'b0}};
            pwm <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    cnt <= {`WIDTH{1'b0}};
                    pwm <= 1'b0;
                end
                COUNTING: begin
                    if(cnt == arr) begin
                        cnt <= {`WIDTH{1'b0}};
                        pwm <= 1'b1;
                    end else begin
                        cnt <= cnt + 1'b1;
                        if (cnt == cvr) begin
                            pwm <= 1'b0;
                        end
                    end
                end
            endcase
        end
    end

endmodule