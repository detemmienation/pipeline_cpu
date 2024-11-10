`include "ctrl_encode_def.v"
module Hazard(
    input [4:0] IF_rs1,//IF/ID流水线寄存器中的rs1
    input [4:0] IF_rs2,//IF/ID流水线寄存器中的rs2
    input [4:0] ID_rd,//ID/EX流水线寄存器中的rd
    input [1:0] ID_WDSel,//ID/EX流水线寄存器中的WDSel信号
    output reg PCWrite,//输出控制PC写的信号
    output reg IFIDWrite,//输出控制IF/ID流水线寄存器写的信号
    output reg Ctrlflush//输出控制是否清空所有控制信号的信号
);
    initial begin
        PCWrite = 1;
        IFIDWrite = 1;
        Ctrlflush = 0;
    end
    always @(*) begin
          //load冒险,阻塞
        if((ID_WDSel==`WDSel_FromMEM) && (IF_rs1==ID_rd||IF_rs2==ID_rd)) begin
            PCWrite = 0;
            IFIDWrite = 0;  
            Ctrlflush = 1;
        end
           //正常情况
        else begin
            PCWrite = 1;
            IFIDWrite = 1;
            Ctrlflush = 0;
        end
    end
endmodule