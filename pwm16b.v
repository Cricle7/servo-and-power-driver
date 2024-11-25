module pwm16b (
    input wire clk,          // 时钟信号
    input wire nrst,         // 复位信号
    input wire [15:0] cvr,   // 计数器值
    input wire [15:0] arr,   // 比较值
    output reg pwm           // PWM信号输出

);
	
	reg [15:0] cnt;

    always @(posedge clk or negedge nrst) begin
        if (!nrst) begin
            cnt <= 1'b0;
            pwm <= 1'b0;
        end 
        else if(cnt >= arr) begin
			cnt <= 1'b0;
			pwm <= 1'b1;
			end 
	    else if (cnt == cvr)begin
			pwm <= 1'b0;
			cnt <= cnt + 1'b1;
			end
	    else	
			cnt <= cnt + 1'b1;
    end

endmodule