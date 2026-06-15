`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:43:40 12/06/2025 
// Design Name: 
// Module Name:    Main 
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
module Main (input clk, reset, enable, p1_btn, 
  output s1, s1_red, s2, s2_red, s3, s3_red, p1, p1_red,
  output [7:0] seg, an);

  wire clk1hz;
  wire [3:0] remaining_time;

  OneHZ U0 (clk, reset, clk1hz);   //Generate 1Hz pulse from system clock

  controller U1 (clk, reset, enable, clk1hz, p1_btn,  
                    s1, s2, s3, p1,
        s1_red, s2_red, s3_red, p1_red,
                    remaining_time); //Traffic + Pedestrian controller FSM
  
  
   wire [3:0] D7, D6, D5, D4, D3, D2, D1, D0 ; //4-bit values for 8 digits of 7-segment driver
 
   assign D0 = s1 ? remaining_time : 4'd0; //S1 time when it’s green
 assign D1 = 4'd0;  //Unused digit
 assign D2 = s2 ? remaining_time : 4'd0; //S2 time when it’s green
 assign D3 = 4'd0; //Unused digit
 assign D4 = s3 ? remaining_time : 4'd0; //S3 time when it’s green
 assign D5 = 4'd0; //Unused digit
 assign D6 = p1 ? remaining_time : 4'd0; //P1 time when it’s green
 assign D7 = 4'd0; //Unused digit
 
 DISP7SEG U2 (clk, D0, D1, D2, D3, D4, D5, D6, D7, text_mode, slow, med, fast, error, seg, an); //Seven-segment driver to show in board 
 
 
endmodule
