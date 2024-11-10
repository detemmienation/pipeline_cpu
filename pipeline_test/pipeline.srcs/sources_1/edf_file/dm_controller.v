`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/26 10:13:36
// Design Name: 
// Module Name: dm_controller
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
//`define dm_word 3'b000
//`define dm_halfword 3'b001
//`define dm_halfword_unsigned 3'b010
//`define dm_byte 3'b011
//`define dm_byte_unsigned 3'b100

//RAM_B读写控制模块
module dm_controller(
           input mem_w,             //一位，是否为写内存信号         
           input [31:0] Addr_in,    //读取的内存地址，控制wea_mem
           input [31:0] Data_read_from_dm,  //从内存连到dm上输出
           input [31:0] Data_write,     //
           input [2:0] dm_ctrl,         //内存操作的类型
      
           output reg [31:0] Data_read, //给CPU的经过对齐的数据
           output reg [31:0] Data_write_to_dm, //写给内存的数据
           output reg [3:0] wea_mem    //具体每一字节是否写，1111 word,0011&1100 halfword，0001/0010/0100/1000 byte
    );
    
    //write
    always@(*)
    begin
             if(mem_w)
               begin
                     case(dm_ctrl)
                         `dm_word:
                                begin
                                   Data_write_to_dm <= Data_write;
                                   wea_mem <= 4'b1111;
                                end
                         `dm_halfword:
                                begin
                                    Data_write_to_dm[15:0] <= Data_write[15:0];
                                    Data_write_to_dm[31:16] <= Data_write[15:0];
                                    case(Addr_in[1])
                                        1'b0:begin wea_mem <= 4'b0011; end
                                        1'b1:begin wea_mem <= 4'b1100; end
                                    endcase
                                end
                         `dm_halfword_unsigned:
                                begin
                                        Data_write_to_dm[15:0] <= Data_write[15:0];
                                        Data_write_to_dm[31:16] <= Data_write[15:0];
                                    case(Addr_in[1])
                                        1'b0:begin wea_mem <= 4'b0011; end
                                        1'b1:begin wea_mem <= 4'b1100; end
                                    endcase
                                end
                         `dm_byte: 
                                begin
                                    Data_write_to_dm[7:0] <= Data_write[7:0];
                                    Data_write_to_dm[15:8] <= Data_write[7:0];
                                    Data_write_to_dm[23:16] <= Data_write[7:0];
                                    Data_write_to_dm[31:24] <= Data_write[7:0];
                                    case(Addr_in[1:0])
                                        2'b00:begin wea_mem <= 4'b0001;  end
                                        2'b01:begin wea_mem <= 4'b0010;  end
                                        2'b10:begin wea_mem <= 4'b0100;  end
                                        2'b11:begin wea_mem <= 4'b1000;  end
                                    endcase
                                end
                         `dm_byte_unsigned:
                                begin
                                        Data_write_to_dm[7:0] <= Data_write[7:0];
                                        Data_write_to_dm[15:8] <= Data_write[7:0];
                                        Data_write_to_dm[23:16] <= Data_write[7:0];
                                        Data_write_to_dm[31:24] <= Data_write[7:0];
                                    case(Addr_in[1:0])
                                        2'b00:begin wea_mem <= 4'b0001;  end
                                        2'b01:begin wea_mem <= 4'b0010;  end
                                        2'b10:begin wea_mem <= 4'b0100;  end
                                        2'b11:begin wea_mem <= 4'b1000;  end
                                    endcase
                                end
                    
                         endcase
                end  //if  end

             else 
             begin
                  wea_mem = 4'b0000;
             end //else end
      end  // write always end
   
    
      //read
      always@(*)
      begin
               case(dm_ctrl)
                    `dm_word:
                        begin
                            Data_read <= Data_read_from_dm;
                        end
                    `dm_halfword:
                        begin
                            case(Addr_in[1])
                                    1'b0:begin    Data_read <= {   {16  {Data_read_from_dm[15]}  }  ,   Data_read_from_dm[15:0]  };  end
                                    1'b1:begin    Data_read <= {   {16  {Data_read_from_dm[31]}  }  ,   Data_read_from_dm[31:16] }; end
                            endcase
                        end
                    `dm_halfword_unsigned:
                        begin
                             case(Addr_in[1])
                                   1'b0:begin    Data_read <= {   16'b0,   Data_read_from_dm[15:0]  };  end
                                   1'b1:begin    Data_read <= {   16'b0 ,   Data_read_from_dm[31:16] }; end
                             endcase
                        end
                    `dm_byte: 
                        begin
                            case(Addr_in[1:0])
                              2'b00:begin   Data_read <= {   {24  {Data_read_from_dm[7]}  }  ,   Data_read_from_dm[7:0] };   end
                              2'b01:begin   Data_read <= {   {24  {Data_read_from_dm[15]}  }  ,   Data_read_from_dm[15:8] };  end
                              2'b10:begin   Data_read <= {   {24  {Data_read_from_dm[23]}  }  ,   Data_read_from_dm[23:16] }; end
                              2'b11:begin   Data_read <= {   {24  {Data_read_from_dm[31]}  }  ,   Data_read_from_dm[31:24] };  end
                            endcase
                        end
                    `dm_byte_unsigned:
                        begin
                              case(Addr_in[1:0])
                                                    2'b00:begin   Data_read <= {   24'b0  ,   Data_read_from_dm[7:0] };   end
                                                    2'b01:begin   Data_read <= {   24'b0 ,   Data_read_from_dm[15:8] };  end
                                                    2'b10:begin   Data_read <= {   24'b0  ,   Data_read_from_dm[23:16] }; end
                                                    2'b11:begin   Data_read <= {   24'b0  ,   Data_read_from_dm[31:24] };  end
                               endcase
                        end
               endcase
      end // read always end
    
endmodule
