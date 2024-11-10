`timescale 1ns / 1ps
module clk_div( input clk,
                input rst,
                input SW2,              //CPUʱ���л�
                output reg[31:0]clkdiv, //32λ������Ƶ���
                output Clk_CPU          //CPUʱ�����
					);
					
// Clock divider-ʱ�ӷ�Ƶ��
	always @ (posedge clk or posedge rst) begin 
		if (rst) clkdiv <= 0; else clkdiv <= clkdiv + 1'b1; end
		
	assign Clk_CPU=(SW2)? clkdiv[25] : clkdiv[1];
		
endmodule
