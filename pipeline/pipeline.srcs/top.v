`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:57:47 06/21/2022 
// Design Name: 
// Module Name:    IP2SOC_TOP 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module IP2SOC_TOP(
    input RSTN,
    input [3:0] BTN_y,
    input [15:0] SW,
    input clk_100mhz,
    output CR,
    output seg_clk,
    output seg_sout,
    output SEG_PEN,
    output seg_clrn,
    output led_clk,
    output led_sout,
    output LED_PEN,
    output led_clrn,
    output RDY,
    output readn,
    output [4:0] BTN_x
);

    wire rst;
    wire Clk_CPU,IO_clk;
    assign IO_clk=~Clk_CPU;

    wire [31:0] inst,PC;

    wire mem_w;
    wire [3:0] wea;
    wire [9:0] ram_addr;
    wire [31:0] Data_in,Data_out,Addr_out,ram_data_in,ram_data_out;
	 
    wire GPIOf0,GPIOe0;
    wire [3:0] BTN_OK;
    wire [15:0] SW_OK,led_out;
    wire [4:0] Key_out;  
    wire [7:0] point_out,LE_out;
    wire [31:0] Div,Disp_num;
    wire [31:0] CPU2IO;
    wire counter0_out,counter1_out,counter2_out,counter_we;
    wire [1:0] counter_ch; 
    wire [31:0] counter_out;
    
    wire [3:0] Pulse;
    wire [31:0] Ai,Bi;
    wire [7:0] blink;

    PipeCPU U1(
        //input
        .clk(Clk_CPU),
        .reset(rst),
        .inst_in(inst),
        .INT(counter0_out),
        .Data_in(Data_in),
        .MIO_ready(),
        //output
        .PC_out(PC),
        .mem_w(mem_w),
        .wea(wea),
        .Addr_out(Addr_out),
        .Data_out(Data_out),
        .CPU_MIO()
        
    );

    ROM_D U2(
        //input
        .a(PC[11:2]),
        //output
        .spo(inst)
    );

    RAM_B U3(
        //input
        .clka(~Clk_CPU),
        .wea(wea),
        .addra(ram_addr),
        .dina(ram_data_in),
        //output
        .douta(ram_data_out)
    );

    MIO_BUS U4(
        //input
        .clk(clk_100mhz),
        .rst(rst),
        .BTN(BTN_OK),
        .SW(SW_OK),
        .mem_w(mem_w),
        .addr_bus(Addr_out),
        .ram_data_out(ram_data_out),
        .Cpu_data2bus(Data_out),
        .led_out(led_out),
        .counter_out(counter_out),
        .counter0_out(counter0_out),
        .counter1_out(counter1_out),
        .counter2_out(counter2_out),
        //output
        .data_ram_we(),
        .ram_addr(ram_addr),
        .ram_data_in(ram_data_in),
        .Cpu_data4bus(Data_in),
        .counter_we(counter_we),
        .GPIOf0000000_we(GPIOf0),
        .GPIOe0000000_we(GPIOe0),
        .Peripheral_in(CPU2IO)
    );

    Multi_8CH32 U5(
        //input
        .clk(IO_clk),
        .rst(rst),
        .EN(GPIOe0),
        .Test(SW_OK[7:5]),
        .point_in({Div[31:0],Div[31:0]}),
        .LES(64'b0),
        .Data0(CPU2IO),
        .data1({2'b0,PC[31:2]}),
        .data2(inst),
        .data3(counter_out),
        .data4(Addr_out),
        .data5(Data_out),
        .data6(Data_in),
        .data7(PC),
        //output
        .point_out(point_out),
        .LE_out(LE_out),
        .Disp_num(Disp_num)
    );

    SSeg7_Dev U6(
        //input
        .clk(clk_100mhz),
        .rst(rst),
        .Start(Div[20]),
        .SW0(SW_OK[0]),
        .flash(Div[25]),
        .Hexs(Disp_num),
        .point(point_out),
        .LES(LE_out),
        //output
        .seg_clk(seg_clk),
        .seg_sout(seg_sout),
        .SEG_PEN(SEG_PEN),
        .seg_clrn(seg_clrn)
    );


    SPIO U7(
        //input
        .clk(IO_clk),
        .rst(rst),
        .Start(Div[20]),
        .EN(GPIOf0),
        .P_Data(CPU2IO),
        //output
        .counter_set(counter_ch),
        .LED_out(led_out),
        .led_clk(led_clk),
        .led_sout(led_sout),
        .led_clrn(led_clrn),
        .LED_PEN(LED_PEN),
        .GPIOf0()
    );

    clk_div U8(
        //input
        .clk(clk_100mhz),
        .rst(rst),
        .SW2(SW_OK[2]),
        //output
        .clkdiv(Div), 
        .Clk_CPU(Clk_CPU)
    );
                        
    SAnti_jitter U9(
        //input
        .clk(clk_100mhz),
        .RSTN(RSTN),
        .readn(readn),
        .Key_y(BTN_y),
        .SW(SW),
        //output
        .Key_x(BTN_x),
        .Key_out(Key_out),
        .Key_ready(RDY),
        .pulse_out(Pulse),
        .BTN_OK(BTN_OK),
        .SW_OK(SW_OK),
        .CR(CR),
        .rst(rst)
    ); 

    Counter_x U10(
        //input
        .clk(IO_clk),
        .rst(rst),
        .clk0(Div[6]),
        .clk1(Div[9]),
        .clk2(Div[11]),
        .counter_we(counter_we),
        .counter_val(CPU2IO),
        .counter_ch(counter_ch),
        //output
        .counter0_OUT(counter0_out),
        .counter1_OUT(counter1_out),
        .counter2_OUT(counter2_out),
        .counter_out(counter_out)
    );

    SEnter_2_32 M4(
        //input
        .clk(clk_100mhz),
        .BTN(BTN_OK[2:0]),
        .Ctrl({SW_OK[7:5],SW_OK[15],SW_OK[0]}),
        .D_ready(RDY),
        .Din(Key_out),
        //output
        .readn(readn),
        .Ai(Ai),
        .Bi(Bi),
        .blink(blink)
    );
endmodule
