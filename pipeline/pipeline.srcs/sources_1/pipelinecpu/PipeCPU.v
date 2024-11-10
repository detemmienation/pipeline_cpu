`include "ctrl_encode_def.v"
module PipeCPU(
    input clk,			
	input reset,
	input MIO_ready,							
	input [31:0]inst_in,
	input [31:0]Data_in,				
	output mem_w,
	output[31:0]PC_out,
	output[31:0]Addr_out,
	output reg [31:0] Data_out, 
	output CPU_MIO,
	output reg [3:0] wea,
	input INT
);

    wire [31:0] NPC_in;
    wire PCWrite,IFIDWrite,Ctrlflush,Flush;
    wire [1:0] F1,F2;
    reg [31:0] F1RD1,F2RD2;

  PC U_PC(
    .clk(clk),
    .rst(reset),
    .NPC(NPC_in),
    .PC(PC_out),
    .PCWrite(PCWrite)
  );

    wire [31:0] IF_PC,IF_inst_in;
    wire [4:0] rs1,rs2,IF_rs1,IF_rs2;
    assign rs1 = inst_in[19:15];  // rs1
    assign rs2 = inst_in[24:20];  // rs2
    
    IF U_IF(
        .PCi(PC_out),
        .InstMemi(inst_in),
        .PCo(IF_PC),
        .InstMemo(IF_inst_in),
        .clk(clk),
        .rst(reset),
        .rs1i(rs1),
        .rs1o(IF_rs1),
        .rs2i(rs2),
        .rs2o(IF_rs2),
        .IFIDWrite(IFIDWrite),
        .Flush(Flush)
    );

    wire MEM_RegWrite;
    wire [4:0] MEM_rd,rd,ID_rs1,ID_rs2;
    wire [31:0] RD1,RD2;
    reg [31:0] WD;

    assign rd = IF_inst_in[11:7];  // rd


    RF U_RF(
        .clk(clk),
        .rst(reset),
        .A1(IF_rs1),
        .A2(IF_rs2),
        .A3(MEM_rd),
        .RFWr(MEM_RegWrite),
        .WD(WD),
        .RD1(RD1),
        .RD2(RD2)
    );

    wire [4:0] iimm_shamt;
	wire [11:0] iimm,simm,bimm;
	wire [19:0] uimm,jimm;
	wire [31:0] immout;
    wire [5:0]  EXTOp;
    assign iimm_shamt=IF_inst_in[24:20];
	assign iimm=IF_inst_in[31:20];
	assign simm={IF_inst_in[31:25],IF_inst_in[11:7]};
	assign bimm={IF_inst_in[31],IF_inst_in[7],IF_inst_in[30:25],IF_inst_in[11:8]};
	assign uimm=IF_inst_in[31:12];
	assign jimm={IF_inst_in[31],IF_inst_in[19:12],IF_inst_in[20],IF_inst_in[30:21]};

    EXT U_EXT(
        .iimm_shamt(iimm_shamt),
        .iimm(iimm),
        .simm(simm),
        .bimm(bimm),
        .uimm(uimm),
        .jimm(jimm),
        .EXTOp(EXTOp),
        .immout(immout)
    );

    wire [6:0]  Op;          // opcode
    wire [6:0]  Funct7;       // funct7
    wire [2:0]  Funct3;       // funct3
    wire        RegWrite,MemWrite;    // control signal to register write
    wire [4:0]  ALUOp;       // ALU opertion
    wire [2:0]  NPCOp, DMType;      
    wire [1:0]  WDSel;       // (register) write data selection
    wire        ALUSrc;      // ALU source for A
    assign Op = IF_inst_in[6:0];  // instruction
    assign Funct7 = IF_inst_in[31:25]; // funct7
    assign Funct3 = IF_inst_in[14:12]; // funct3
    ctrl U_ctrl(
        .Op(Op), 
        .Funct7(Funct7), 
        .Funct3(Funct3), 
		.RegWrite(RegWrite), 
        .MemWrite(MemWrite),
		.EXTOp(EXTOp), 
        .ALUOp(ALUOp), 
        .NPCOp(NPCOp), 
		.ALUSrc(ALUSrc), 
        .WDSel(WDSel), 
        .DMType(DMType),
        .Ctrlflush(Ctrlflush)
    );
    
    wire        ID_RegWrite,ID_MemWrite;    // control signal to register write
    wire [4:0]  ID_ALUOp,ID_rd;       // ALU opertion
    wire [2:0]  ID_NPCOp, ID_DMType;      
    wire [1:0]  ID_WDSel;       // (register) write data selection
    wire        ID_ALUSrc;
    wire [31:0] ID_RD1,ID_RD2;
    wire [31:0] ID_immout;
    wire [31:0] ID_PC;

    ID U_ID(
        .clk(clk),
        .rst(reset),
        .RegWritei(RegWrite), 
        .MemWritei(MemWrite),
        .ALUOpi(ALUOp), 
        .NPCOpi(NPCOp), 
		.ALUSrci(ALUSrc), 
        .WDSeli(WDSel), 
        .DMTypei(DMType),
        .RegWriteo(ID_RegWrite), 
        .MemWriteo(ID_MemWrite),
        .ALUOpo(ID_ALUOp), 
        .NPCOpo(ID_NPCOp), 
		.ALUSrco(ID_ALUSrc), 
        .WDSelo(ID_WDSel), 
        .DMTypeo(ID_DMType),
        .PCi(IF_PC),
        .PCo(ID_PC),
        .RD1i(RD1),
        .RD1o(ID_RD1),
        .RD2i(RD2),
        .RD2o(ID_RD2),
        .rdi(rd),
        .rdo(ID_rd),
        .immouti(immout),
        .immouto(ID_immout),
        .rs1i(IF_rs1),
        .rs1o(ID_rs1),
        .rs2i(IF_rs2),
        .rs2o(ID_rs2),
        .Flush(Flush)
    );

    wire [31:0] B,aluout;
    wire Zero;
    assign B = (ID_ALUSrc) ? ID_immout : F2RD2;

    alu U_alu(
        .A(F1RD1),
        .B(B),
        .PC(ID_PC),
        .ALUOp(ID_ALUOp),
        .C(aluout),
        .Zero(Zero)
    );

    wire        EX_Zero,EX_RegWrite,EX_MemWrite;    // control signal to register write
    wire [4:0]  EX_rd;       // ALU opertion
    wire [2:0]  EX_NPCOp, EX_DMType;      
    wire [1:0]  EX_WDSel;       // (register) write data selection
    wire [31:0] EX_RD2;
    wire [31:0] EX_immout;
    wire [31:0] EX_PC,EX_aluout;

    EX U_EX(
        .clk(clk),
        .rst(reset),
        .RegWritei(ID_RegWrite), 
        .MemWritei(ID_MemWrite),
        .NPCOpi(ID_NPCOp), 
        .WDSeli(ID_WDSel), 
        .DMTypei(ID_DMType),
        .RegWriteo(EX_RegWrite), 
        .MemWriteo(EX_MemWrite), 
        .NPCOpo(EX_NPCOp), 
        .WDSelo(EX_WDSel), 
        .DMTypeo(EX_DMType),
        .PCi(ID_PC),
        .PCo(EX_PC),
        .RD2i(F2RD2),
        .RD2o(EX_RD2),
        .rdi(ID_rd),
        .rdo(EX_rd),
        .immouti(ID_immout),
        .immouto(EX_immout),
        .aluouti(aluout),
        .aluouto(EX_aluout),
        .Zeroi(Zero),
        .Zeroo(EX_Zero),
        .Flush(Flush)
    );

    NPC U_NPC(
        .PC1(PC_out),
        .PC2(EX_PC),
        .NPCOp(EX_NPCOp),
        .Zero(EX_Zero),
        .IMM(EX_immout),
        .aluout(EX_aluout),
        .NPC(NPC_in),
        .Flush(Flush)
   );
								
    assign mem_w=EX_MemWrite;
    assign Addr_out=EX_aluout;

    //选择写入是字，半字还是字节，用wea控制写那些字节
    always @* begin
        if(mem_w) begin
            case(EX_DMType)
            `dm_word: begin
                wea <= 4'b1111;
                Data_out <= EX_RD2;
            end
            `dm_halfword: begin
                case(EX_aluout[1:0])
                    2'b00: begin
                        wea <= 4'b0011;
                        Data_out <= EX_RD2;
                    end
                    2'b10: begin
                        wea <= 4'b1100;
                        Data_out <= EX_RD2<<16;
                    end
                endcase
            end
            `dm_byte: begin
                case(EX_aluout[1:0])
                    2'b00: begin
                        wea <= 4'b0001;
                        Data_out <= EX_RD2;
                    end
                    2'b01: begin
                        wea <= 4'b0010;
                        Data_out <= EX_RD2<<8;
                    end
                    2'b10: begin
                        wea <= 4'b0100;
                        Data_out <= EX_RD2<<16;
                    end
                    2'b11:  begin
                        wea <= 4'b1000;
                        Data_out <= EX_RD2<<24;
                    end
                endcase
            end
            endcase
        end
        else begin
            wea <= 4'b0000;
            Data_out <= EX_RD2;
        end
    end

    wire [1:0]  MEM_WDSel;     
    wire [2:0]  MEM_DMType;    
    wire [31:0] MEM_PC,MEM_Data_in,MEM_aluout;

    MEM U_MEM(
        .clk(clk),
        .rst(reset),
        .RegWritei(EX_RegWrite), 
        .WDSeli(EX_WDSel), 
        .RegWriteo(MEM_RegWrite),   
        .WDSelo(MEM_WDSel), 
        .PCi(EX_PC),
        .PCo(MEM_PC),
        .rdi(EX_rd),
        .rdo(MEM_rd),
        .Data_ini(Data_in),
        .Data_ino(MEM_Data_in),
        .aluouti(EX_aluout),
        .aluouto(MEM_aluout),
        .DMTypei(EX_DMType),
        .DMTypeo(MEM_DMType)
    );
    //选择读取字，半字，字节的部分
   always @* begin
	case(MEM_WDSel)
		`WDSel_FromALU: WD <= MEM_aluout;
		`WDSel_FromMEM: begin
            case(MEM_DMType)
                `dm_word: WD<=MEM_Data_in;
				
                `dm_halfword: begin
					case(MEM_aluout[1:0])
						2'b00: WD<={{16{MEM_Data_in[15]}}, MEM_Data_in[15:0]};
						2'b10: WD<={{16{MEM_Data_in[31]}}, MEM_Data_in[31:16]};
					endcase
				end
                
                `dm_halfword_unsigned: begin
					case(MEM_aluout[1:0])
						2'b00: WD<={16'b0, MEM_Data_in[15:0]};
						2'b10: WD<={16'b0, MEM_Data_in[31:16]};
					endcase
				end

                `dm_byte: begin
					case(MEM_aluout[1:0])
						2'b00: WD<={{24{MEM_Data_in[7]}}, MEM_Data_in[7:0]};
						2'b01: WD<={{24{MEM_Data_in[15]}}, MEM_Data_in[15:8]};
						2'b10: WD<={{24{MEM_Data_in[23]}}, MEM_Data_in[23:16]};
						2'b11: WD<={{24{MEM_Data_in[31]}}, MEM_Data_in[31:24]};
					endcase
				end
                
                `dm_byte_unsigned: begin
					case(MEM_aluout[1:0])
						2'b00: WD<={24'b0, MEM_Data_in[7:0]};
						2'b01: WD<={24'b0, MEM_Data_in[15:8]};
						2'b10: WD<={24'b0, MEM_Data_in[23:16]};
						2'b11: WD<={24'b0, MEM_Data_in[31:24]};
					endcase
				end

            endcase
        end
		`WDSel_FromPC: WD<=MEM_PC+4;
	endcase
end 
    //旁路在这里
    always @(*) begin
        case(F1)
            2'b01: F1RD1 <= EX_aluout;
            2'b10: F1RD1 <= WD;
            2'b00: F1RD1 <= ID_RD1;
        endcase
    end
    always @(*) begin
        case(F2)
            2'b01: F2RD2 <= EX_aluout;
            2'b10: F2RD2 <= WD;
            2'b00: F2RD2 <= ID_RD2;
        endcase
    end
        forward U_forward(
        .ID_rs1(ID_rs1),
        .ID_rs2(ID_rs2),
        .EX_rd(EX_rd),
        .MEM_rd(MEM_rd), 
        .EX_RegWrite(EX_RegWrite), 
        .MEM_RegWrite(MEM_RegWrite), 
        .F1(F1),
        .F2(F2)
        ); 

        Hazard U_Hazard(
            .IF_rs1(IF_rs1), 
            .IF_rs2(IF_rs2), 
            .ID_rd(ID_rd), 
            .ID_WDSel(ID_WDSel), 
            .PCWrite(PCWrite), 
            .IFIDWrite(IFIDWrite), 
            .Ctrlflush(Ctrlflush)
        );
endmodule