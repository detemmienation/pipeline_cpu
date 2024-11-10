`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/26 15:56:41
// Design Name: 
// Module Name: top
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

module top(
    input rstn,
    input [4:0]btn_i,
    input [15:0]sw_i,
    input clk,
    
    output[7:0] disp_an_o,
    output[7:0] disp_seg_o,
    
    output [15:0]led_o
);	 
    //U10 Enter
    wire [4:0] BTN_out;
    wire [15:0] SW_out;

    //U8 clk_div
    wire rst;
    assign rst = ~rstn;//RTL_INV?  
    wire [31:0] Div;

    //clk part
    wire Clk_CPU,IO_clk,clka0;
    assign IO_clk = ~Clk_CPU;//RTL_INV?  
    assign clka0 = ~clk;
    
    //U7 SPIO
    wire [15:0] led_out;
    wire [1:0] counter_set;  
    wire [15:0] led;

    //U2_3 dm_controller
    wire [31:0] Data_read;
    wire [31:0] Data_write_to_dm;
    wire [3:0] wea_mem;

     //U9 Counter
    wire counter0_out,counter1_out,counter2_out;
    wire [31:0] counter_out;
    
    //U2 ROM_D
    wire [31:0] spo;

    //U3 RAM_B
    wire [31:0] douta;

    //U1 SCPU
    wire mem_w;
    wire [31:0] PC_out;
    wire [31:0] Addr_out;
    wire [31:0] Data_out;
    wire [2:0] dm_ctrl;    
    wire CPU_MIO;   

    //U4 MIO_BUS
    wire [9:0] ram_addr;
    wire [31:0] ram_data_in;    
    wire [31:0] data4bus;
    wire counter_we;
    wire GPIOf0_we,GPIOe0_we;
    wire [31:0] Peripheral_in;

    //U5 Multi_8H32
    wire [7:0] point_out,LE_out;
    wire [31:0] Disp_num;    
   
    //U6 SSeg7
    wire [7:0]seg_an;
    wire [7:0]seg_sout;
    

    SCPU U1(
        //input
        .clk(Clk_CPU),
        .reset(rst),
        .MIO_ready(CPU_MIO),        
        .inst_in(spo),
        .Data_in(Data_read),        
        .INT(counter0_out),

        //output
        .mem_w(mem_w), 
        .PC_out(PC_out),
        .Addr_out(Addr_out),
        .Data_out(Data_out),
        .CPU_MIO(CPU_MIO),      
        .DMType(dm_ctrl)
    );

    ROM_D U2(
        //input
        .a(PC_out[11:2]),
        //output
        .spo(spo)
    );
    
    dm_controller U2_3(
    //input
    .mem_w(mem_w), 
    .Addr_in(Addr_out), 
    .Data_write(ram_data_in), 
    .dm_ctrl(dm_ctrl), 
    .Data_read_from_dm(data4bus), 
    //output
    .Data_read(Data_read), 
    .Data_write_to_dm(Data_write_to_dm), 
    .wea_mem(wea_mem)
    );
    
    RAM_B U3(
        //input
        .clka(clka0),
        .wea(wea_mem),
        .addra(ram_addr),
        .dina(ram_data_in),
        //output
        .douta(douta)
    );

    MIO_BUS U4(
        //input
        .clk(clk),
        .rst(rst),
        .BTN(BTN_out),
        .SW(SW_out),
        .PC(PC_out),
        .mem_w(mem_w),
        .Cpu_data2bus(Data_out),        
        .addr_bus(Addr_out),
        .ram_data_out(douta),
        .led_out(led_out),
        .counter_out(counter_out),
        .counter0_out(counter0_out),
        .counter1_out(counter1_out),
        .counter2_out(counter2_out),
        //output
        //.data_ram_we(),
        .ram_addr(ram_addr),
        .ram_data_in(ram_data_in),
        .Cpu_data4bus(data4bus),
        .counter_we(counter_we),
        .GPIOf0000000_we(GPIOf0_we),
        .GPIOe0000000_we(GPIOe0_we),
        .Peripheral_in(Peripheral_in)
    );

    Multi_8CH32 U5(
        //input
        .clk(IO_clk),
        .rst(rst),
        .EN(GPIOe0_we),
        .Switch(SW_out[7:5]),
        .point_in({Div[31:0],Div[31:0]}),
        //.LES(64'b0),
        .LES(64'hFFFFFFFFFFFFFFFF),
        .data0(Peripheral_in),
        .data1({2'b0,PC_out[31:2]}),
        //.data1(PC_out),
        .data2(spo),
        .data3(counter_out),
        .data4(Addr_out),
        .data5(Data_out),
        .data6(data4bus),
        .data7(PC_out),
        //output
        .point_out(point_out),
        .LE_out(LE_out),
        .Disp_num(Disp_num)
    );

    SSeg7 U6(
        //input
        .clk(clk),
        .rst(rst),
        .SW0(SW_out[0]),
        .flash(Div[10]),
        .Hexs(Disp_num),
        .point(point_out),
        .LES(LE_out),
        //output
        .seg_an(seg_an),
        .seg_sout(seg_sout)
    );


    SPIO U7(
        //input
        .clk(IO_clk),
        .rst(rst),
        .EN(GPIOf0_we),
        .P_Data(Peripheral_in),
        //output
        .counter_set(counter_set),
        .LED_out(led_out),
        .led(led),
        .GPIOf0()
    );

    clk_div U8(
        //input
        .clk(clk),
        .rst(rst),
        .SW2(SW_out[2]),
        //output
        .clkdiv(Div), 
        .Clk_CPU(Clk_CPU)
    );
                        
    Counter_x U9(
        //input
        .clk(IO_clk),
        .rst(rst),
        .clk0(Div[6]),
        .clk1(Div[9]),
        .clk2(Div[11]),
        .counter_we(counter_we),
        .counter_val(Peripheral_in),
        .counter_ch(counter_set),
        //output
        .counter0_OUT(counter0_out),
        .counter1_OUT(counter1_out),
        .counter2_OUT(counter2_out),
        .counter_out(counter_out)
    );

    Enter U10(
        //input
        .clk(clk),
        .BTN(btn_i),
        //.SW(sw_i_IBUF),
        .SW(sw_i),
        //.SW({sw_i[15:8],sw_i[7:5],sw_i[4:0]}),
        //output
        .BTN_out(BTN_out),
        .SW_out(SW_out)
    );

assign disp_an_o = seg_an;
assign disp_seg_o = seg_sout;
assign led_o = led;

endmodule
