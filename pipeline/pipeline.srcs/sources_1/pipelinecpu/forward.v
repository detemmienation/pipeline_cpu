module forward(
    //前递单元
    input [4:0] ID_rs1,//ID/EX流水线寄存器中的rs1
    input [4:0] ID_rs2,//ID/EX流水线寄存器中的rs2
    input EX_RegWrite,//EX/MEM流水线寄存器中的RegWrite信号
    input [4:0] EX_rd,//EX/MEM流水线寄存器中的rd
    input MEM_RegWrite,//MEM/WB流水线寄存器中的RegWrite信号
    input [4:0] MEM_rd,//MEM/WB流水线寄存器中的rd
    output reg [1:0] F1,//输出的第一个前递控制信号
    output reg [1:0] F2//输出的第二个前递控制信号
);
always @(*) begin
        //ForwardA
        if(EX_RegWrite && EX_rd != 0 && ID_rs1==EX_rd) F1<=2'b01;//EX/MEM阶段
        else if(MEM_RegWrite && MEM_rd != 0 && ID_rs1==MEM_rd) F1<=2'b10;//MEM/WB阶段
        else F1<=2'b00;
        //ForwardB
        if(EX_RegWrite && EX_rd != 0 && ID_rs2==EX_rd) F2<=2'b01;//EX/MEM阶段
        else if(MEM_RegWrite && MEM_rd != 0 && ID_rs2==MEM_rd) F2<=2'b10;//MEM/WB阶段
        else F2<=2'b00;
    end
endmodule