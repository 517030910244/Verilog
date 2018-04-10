`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:14:05 04/03/2018 
// Design Name: 
// Module Name:    timer 
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

module bcd_digit (
	 input [4:0] modulus,
    input clock,
    input carry_in,
    input reset,
    output reg [7:0] digit,
    output carry_out
    );

    // �ж��Ƿ���Ҫ��λ
    assign carry_out = carry_in && (digit == modulus - 1);

    always @ ( posedge clock )
        if ( reset )
            digit <= 8'b0;
        else if ( carry_in )
            digit <= ( digit < 0 || digit >= modulus ) ? 0 : (carry_out ? 0 : (digit + 1));

endmodule

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


module timer (
    output [7:0] min_1, // �����������ʮλ��
    output [7:0] min_2, // �������������λ��
    output [7:0] sec_1, // �����������ʮλ��
    output [7:0] sec_2, // �������������λ��
    output [7:0] usec,  // ����ٺ���
    input reset,        // ���� SW3 ��λ�ź�
    input clock         // 50MHz ϵͳʱ���ź�
    );

    // 10Hz ʱ���źŲ���ģ�����ʵ��
    wire p_clk10Hz;
    clock_div m_clkgen( .clk_10Hz(p_clk10Hz), .clk(clock) );

    wire [7:0] timer_0;     // ��¼ÿһλ���ʱ�����ֵ
    wire [7:0] timer_1;     // ��¼ÿһλ���ʱ�����ֵ
    wire [7:0] timer_2;     // ��¼ÿһλ���ʱ�����ֵ
    wire [7:0] timer_3;     // ��¼ÿһλ���ʱ�����ֵ
    wire [7:0] timer_4;     // ��¼ÿһλ���ʱ�����ֵ
    wire [7:0] temp_0;
    wire [7:0] temp_1;
    wire [7:0] temp_2;
    wire [7:0] temp_3;
    wire [7:0] temp_4;
    wire [5:0] carry;           // ��λ�Ĵ���

    assign carry[0] = 1'b1;
    parameter modulus_0 = 4'd10;
    parameter modulus_1 = 4'd10;
    parameter modulus_2 = 4'd6;
    parameter modulus_3 = 4'd10;
    parameter modulus_4 = 4'd6;

    bcd_digit m_bcd_digit_0 ( .modulus(modulus_0), .clock(p_clk10Hz), .reset(reset), .digit(timer_0), .carry_in(carry[0]), .carry_out(carry[1]) );
    bcd_digit m_bcd_digit_1 ( .modulus(modulus_1), .clock(p_clk10Hz), .reset(reset), .digit(timer_1), .carry_in(carry[1]), .carry_out(carry[2]) );
    bcd_digit m_bcd_digit_2 ( .modulus(modulus_2), .clock(p_clk10Hz), .reset(reset), .digit(timer_2), .carry_in(carry[2]), .carry_out(carry[3]) );
    bcd_digit m_bcd_digit_3 ( .modulus(modulus_3), .clock(p_clk10Hz), .reset(reset), .digit(timer_3), .carry_in(carry[3]), .carry_out(carry[4]) );
    bcd_digit m_bcd_digit_4 ( .modulus(modulus_4), .clock(p_clk10Hz), .reset(reset), .digit(timer_4), .carry_in(carry[4]), .carry_out(carry[5]) );

    // ���ֱ���� 48(dec) ��ʼ = 11_0000(bin)
    assign temp_4 = timer_4 + 8'b0011_0000;
    assign temp_3 = timer_3 + 8'b0011_0000;
    assign temp_2 = timer_2 + 8'b0011_0000;
    assign temp_1 = timer_1 + 8'b0011_0000;
    assign temp_0 = timer_0 + 8'b0011_0000;

    assign usec = temp_0;
    assign sec_2 = temp_1;
    assign sec_1 = temp_2;
    assign min_2 = temp_3;
    assign min_1 = temp_4;

endmodule // timer
