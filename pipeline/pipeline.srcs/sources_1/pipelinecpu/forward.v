module forward(
    //ǰ�ݵ�Ԫ
    input [4:0] ID_rs1,//ID/EX��ˮ�߼Ĵ����е�rs1
    input [4:0] ID_rs2,//ID/EX��ˮ�߼Ĵ����е�rs2
    input EX_RegWrite,//EX/MEM��ˮ�߼Ĵ����е�RegWrite�ź�
    input [4:0] EX_rd,//EX/MEM��ˮ�߼Ĵ����е�rd
    input MEM_RegWrite,//MEM/WB��ˮ�߼Ĵ����е�RegWrite�ź�
    input [4:0] MEM_rd,//MEM/WB��ˮ�߼Ĵ����е�rd
    output reg [1:0] F1,//����ĵ�һ��ǰ�ݿ����ź�
    output reg [1:0] F2//����ĵڶ���ǰ�ݿ����ź�
);
always @(*) begin
        //ForwardA
        if(EX_RegWrite && EX_rd != 0 && ID_rs1==EX_rd) F1<=2'b01;//EX/MEM�׶�
        else if(MEM_RegWrite && MEM_rd != 0 && ID_rs1==MEM_rd) F1<=2'b10;//MEM/WB�׶�
        else F1<=2'b00;
        //ForwardB
        if(EX_RegWrite && EX_rd != 0 && ID_rs2==EX_rd) F2<=2'b01;//EX/MEM�׶�
        else if(MEM_RegWrite && MEM_rd != 0 && ID_rs2==MEM_rd) F2<=2'b10;//MEM/WB�׶�
        else F2<=2'b00;
    end
endmodule