 `include "ctrl_encode_def.v"
module ctrl(Op, Funct7, Funct3,  
            RegWrite, MemWrite,
            EXTOp, ALUOp, NPCOp, 
            ALUSrc, WDSel,DMType,Ctrlflush
            );
   //控制信号生成单元         
   input  [6:0] Op;       // opcode
   input  [6:0] Funct7;    // funct7
   input  [2:0] Funct3;    // funct3
   input        Ctrlflush; ///清空所有控制信号 控制是否清空所有控制信号
   output       RegWrite; // 寄存器的写使能
   output       MemWrite; // 存储器的写使能信号
   output [5:0] EXTOp;    // 立即数扩展
   output [4:0] ALUOp;    // ALU的操作控制信号
   output [2:0] NPCOp;    // PC输入的选择信号
   output       ALUSrc;   // ALU的A端口来源选择信号
	 output [2:0] DMType;//从dm读出的数据取字，半字或字节的选择信号
   output [1:0] WDSel;    // 选择写回信号的控制信号
   
  // r format
    wire rtype  = ~Op[6]&Op[5]&Op[4]&~Op[3]&~Op[2]&Op[1]&Op[0]; //0110011
    wire i_add  = rtype& ~Funct7[6]&~Funct7[5]&~Funct7[4]&~Funct7[3]&~Funct7[2]&~Funct7[1]&~Funct7[0]&~Funct3[2]&~Funct3[1]&~Funct3[0]; // add 0000000 000
    wire i_sub  = rtype& ~Funct7[6]& Funct7[5]&~Funct7[4]&~Funct7[3]&~Funct7[2]&~Funct7[1]&~Funct7[0]&~Funct3[2]&~Funct3[1]&~Funct3[0]; // sub 0100000 000
    wire i_or   = rtype& ~Funct7[6]&~Funct7[5]&~Funct7[4]&~Funct7[3]&~Funct7[2]&~Funct7[1]&~Funct7[0]& Funct3[2]& Funct3[1]&~Funct3[0]; // or 0000000 110
    wire i_and  = rtype& ~Funct7[6]&~Funct7[5]&~Funct7[4]&~Funct7[3]&~Funct7[2]&~Funct7[1]&~Funct7[0]& Funct3[2]& Funct3[1]& Funct3[0]; // and 0000000 111
    wire i_sll  = rtype& ~Funct7[6]&~Funct7[5]&~Funct7[4]&~Funct7[3]&~Funct7[2]&~Funct7[1]&~Funct7[0]&~Funct3[2]&~Funct3[1]& Funct3[0]; // sll 0000000 001
    wire i_slt  = rtype& ~Funct7[6]&~Funct7[5]&~Funct7[4]&~Funct7[3]&~Funct7[2]&~Funct7[1]&~Funct7[0]&~Funct3[2]& Funct3[1]&~Funct3[0]; // slt 0000000 010
    wire i_sltu = rtype& ~Funct7[6]&~Funct7[5]&~Funct7[4]&~Funct7[3]&~Funct7[2]&~Funct7[1]&~Funct7[0]&~Funct3[2]& Funct3[1]& Funct3[0]; // sltu 0000000 011
    wire i_xor  = rtype& ~Funct7[6]&~Funct7[5]&~Funct7[4]&~Funct7[3]&~Funct7[2]&~Funct7[1]&~Funct7[0]& Funct3[2]&~Funct3[1]&~Funct3[0]; // xor 0000000 100
    wire i_srl  = rtype& ~Funct7[6]&~Funct7[5]&~Funct7[4]&~Funct7[3]&~Funct7[2]&~Funct7[1]&~Funct7[0]& Funct3[2]&~Funct3[1]& Funct3[0]; // srl 0000000 101
    wire i_sra  = rtype& ~Funct7[6]& Funct7[5]&~Funct7[4]&~Funct7[3]&~Funct7[2]&~Funct7[1]&~Funct7[0]& Funct3[2]&~Funct3[1]& Funct3[0]; // sra 0100000 101


 // i format
   wire itype_l  = ~Op[6]&~Op[5]&~Op[4]&~Op[3]&~Op[2]&Op[1]&Op[0]; //0000011
   wire i_lb  =  itype_l& ~Funct3[2]& ~Funct3[1]& ~Funct3[0]; // lb 000
   wire i_lh  =  itype_l& ~Funct3[2]& ~Funct3[1]&  Funct3[0]; // lh 001
   wire i_lw  =  itype_l& ~Funct3[2]&  Funct3[1]& ~Funct3[0]; // lw 010
   wire i_lbu =  itype_l&  Funct3[2]& ~Funct3[1]& ~Funct3[0]; // lbu 100
   wire i_lhu =  itype_l&  Funct3[2]& ~Funct3[1]&  Funct3[0]; // lhu 101
  

// i format
    wire itype_r  = ~Op[6]&~Op[5]&Op[4]&~Op[3]&~Op[2]&Op[1]&Op[0]; //0010011
    wire i_addi   =  itype_r& ~Funct3[2]& ~Funct3[1]& ~Funct3[0]; // addi 000
    wire i_ori    =  itype_r&  Funct3[2]&  Funct3[1]& ~Funct3[0]; // ori 110
    wire i_slti   =  itype_r& ~Funct3[2]&  Funct3[1]& ~Funct3[0]; // slti 010
    wire i_sltiu  =  itype_r& ~Funct3[2]&  Funct3[1]&  Funct3[0]; // sltiu 011
    wire i_xori   =  itype_r&  Funct3[2]& ~Funct3[1]& ~Funct3[0]; // xori 100
    wire i_andi   =  itype_r&  Funct3[2]&  Funct3[1]&  Funct3[0]; // andi 111
    wire i_slli   =  itype_r& ~Funct3[2]& ~Funct3[1]&  Funct3[0]; // slli 001
    wire i_srli   =  itype_r& ~Funct7[5]&  Funct3[2]& ~Funct3[1]&  Funct3[0]; // srli 0000000 101
    wire i_srai   =  itype_r&  Funct7[5]&  Funct3[2]& ~Funct3[1]&  Funct3[0]; // srai 0100000 101
	
 //jalr
	wire i_jalr =Op[6]&Op[5]&~Op[4]&~Op[3]&Op[2]&Op[1]&Op[0];//jalr 1100111

  // s format
   wire stype  = ~Op[6]&Op[5]&~Op[4]&~Op[3]&~Op[2]&Op[1]&Op[0];//0100011
   wire i_sw   =  stype& ~Funct3[2]& Funct3[1]&~Funct3[0]; // sw 010
   wire i_sh   =  stype& ~Funct3[2]&~Funct3[1]& Funct3[0]; // sh 001
   wire i_sb   =  stype& ~Funct3[2]&~Funct3[1]&~Funct3[0]; // sb 000

  // sb format
   wire sbtype  = Op[6]&Op[5]&~Op[4]&~Op[3]&~Op[2]&Op[1]&Op[0];//1100011
   wire i_beq  = sbtype& ~Funct3[2]& ~Funct3[1]&~Funct3[0]; // beq 000
   wire i_bne  = sbtype& ~Funct3[2]& ~Funct3[1]& Funct3[0]; // bne 001
   wire i_blt  = sbtype&  Funct3[2]& ~Funct3[1]&~Funct3[0]; // blt 100
   wire i_bge  = sbtype&  Funct3[2]& ~Funct3[1]& Funct3[0]; // bge 101
   wire i_bltu = sbtype&  Funct3[2]&  Funct3[1]&~Funct3[0]; // bltu 110
   wire i_bgeu = sbtype&  Funct3[2]&  Funct3[1]& Funct3[0]; // bgeu 111
	
 // j format
   wire i_jal  = Op[6]& Op[5]&~Op[4]& Op[3]& Op[2]& Op[1]& Op[0];  // jal 1101111

 // u format
   wire i_lui   = ~Op[6]&Op[5]&Op[4]&~Op[3]&Op[2]&Op[1]&Op[0];//lui 0110111
   wire i_auipc = ~Op[6]&~Op[5]&Op[4]&~Op[3]&Op[2]&Op[1]&Op[0];//auipc 0010111

 // RegWrite: 
  assign RegWrite = Ctrlflush ? 1'b0 : (rtype | itype_r | i_jalr | i_jal | itype_l | i_lui | i_auipc); 

  // MemWrite:
  assign MemWrite = Ctrlflush ? 1'b0 : stype;

  // EXTOp: signed extension
  // EXT_CTRL_ITYPE_SHAMT 6'b100000
  // EXT_CTRL_ITYPE	      6'b010000
  // EXT_CTRL_STYPE	      6'b001000
  // EXT_CTRL_BTYPE	      6'b000100
  // EXT_CTRL_UTYPE	      6'b000010
  // EXT_CTRL_JTYPE	      6'b000001
  //有Ctrlflush就置0
  assign EXTOp[5] = Ctrlflush? 1'b0 : (i_slli | i_srai | i_srli);
  assign EXTOp[4] = Ctrlflush? 1'b0 : (i_addi | i_andi | i_ori | i_xori | i_slti | i_sltiu | i_jalr | itype_l);  
  assign EXTOp[3] = Ctrlflush? 1'b0 : stype; 
  assign EXTOp[2] = Ctrlflush? 1'b0 : sbtype; 
  assign EXTOp[1] = Ctrlflush? 1'b0 : (i_lui | i_auipc);   
  assign EXTOp[0] = Ctrlflush? 1'b0 : i_jal;         

  // ALUOp
  ////有Ctrlflush就置0
	assign ALUOp[0] = Ctrlflush? 1'b0 : (i_lui|i_add|i_addi|i_jalr|itype_l|stype|i_bne|i_bge|i_bgeu|i_sltu|i_sltiu|i_or|i_ori|i_sll|i_slli|i_sra|i_srai);
	assign ALUOp[1] = Ctrlflush? 1'b0 : (i_auipc|i_add|i_addi|i_jalr|itype_l|stype|i_blt|i_bge|i_slt|i_slti|i_sltu|i_sltiu|i_and|i_andi|i_sll|i_slli);
	assign ALUOp[2] = Ctrlflush? 1'b0 : (i_sub|i_beq|i_bne|i_blt|i_bge|i_xor|i_xori|i_or|i_ori|i_and|i_andi|i_sll|i_slli);
	assign ALUOp[3] = Ctrlflush? 1'b0 : (i_bltu|i_bgeu|i_slt|i_slti|i_sltu|i_sltiu|i_xor|i_xori|i_or|i_ori|i_and|i_andi|i_sll|i_slli);
	assign ALUOp[4] = Ctrlflush? 1'b0 : (i_srl|i_srli|i_sra|i_srai);

  // NPCOp: 
  // NPC_PLUS4   3'b000
  // NPC_BRANCH  3'b001
  // NPC_JUMP    3'b010
  // NPC_JALR	   3'b100
  ////有Ctrlflush就置0
  assign NPCOp[0] = Ctrlflush? 1'b0 : sbtype;
  assign NPCOp[1] = Ctrlflush? 1'b0 : i_jal;
	assign NPCOp[2] = Ctrlflush? 1'b0 : i_jalr;
  
  // ALUSrc:
  ////有Ctrlflush就置0
  assign ALUSrc = Ctrlflush? 1'b0 : (itype_r | itype_l | stype | i_jalr | i_lui | i_auipc);   // ALU B is from instruction immediate
  
  // WDSel:
  // WDSel_FromALU  2'b00
  // WDSel_FromMEM  2'b01
  // WDSel_FromPC   2'b10 
  ////有Ctrlflush就置0
  assign WDSel[0] = Ctrlflush? 1'b0 : itype_l;
  assign WDSel[1] = Ctrlflush? 1'b0 : (i_jal | i_jalr);

  // DMType:
  // dm_word 3'b000
  // dm_halfword 3'b001
  // dm_halfword_unsigned 3'b010
  // dm_byte 3'b011
  // dm_byte_unsigned 3'b100
  ////有Ctrlflush就置0
  assign DMType[0] = Ctrlflush? 1'b0 : (i_sh | i_lh | i_sb | i_lb);
  assign DMType[1] = Ctrlflush? 1'b0 : (i_lhu | i_sb | i_lb);
  assign DMType[2] = Ctrlflush? 1'b0 : i_lbu;

  endmodule