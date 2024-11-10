`include "ctrl_encode_def.v"
module Hazard(
    input [4:0] IF_rs1,//IF/ID��ˮ�߼Ĵ����е�rs1
    input [4:0] IF_rs2,//IF/ID��ˮ�߼Ĵ����е�rs2
    input [4:0] ID_rd,//ID/EX��ˮ�߼Ĵ����е�rd
    input [1:0] ID_WDSel,//ID/EX��ˮ�߼Ĵ����е�WDSel�ź�
    output reg PCWrite,//�������PCд���ź�
    output reg IFIDWrite,//�������IF/ID��ˮ�߼Ĵ���д���ź�
    output reg Ctrlflush//��������Ƿ�������п����źŵ��ź�
);
    initial begin
        PCWrite = 1;
        IFIDWrite = 1;
        Ctrlflush = 0;
    end
    always @(*) begin
          //loadð��,����
        if((ID_WDSel==`WDSel_FromMEM) && (IF_rs1==ID_rd||IF_rs2==ID_rd)) begin
            PCWrite = 0;
            IFIDWrite = 0;  
            Ctrlflush = 1;
        end
           //�������
        else begin
            PCWrite = 1;
            IFIDWrite = 1;
            Ctrlflush = 0;
        end
    end
endmodule