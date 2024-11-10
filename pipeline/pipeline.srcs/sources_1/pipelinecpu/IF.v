//IF/ID Á÷Ë®Ïß¼Ä´æ
module IF(  
            input         clk, 
            input         rst,
            //i for In,o for Out
            input  [31:0] PCi,
            output reg [31:0] PCo,
            input  [31:0] InstMemi,
            output reg [31:0] InstMemo,
            input [4:0] rs1i,
            output reg [4:0] rs1o,
            input [4:0] rs2i,
            output reg [4:0] rs2o,
            input IFIDWrite,
            input Flush
);
    
always @(posedge clk, posedge rst)
    if (rst||Flush) begin   
        PCo <= 32'b0;
        InstMemo <= 32'b0;
        rs1o <= 5'b0;
        rs2o <= 5'b0;
    end
    else if (IFIDWrite) begin
        PCo <= PCi;
        InstMemo <= InstMemi;
        rs1o <= rs1i;
        rs2o <= rs2i;
    end
endmodule