module ID(  
//ID/EX Á÷Ë®Ïß¼Ä´æÆ÷         
            input         clk, 
            input         rst,
        //i for In,o for Out
        input RegWritei, 
        input MemWritei,
        input [4:0] ALUOpi, 
        input [2:0] NPCOpi, 
		input ALUSrci, 
        input [1:0] WDSeli, 
        input [2:0] DMTypei,
        output reg [4:0] ALUOpo, 
        output reg RegWriteo, 
        output reg MemWriteo,
        output reg [2:0] NPCOpo, 
		output reg ALUSrco, 
        output reg [1:0] WDSelo, 
        output reg [2:0] DMTypeo,
        input [31:0] PCi,
        output reg [31:0] PCo,
        input [31:0] RD1i,
        output reg [31:0] RD1o,
        input [31:0] RD2i,
        output reg [31:0] RD2o,
        input [4:0] rdi,
        output reg [4:0] rdo,
        input [31:0] immouti,
        output reg [31:0] immouto,
        input [4:0] rs1i,
        output reg [4:0] rs1o,
        input [4:0] rs2i,
        output reg [4:0] rs2o,
        input Flush
);
    
always @(posedge clk, posedge rst)
    if (rst||Flush) begin   
        PCo <= 32'b0;
        RD1o <= 32'b0;
        RD2o <= 32'b0;
        rdo <= 5'b0;
        ALUOpo <= 5'b0;
        RegWriteo <= 1'b0;
        MemWriteo <= 1'b0;
        NPCOpo <= 3'b0;
		ALUSrco <= 1'b0;
        WDSelo <= 2'b0; 
        DMTypeo <= 3'b0;
        immouto <= 32'b0;
        rs1o <= 5'b0;
        rs2o <= 5'b0;
    end
    else begin
        PCo <= PCi;
        RD1o <= RD1i;
        RD2o <= RD2i;
        rdo <= rdi;
        ALUOpo <= ALUOpi;
        RegWriteo <= RegWritei;
        MemWriteo <= MemWritei;
        NPCOpo <= NPCOpi;
		ALUSrco <= ALUSrci;
        WDSelo <= WDSeli; 
        DMTypeo <= DMTypei;
        immouto <= immouti;
        rs1o <= rs1i;
        rs2o <= rs2i;
    end
endmodule