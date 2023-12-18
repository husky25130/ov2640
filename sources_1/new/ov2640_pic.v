`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/01/06 15:27:02
// Design Name: 
// Module Name: ov2640_pic
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


module ov_pic (
    input rst,
    input PCLK_OV,
    input HREF_OV,
    input VSYNC_OV,
    input [7:0]OV_Data_in,       //摄像头D[9]到D[2]
    output reg[11:0]OV_Data_out, //像素点的数据
    output reg wr_en,            //写有效使能
    output reg[18:0]r_addr=0     //缓存地址
);
    reg [1:0] judge = 0;         //rgb控制信息
    reg [15:0] RGB = 0;     //16位rgb565信息
    reg  [18:0] next_addr = 0;

    
    
    always@ (posedge PCLK_OV)
        begin
        if(VSYNC_OV == 0)//高电平有效
            begin
                r_addr <=0;
                next_addr <= 0;
                judge=0;
            end
        else
            begin
                OV_Data_out <= {RGB[15:12],RGB[10:7],RGB[4:1]};    //16位截成12位 4位一个颜色
                r_addr <= next_addr;
                wr_en <= judge[1];
                judge <= {judge[0], (HREF_OV && !judge[0])};//都是高电平有效
                RGB <= {RGB[7:0], OV_Data_in};
                    
                if(judge[1] == 1)
                    begin
                        next_addr <= next_addr+1;
                    end
                end
        end
endmodule
