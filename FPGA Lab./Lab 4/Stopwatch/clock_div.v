`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:15:50 04/03/2018 
// Design Name: 
// Module Name:    clock_div 
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
module clock_div(
    output reg clk_10Hz,     // 10Hzʱ������ź�
    input clk               // ϵͳʱ�������ź�
    );

    parameter PULSESCOUNT = 22'h26_25a0;    // = 10_0110_0010_0101_1010_0000(bin) (22bits)
    parameter RESETZERO = 22'h0;

    reg [21:0] counter; // ������, 22 bits (10_0110_0010_0101_1010_0000(bin))
                        // ���ڶ�ϵͳʱ��������м���, �Բ��� 10Hz ���ʱ���ź�

    always @( posedge clk ) begin       // -- �� clock �źŵ������ش���
        if ( counter < PULSESCOUNT )    // -- 22'h2625a0 ��ϵͳʱ��������� 1/20(s)
            counter <= counter + 1'b1;
        else begin
            clk_10Hz <= ~clk_10Hz;
            counter <= RESETZERO;
        end
    end

endmodule
