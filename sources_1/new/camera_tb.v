`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/01/06 16:25:31
// Design Name: 
// Module Name: camera_tb
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


module camera_tb;
/*   摄像头接口  */
    reg SIOC_OV;     //sccb时钟
   wire SIOD_OV;   //sccb双向数据
    //控制图像数据传输的3个信号
    reg HREF_OV;    //行有效
    reg VSYNC_OV;    //场同步
    reg PCLK_OV;     //像素时钟
    reg [7:0] OV_Data_in;    //图数据
    wire XCLK_OV;
    wire RST_OV;    //复位
    wire PWDN_OV;   //
/**********数码管**************/
    wire [6:0] display_7;
/*******VGA接口**********/
    wire VSYNC_V;   //行同步信号
    wire HSYNC_V;   //列同步信号
    wire [3:0]RED_V;
    wire [3:0]GREEN_V;
    wire [3:0]BLUE_V;     //rgb像素数据
 /*******时钟**********/   
    reg clk_100mhz;     //总时钟e3=100mhz
 /*******复位信号**********/ 
    reg rst;    //高电平有效
    
   ov2640_top uut(.SIOC_OV(SIOC_OV),.SIOD_OV(SIOD_OV),.HREF_OV(HREF_OV),.PCLK_OV(PCLK_OV),.OV_Data_in(OV_Data_in),
    .XCLK_OV(XCLK_OV),.RST_OV(RST_OV),.PWDN_OV(PWDN_OV),.display_7(display_7),.VSYNC_V(VSYNC_V),.HSYNC_V(HSYNC_V),
    .RED_V(RED_V),.GREEN_V(GREEN_V),.BLUE_V(BLUE_V),.clk_100mhz(clk_100mhz),.rst(rst));
    
   always@(*)
   begin
   
   #5 clk_100mhz = ~clk_100mhz;
   
   end
endmodule
