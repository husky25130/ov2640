`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/01/06 14:37:39
// Design Name: 
// Module Name: vga_init
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


module vga_init (
    input clk_V,                  //����vga��ʱ�ӣ�Ƶ��Ϊ25.175MHz
    input rst,                    //��λ�źţ��ߵ�ƽ��Ч
    input [11:0] pic_data_in,     //��RAM�ж�ȡ��������Ϣ
    output reg[18:0] ram_addr,    //��ȡ��RAM��ͼƬ��ַ
    output VSYNC_V,              //��ͬ���ź�
    output HSYNC_V,              //��ͬ���ź�
    output reg [3:0]RED_V,
    output reg [3:0]GREEN_V,
    output reg [3:0]BLUE_V       //rgb��������
);

    
   // parameter x_low=11'd144;//ʵ����ʾ��������ʹ�
   // parameter y_low=11'd35;//ʵ����ʾ��������ʹ�
    parameter x_max_pic=11'd640;//��ʵ���������
    parameter y_max_pic=11'd480;//��ʵ���������
    
    reg [10:0] pic_x;  //�����ʱx������
    reg [10:0] pic_y;  //�����ʱy������
    wire isDisplay;     //������ʱ�Ƿ��ܹ����

   // vga_control control(clk_vga,rst,pic_x,pic_y,isDisplay,VSYNC_V,HSYNC_V);
 
    //�в���
    parameter x_sync=11'd96;//��ͬ������ʱ��Χ
    parameter x_low=11'd144;//ʵ����ʾ��������ʹ�
    parameter x_high=11'd784;//ʵ����ʾ��������ߴ�
    parameter x_max=11'd800;//��ʵ���������
    //�в���
    parameter y_sync=11'd2;//��ͬ������ʱ��Χ
    parameter y_low=11'd35;//ʵ����ʾ��������ʹ�
    parameter y_high=11'd515;//ʵ����ʾ��������ߴ�
    parameter y_max=11'd525;//��ʵ���������
    //
    assign isDisplay=((pic_x>=x_low)&&(pic_x<x_high)&&(pic_y>=y_low)&&(pic_y<y_high))?1:0;
    
    assign VSYNC_V=(pic_x<x_sync)?0:1;           //��ͬ���ź�����ʱ��
    assign HSYNC_V=(pic_y<y_sync)?0:1;           //��ͬ���ź�����ʱ��
    
    always @ (posedge clk_V)//�жϴ�ʱ�Ƿ���Խ��л���ͼ��
    begin
        if(rst)//�����ź�
        begin
            pic_x<=0;
            pic_y<=0;
        end
        else
        begin
            if(pic_x==x_max-1)
            begin
                pic_x<=0;
                if(pic_y==y_max-1)
                begin
                    pic_y<=0;
                end
                else
                begin
                    pic_y<=pic_y+1;
                end
            end
            else
            begin
                pic_x<=pic_x+1;
            end
        end
    end




    always@ (*)
    begin
        RED_V=0;
        BLUE_V=0;
        GREEN_V=0;
        if(isDisplay)
        begin
            if(pic_x-x_low<=x_max_pic&&pic_y-y_low<=y_max_pic)
            begin
            ram_addr=(pic_y-y_low)*x_max_pic+(pic_x-x_low);
            RED_V=pic_data_in[11:8];
            BLUE_V=pic_data_in[3:0];            
            GREEN_V=pic_data_in[7:4];

            end
            else
             begin
              RED_V=0;
              BLUE_V=0;
              GREEN_V=0;

             end
        end
    end

    
endmodule
