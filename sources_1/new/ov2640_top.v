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
/*   ����ͷ�ӿ�  */
    output SIOC_OV,     //sccbʱ��
    inout SIOD_OV,   //sccb˫������
    //����ͼ�����ݴ����3���ź�
    input HREF_OV,    //����Ч
    input VSYNC_OV,    //��ͬ��
    input PCLK_OV,     //����ʱ��
    input [7:0] OV_Data_in,    //ͼ����
    output XCLK_OV,
    output RST_OV,    //��λ
    output PWDN_OV,   //
/**********�����**************/
    output [6:0] display_7,
/*******VGA�ӿ�**********/
    output VSYNC_V,   //��ͬ���ź�
    output HSYNC_V,   //��ͬ���ź�
    output [3:0]RED_V,
    output [3:0]GREEN_V,
    output [3:0]BLUE_V,     //rgb��������
 /*******ʱ��**********/   
    input clk_100mhz,     //��ʱ��e3=100mhz
 /*******��λ�ź�**********/ 
    input rst    //�ߵ�ƽ��Ч
);
      wire clk_25mhz;            //��ʼ���Ĵ�����ʱ�ӣ�25mhz
 wire clk_24mhz;            //vgaʱ�� 24mhz
     

 clk_wiz_0 div(.clk_in(clk),.clk_out1(clk_24mhz),.clk_out2(clk_25mhz));

/*     ����ͷ��ʼ��     */
 ov_init init(.clk(clk_25mhz),.SIOC_OV(SIOC_OV),.SIOD_OV(SIOD_OV),
 .RST_OV(RST_OV),.rst(rst),.PWDN_OV(PWDN_OV),.XCLK_OV(XCLK_OV));

 wire [18:0] w_addr;            //д��ַ
 wire [11:0] w_data;            //д����
 wire  wr_en;                   //����д��Ч


 ov_pic get_pic(.rst(rst),.PCLK_OV(PCLK_OV),.HREF_OV(HREF_OV),.VSYNC_OV(VSYNC_OV)
 ,.OV_Data_in(OV_Data_in),.OV_Data_out(w_data),.wr_en(wr_en),.r_addr(w_addr));

 wire [11:0]   r_data;           //������
 wire [18:0]   r_addr;           //����ַ

//blk_mem_gen_0 SDRM(.clka(clk_100mhz),.ena(1),.wea(wr_en),.addra(w_addr),.dina(w_data),.clkb(clk_100mhz)
//,.enb(1),.addrb(r_addr),.doutb(r_data));

 wire [11:0]r_data;           //�����������ź�

 //deal_pic deal(.clk(clk_100mhz),.in_rgb(r_data),.oper(out_bluetooth),.out_rgb(r_data));
 blk_mem_gen_0 sdram(.clka(clk),.ena(1),.wea(wr_en),.addra(w_addr),.dina(w_data),.clkb(clk),.enb(1),.addrb(r_addr),.doutb(r_data));
 
 vga_init vga(.clk_V(clk_24mhz),.rst(rst),.pic_data_in(r_data),.ram_addr(r_addr)
 ,.VSYNC_V(VSYNC_V),.HSYNC_V(HSYNC_V),.RED_V(RED_V),.GREEN_V(GREEN_V),.BLUE_V(BLUE_V));
    
endmodule
