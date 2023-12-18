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
/*   ����ͷ�ӿ�  */
    reg SIOC_OV;     //sccbʱ��
   wire SIOD_OV;   //sccb˫������
    //����ͼ�����ݴ����3���ź�
    reg HREF_OV;    //����Ч
    reg VSYNC_OV;    //��ͬ��
    reg PCLK_OV;     //����ʱ��
    reg [7:0] OV_Data_in;    //ͼ����
    wire XCLK_OV;
    wire RST_OV;    //��λ
    wire PWDN_OV;   //
/**********�����**************/
    wire [6:0] display_7;
/*******VGA�ӿ�**********/
    wire VSYNC_V;   //��ͬ���ź�
    wire HSYNC_V;   //��ͬ���ź�
    wire [3:0]RED_V;
    wire [3:0]GREEN_V;
    wire [3:0]BLUE_V;     //rgb��������
 /*******ʱ��**********/   
    reg clk_100mhz;     //��ʱ��e3=100mhz
 /*******��λ�ź�**********/ 
    reg rst;    //�ߵ�ƽ��Ч
    
   ov2640_top uut(.SIOC_OV(SIOC_OV),.SIOD_OV(SIOD_OV),.HREF_OV(HREF_OV),.PCLK_OV(PCLK_OV),.OV_Data_in(OV_Data_in),
    .XCLK_OV(XCLK_OV),.RST_OV(RST_OV),.PWDN_OV(PWDN_OV),.display_7(display_7),.VSYNC_V(VSYNC_V),.HSYNC_V(HSYNC_V),
    .RED_V(RED_V),.GREEN_V(GREEN_V),.BLUE_V(BLUE_V),.clk_100mhz(clk_100mhz),.rst(rst));
    
   always@(*)
   begin
   
   #5 clk_100mhz = ~clk_100mhz;
   
   end
endmodule
