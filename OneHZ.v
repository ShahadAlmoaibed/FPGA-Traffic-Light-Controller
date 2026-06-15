`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:44:01 12/06/2025 
// Design Name: 
// Module Name:    OneHZ 
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
module OneHZ (input clk, reset, output clk1hz);

 reg [26:0] counter; //27-bit counter because 100000000 fits in 27 bits
 assign clk1hz = (counter == 27'h5f5e0ff);  //Create 1-second pulse from 100 MHz clock
 
//Counting logic:
 always @(posedge clk) begin 
 
 if (reset || clk1hz) //When reset is pressed or clk1hz, restart 
      counter <= 0;  //Restart counting
   else
      counter <= counter + 1;   //Count up every 10ns
   end
endmodule
