`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/01/01 17:19:49
// Design Name: 
// Module Name: ov2640_top
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


module ov_top (
/*   摄像头接口  */
    output SIOC_OV,     //sccb时钟
    inout SIOD_OV,   //sccb双向数据
    //控制图像数据传输的3个信号
    input HREF_OV,    //行有效
    input VSYNC_OV,    //场同步
    input PCLK_OV,     //像素时钟
    input [7:0] OV_Data_in,    //图数据
    output XCLK_OV,
    output RST_OV,    //复位
    output PWDN_OV,   //
/**********数码管**************/
    output [6:0] display_7,
/*******VGA接口**********/
    output VSYNC_V,   //行同步信号
    output HSYNC_V,   //列同步信号
    output [3:0]RED_V,
    output [3:0]GREEN_V,
    output [3:0]BLUE_V,     //rgb像素数据
 /*******时钟**********/   
    input clk_100mhz,     //总时钟e3=100mhz
 /*******复位信号**********/ 
    input rst    //高电平有效
);
      wire clk_25mhz;            //初始化寄存器的时钟，25mhz
 wire clk_24mhz;            //vga时钟 24mhz
     

 clk_wiz_0 div(.clk_in(clk),.clk_out1(clk_24mhz),.clk_out2(clk_25mhz));

/*     摄像头初始化     */
 ov_init init(.clk(clk_25mhz),.SIOC_OV(SIOC_OV),.SIOD_OV(SIOD_OV),
 .RST_OV(RST_OV),.rst(rst),.PWDN_OV(PWDN_OV),.XCLK_OV(XCLK_OV));

 wire [18:0] w_addr;            //写地址
 wire [11:0] w_data;            //写数据
 wire  wr_en;                   //缓存写有效


 ov_pic get_pic(.rst(rst),.PCLK_OV(PCLK_OV),.HREF_OV(HREF_OV),.VSYNC_OV(VSYNC_OV)
 ,.OV_Data_in(OV_Data_in),.OV_Data_out(w_data),.wr_en(wr_en),.r_addr(w_addr));

 wire [11:0]   r_data;           //读数据
 wire [18:0]   r_addr;           //读地址

//blk_mem_gen_0 SDRM(.clka(clk_100mhz),.ena(1),.wea(wr_en),.addra(w_addr),.dina(w_data),.clkb(clk_100mhz)
//,.enb(1),.addrb(r_addr),.doutb(r_data));

 wire [11:0]r_data;           //处理后的数据信号

 //deal_pic deal(.clk(clk_100mhz),.in_rgb(r_data),.oper(out_bluetooth),.out_rgb(r_data));
 blk_mem_gen_0 sdram(.clka(clk),.ena(1),.wea(wr_en),.addra(w_addr),.dina(w_data),.clkb(clk),.enb(1),.addrb(r_addr),.doutb(r_data));
 
 vga_init vga(.clk_V(clk_24mhz),.rst(rst),.pic_data_in(r_data),.ram_addr(r_addr)
 ,.VSYNC_V(VSYNC_V),.HSYNC_V(HSYNC_V),.RED_V(RED_V),.GREEN_V(GREEN_V),.BLUE_V(BLUE_V));
    
endmodule
