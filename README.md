# Digital-Clock
This repository includes use of VHDL for describing design of a digital clock. The design is done keeping in view the inputs and outputs provided by a specific type of FPGA board that is commonly used in various Labs. This is one of assignments of the course- Digital Logic and System Design that I took in IIT Delhi during Sep 2020 to Jan 2021.

The design work with the following inputs and outputs provided by the BASYS3 FPGA board.
1. 4 seven-segment displays, each one can display a digit, optionally with a decimal point
2. 5 push-button switches are available, but try to use as few as possible, keeping in mind convenience of the user
3. A 10 MHz clock signal

There are two display modes- HH:MM and MM:SS. To set the time, two push-buttons are used to increase and decrease time respectively. There is also an option of fast increment and fast decrement if the respective buttons are pressed for a long duration.
