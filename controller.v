`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:44:31 12/06/2025 
// Design Name: 
// Module Name:    controller 
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

module controller (input clk, reset, enable, clk1hz, p1_btn,
                   output reg s1, s2, s3, p1,
                   output s1_red, s2_red, s3_red, p1_red,
                   output [3:0] remaining_time);

  reg [1:0] state, next_state;       //Default case of tracking states
  reg [1:0] resume_state, next_resume_state;  //If pedestrian button pressed "To track the sequence and continue"
  reg [3:0] sec_count;     // seconds passed
  reg [3:0] duration;      // total seconds for this state
  reg ped_req;       // pedestrian request 
  wire sec_done;   // Indication that duration is done "when duration = count"
  
  assign sec_done = (sec_count == duration);   //The case is when count = to determined duration meaning it should be done
  assign remaining_time = duration - sec_count;  //Count down for the time 
  
  // red = NOT green //
  assign s1_red = ~s1; 
  assign s2_red = ~s2;
  assign s3_red = ~s3;
  assign p1_red = ~p1;
 
  

  //           STATE AND TIME LOGIC 
  
    always @(posedge clk or posedge reset) //Run once every time the clock rises or immediately if reset = 1
  if (reset) begin               // Reset to default states 
   state <= 2'b00;  //S1
   resume_state <= 2'b01; //S2 in case of P_btn pressed the next state will be 2 by default
   sec_count <= 0;  //Count start from zero
   duration <= 0;  //All duration start with zero 
  end
  
    else if (enable && clk1hz) begin
  if (duration == 0) begin //Start with S1
   duration <= 9;
   sec_count <= 0;
  end
  
  else begin //Normal operation 
   state <= next_state;          //Follow S1?S2?S3
   resume_state <= next_resume_state;   //Save state before P1

      //Load or count time
      if (state != next_state) begin
        sec_count <= 0;
        case (next_state) //Choose the duration with respect to the state now
          2'b00: duration <= 9; //S1
          2'b01: duration <= 5; //S2
          2'b11: duration <= 5; //S3
          2'b10: duration <= 6; //P1
        endcase
      end
  
      else begin
        if (!sec_done) //Counting up
          sec_count <= sec_count + 1;
   end
  end
  end


  //           PEDESTRAIN REQUEST LOGIC 
  
    always @(posedge clk or posedge reset) //Run once every time the clock rises or immediately if reset = 1 "Asynchronous reset"
  if (reset) begin //Default
   ped_req <= 0;
  end
  
    else if (enable) begin
      if (p1_btn)       //If P button preesed 
        ped_req <= 1;              //Store request "High"
      else if (sec_done && clk1hz && state==2'b10)
        ped_req <= 0;           //Clear at end of P1
    end


  //           NEXT-STATE AND OUTPUT LOGIC

    always @(*) begin //Run if any input inside changes "if any case is high it will run"
    s1 = 0; s2 = 0; s3 = 0; p1 = 0;  //All are zero as default state
    next_state = state;
    next_resume_state = resume_state;

    case (state)

      // ROAD 1 GREEN (9 seconds)
      2'b00: begin //S1 = S00 
        s1 = 1;        //Turn on S1 "green"
        if (sec_done) begin     //If duration done it will check if P button pressed
          if (ped_req) begin
            next_state = 2'b10;    //as P pressed it will change to p1 "green"
            next_resume_state = 2'b01; //after P1, continue with S2
          end
          else
            next_state = 2'b01;    //Update next state to S2 if no pedestrain
        end
      end

      // ROAD 2 GREEN (5 seconds)
      2'b01: begin     //S2 = S01 
        s2 = 1;      //Turn on S2 "green"
        if (sec_done) begin  //P1 then S3
          if (ped_req) begin 
            next_state = 2'b10; 
            next_resume_state = 2'b11; 
          end
          else      //S3
            next_state = 2'b11; 
        end
      end

      // ROAD 3 GREEN (5 seconds)
      2'b11: begin     //S3 = S11 
        s3 = 1;      //Turn on S3 "green"
        if (sec_done) begin  //P1 then S1
          if (ped_req) begin next_state = 2'b10;
            next_resume_state = 2'b00;
          end
          else      //S1
            next_state = 2'b00;
        end
      end

      // PEDESTRIAN GREEN (6 seconds)
      2'b10: begin        //P1 = S10 
        p1 = 1;         //Turn on P1 "green"
        if (sec_done)
          next_state = resume_state; //Continue the sequence
      end

    endcase
  end

endmodule

			 