//寄存器文件
//用于读取或存储寄存器，输入读取或存储的地址以及控制信号，输出读出的数据。
  module RF(   input         clk, 
               input         rst,
               input         RFWr, 
               input  [4:0]  A1, A2, A3, 
               input  [31:0] WD, 
               output reg [31:0] RD1, RD2);
//A1读寄存器1 2 读寄存器2
//A3写寄存器地址
//WD写数据
//RFWr 为1 时候写
// RD1, RD2 读寄存器1 2 的数据
  reg [31:0] rf[31:0];

  integer i;

  always @(posedge clk, posedge rst)
    if (rst) begin    //  reset
      for (i=1; i<32; i=i+1)
        rf[i] <= 0; //  i;
    end
      
    else 
      if (RFWr) begin
        rf[A3] <= WD;
//        $display("r[00-07]=0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X", 0, rf[1], rf[2], rf[3], rf[4], rf[5], rf[6], rf[7]);
//        $display("r[08-15]=0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X", rf[8], rf[9], rf[10], rf[11], rf[12], rf[13], rf[14], rf[15]);
//        $display("r[16-23]=0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X", rf[16], rf[17], rf[18], rf[19], rf[20], rf[21], rf[22], rf[23]);
//        $display("r[24-31]=0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X", rf[24], rf[25], rf[26], rf[27], rf[28], rf[29], rf[30], rf[31]);
        $display("r[%2d] = 0x%8X,", A3, WD);
      end
    
  always @ (*)  begin
      if(rst||A1==5'b0) begin
          RD1=32'b0;
      end
      else if(RFWr && A3==A1) begin
          RD1=WD;
      end
      else begin
          RD1 = rf[A1];
      end
  end

  always @ (*)  begin
      if(rst||A2==5'b0) begin
          RD2=32'b0;
      end
      else if(RFWr && A3==A2) begin
          RD2=WD;
      end
      else begin
          RD2 = rf[A2];
      end
  end

  //assign reg_data = (reg_sel != 0) ? rf[reg_sel] : 0; 

endmodule 
