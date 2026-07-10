# FPGA Traffic Light Controller

## Course
Digital Logic Laboratory

## Description
Designed and implemented an FPGA-based traffic light controller with pedestrian crossing support using Verilog and Xilinx ISE Design Suite. The system includes a real-time countdown displayed on a seven-segment display and was verified through simulation and tested on the Nexys-A7 FPGA board.

## Simulation
The controller was simulated to verify traffic light sequencing, pedestrian crossing requests, and countdown timing behavior.

![Controller Simulation](controller_simulation.jpg)

## Project Type
Team project (2 students)

## Technologies
- Verilog
- Xilinx ISE Design Suite
- Nexys-A7 FPGA Board
- Digital Logic Design

## Features
- Three-road traffic light control.
- Pedestrian crossing request handling.
- Priority-based traffic sequencing.
- Seven-segment display countdown timer.
- Implemented and tested on the Nexys-A7 FPGA board.
- Verified through simulation.

## Files
- Verilog source files
- Xilinx ISE project (.xise)
- Controller simulation screenshot

## How to Open
1. Open the project using Xilinx ISE Design Suite.
2. Load the provided .xise project file.
3. Synthesize and implement the design.
4. Run the simulation or generate the bitstream to program the Nexys-A7 FPGA board.

## Hardware Features
- LED outputs display the traffic light states.
- Seven-segment display shows the countdown timer for the active traffic signal.
- Push button input for Pedestrian crossing requests.
