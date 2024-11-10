module MEM(  
          //MEM/WB Á÷Ë®Ïß¼Ä´æÆ÷
            input         clk, 
            input         rst,
        //i for In,o for Out
        input RegWritei, 
        input [1:0] WDSeli, 
        input [2:0] DMTypei,
        output reg RegWriteo, 
        output reg [1:0] WDSelo,
        output reg [2:0] DMTypeo,
        input [31:0] PCi,
        output reg [31:0] PCo,
        input [4:0] rdi,
        output reg [4:0] rdo,
        input [31:0] Data_ini,
        output reg [31:0] Data_ino,
        input [31:0] aluouti,
        output reg [31:0]aluouto
);


always @(posedge clk, posedge rst)
    if (rst) begin   
        PCo <= 32'b0;
        rdo <= 5'b0;
        RegWriteo <= 1'b0;
        WDSelo <= 2'b0; 
        Data_ino <= 32'b0;
        aluouto <= 32'b0;
        DMTypeo <= 3'b0;
    end
    else begin
        PCo <= PCi;
        rdo <= rdi;
        RegWriteo <= RegWritei;
        WDSelo <= WDSeli; 
        Data_ino <= Data_ini;
        aluouto <= aluouti;
        DMTypeo <= DMTypei;
    end
endmodule
