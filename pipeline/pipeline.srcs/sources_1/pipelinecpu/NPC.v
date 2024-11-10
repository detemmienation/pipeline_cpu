`include "ctrl_encode_def.v"
module NPC(PC1, PC2, NPCOp, Zero, IMM, NPC ,aluout, Flush);  // next pc module
  //NPC 的目的是将 sb 型跳转、jal 型跳转，jalr 型跳转以及不跳转四项功能整合，通过控制信号更新PC。
  //添加了控制冒险，输出一个 Flush 信号，可以进行控制冒险检测
   input Zero;
   input  [31:0] PC1, PC2;        // pc1 IF阶段的PC地址 
   //pc2 存放在EX/MEM流水线寄存器里的当前指令执行时的P
   input  [2:0]  NPCOp;     // next pc operation
   input  [31:0] IMM;       // immediate
	input [31:0] aluout;  //jalr跳转要用到的aluout
   output reg [31:0] NPC;   // next pc
   output reg Flush; //输出的控制是否清空流水线寄存器的信号 
   //IF ID EX
   wire [31:0] PCPLUS4;
   
   assign PCPLUS4 = PC1 + 4; // pc + 4
   //进行控制冒险解决
   always @(*) begin
      case (NPCOp)
          `NPC_PLUS4: begin
               NPC = PCPLUS4;// PCPLUS4 = PC1 + 4
               Flush=0;
          end
          `NPC_BRANCH: begin
              //一旦发生跳转，则预测不发生的控制冒险要进行问题解决，即清空流水线寄存器，并且NPC=PC2+IMM
             if(Zero) begin//ALU的计算结果为0（zero=1）且flush=1 pc由分支目标地址取代 
               NPC = PC2+IMM;
               Flush=1;
             end
             //未发生跳转，继续按预测的执行
             else begin
               NPC = PCPLUS4;
               Flush = 0;
             end
          end 
          `NPC_JUMP:  begin
         //jal是强制跳转，所以清空流水线寄存器，并且NPC=PC2+IMM
             NPC = PC2+IMM;
             Flush = 1;
          end
		    `NPC_JALR:	begin
            //jalr是强制跳转，所以清空流水线寄存器，并且NPC=aluout
            NPC = aluout;
            Flush = 1;
          end
      endcase
   end
   
endmodule
