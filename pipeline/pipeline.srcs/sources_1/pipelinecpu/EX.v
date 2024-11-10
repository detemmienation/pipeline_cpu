module EX(  
        //EX/MEM Á÷Ë®Ïß¼Ä´æ
            input         clk, 
            input         rst,
            //i for In,o for Out
        input RegWritei, 
        input MemWritei, 
        input [2:0] NPCOpi,  
        input [1:0] WDSeli, 
        input [2:0] DMTypei,
        output reg RegWriteo, 
        output reg MemWriteo,
        output reg [2:0] NPCOpo,  
        output reg [1:0] WDSelo, 
        output reg [2:0] DMTypeo,

        input [31:0] PCi,
        output reg [31:0] PCo,

        input [31:0] RD2i,
        output reg [31:0] RD2o,

        input [4:0] rdi,
        output reg [4:0] rdo,

        input [31:0] immouti,
        output reg [31:0] immouto,

        input Zeroi,
        output reg Zeroo,

        input [31:0] aluouti,
        output reg [31:0]aluouto,

        input Flush
);
    
always @(posedge clk, posedge rst)
    if (rst||Flush) begin   
        PCo <= 32'b0;
        RD2o <= 32'b0;
        rdo <= 5'b0;
        RegWriteo <= 1'b0;
        MemWriteo <= 1'b0;
        NPCOpo <= 3'b0;
        WDSelo <= 2'b0; 
        DMTypeo <= 3'b0;
        immouto <= 32'b0;
        aluouto <= 32'b0;
        Zeroo <= 1'b0;
    end
    else begin
        PCo <= PCi;
        RD2o <= RD2i;
        rdo <= rdi;
        RegWriteo <= RegWritei;
        MemWriteo <= MemWritei;
        NPCOpo <= NPCOpi;
        WDSelo <= WDSeli; 
        DMTypeo <= DMTypei;
        immouto <= immouti;
        aluouto <= aluouti;
        Zeroo <= Zeroi;
    end
endmodule


