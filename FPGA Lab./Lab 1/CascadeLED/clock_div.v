`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:00:12 03/13/2018 
// Design Name: 
// Module Name:    clock_dic 
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
    output reg clk_1Hz = 1'b0,  // 1Hzʱ������ź�
    input clk               	// ϵͳʱ�������ź�
    );

    parameter PULSESCOUNT = 25'h17D_7840; // = 1_0111_1101_0111_1000_0100_0000(bin) (25bits)
    parameter RESETZERO = 25'h0;

    reg [24:0] counter; // ������, 25 bits (1_0111_1101_0111_1000_0100_0000(bin))
                        // ���ڶ�ϵͳʱ��������м���, �Բ��� 1Hz ���ʱ���ź�

    always @( posedge clk ) begin       // -- �� clock �źŵ������ش���
        if ( counter < PULSESCOUNT )    // -- 25'h17D_7840 ��ϵͳʱ��������� 1/2(s)
            counter <= counter + 1'b1;
        else begin
            clk_1Hz <= ~clk_1Hz;
            counter <= RESETZERO;
        end
    end

endmodule
