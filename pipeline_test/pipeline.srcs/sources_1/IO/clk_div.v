`timescale 1ns / 1ps
module clk_div( input clk,
                input rst,
                input SW2,              //CPU时钟切换
                output reg[31:0]clkdiv, //32位计数分频输出
                output Clk_CPU          //CPU时钟输出
					);
					
// Clock divider-时钟分频器
	always @ (posedge clk or posedge rst) begin 
		if (rst) clkdiv <= 0; else clkdiv <= clkdiv + 1'b1; end
		
	assign Clk_CPU=(SW2)? clkdiv[25] : clkdiv[1];
		
endmodule
