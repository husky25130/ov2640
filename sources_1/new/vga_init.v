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
    input clk_V,                  //输入vga的时钟，频率为25.175MHz
    input rst,                    //复位信号，高电平有效
    input [11:0] pic_data_in,     //从RAM中读取的像素信息
    output reg[18:0] ram_addr,    //读取的RAM的图片地址
    output VSYNC_V,              //行同步信号
    output HSYNC_V,              //列同步信号
    output reg [3:0]RED_V,
    output reg [3:0]GREEN_V,
    output reg [3:0]BLUE_V       //rgb像素数据
);

    
   // parameter x_low=11'd144;//实际显示行像素最低处
   // parameter y_low=11'd35;//实际显示列像素最低处
    parameter x_max_pic=11'd640;//行实际最大像素
    parameter y_max_pic=11'd480;//列实际最大像素
    
    reg [10:0] pic_x;  //输出此时x的坐标
    reg [10:0] pic_y;  //输出此时y的坐标
    wire isDisplay;     //表征此时是否能够输出

   // vga_control control(clk_vga,rst,pic_x,pic_y,isDisplay,VSYNC_V,HSYNC_V);
 
    //行参数
    parameter x_sync=11'd96;//行同步像素时序范围
    parameter x_low=11'd144;//实际显示行像素最低处
    parameter x_high=11'd784;//实际显示行像素最高处
    parameter x_max=11'd800;//行实际最大像素
    //列参数
    parameter y_sync=11'd2;//列同步像素时序范围
    parameter y_low=11'd35;//实际显示列像素最低处
    parameter y_high=11'd515;//实际显示列像素最高处
    parameter y_max=11'd525;//列实际最大像素
    //
    assign isDisplay=((pic_x>=x_low)&&(pic_x<x_high)&&(pic_y>=y_low)&&(pic_y<y_high))?1:0;
    
    assign VSYNC_V=(pic_x<x_sync)?0:1;           //行同步信号拉低时段
    assign HSYNC_V=(pic_y<y_sync)?0:1;           //场同步信号拉低时段
    
    always @ (posedge clk_V)//判断此时是否可以进行绘制图像
    begin
        if(rst)//清零信号
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
