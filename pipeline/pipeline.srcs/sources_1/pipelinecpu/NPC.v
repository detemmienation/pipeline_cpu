`include "ctrl_encode_def.v"
module NPC(PC1, PC2, NPCOp, Zero, IMM, NPC ,aluout, Flush);  // next pc module
  //NPC ��Ŀ���ǽ� sb ����ת��jal ����ת��jalr ����ת�Լ�����ת��������ϣ�ͨ�������źŸ���PC��
  //����˿���ð�գ����һ�� Flush �źţ����Խ��п���ð�ռ��
   input Zero;
   input  [31:0] PC1, PC2;        // pc1 IF�׶ε�PC��ַ 
   //pc2 �����EX/MEM��ˮ�߼Ĵ�����ĵ�ǰָ��ִ��ʱ��P
   input  [2:0]  NPCOp;     // next pc operation
   input  [31:0] IMM;       // immediate
	input [31:0] aluout;  //jalr��תҪ�õ���aluout
   output reg [31:0] NPC;   // next pc
   output reg Flush; //����Ŀ����Ƿ������ˮ�߼Ĵ������ź� 
   //IF ID EX
   wire [31:0] PCPLUS4;
   
   assign PCPLUS4 = PC1 + 4; // pc + 4
   //���п���ð�ս��
   always @(*) begin
      case (NPCOp)
          `NPC_PLUS4: begin
               NPC = PCPLUS4;// PCPLUS4 = PC1 + 4
               Flush=0;
          end
          `NPC_BRANCH: begin
              //һ��������ת����Ԥ�ⲻ�����Ŀ���ð��Ҫ�������������������ˮ�߼Ĵ���������NPC=PC2+IMM
             if(Zero) begin//ALU�ļ�����Ϊ0��zero=1����flush=1 pc�ɷ�֧Ŀ���ַȡ�� 
               NPC = PC2+IMM;
               Flush=1;
             end
             //δ������ת��������Ԥ���ִ��
             else begin
               NPC = PCPLUS4;
               Flush = 0;
             end
          end 
          `NPC_JUMP:  begin
         //jal��ǿ����ת�����������ˮ�߼Ĵ���������NPC=PC2+IMM
             NPC = PC2+IMM;
             Flush = 1;
          end
		    `NPC_JALR:	begin
            //jalr��ǿ����ת�����������ˮ�߼Ĵ���������NPC=aluout
            NPC = aluout;
            Flush = 1;
          end
      endcase
   end
   
endmodule
