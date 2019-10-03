`timescale 1ns / 1ps
//****************************************************************// 
//  File name: UART_tb.v                                          // 
//                                                                // 
//  Created by       Raman Kooner on February 1st, 2019.          // 
//  Copyright © 2019 Raman Kooner. All rights reserved.           // 
//                                                                // 
//                                                                // 
//  In submitting this file for class work at CSULB               // 
//  I am confirming that this is my work and the work             // 
//  of no one else. In submitting this code I acknowledge that    // 
//  plagiarism in student project work is subject to dismissal.   //  
//  from the class                                                // 
//****************************************************************//
module UART_tb;

	// Inputs
	reg clk;
	reg reset;
	reg [7:0] OUT_PORT;
	reg WRITE2;
	reg WRITE0;
	reg [2:0] READ;
	reg RX;
	reg [7:0] SWITCH;
	reg INT_ACK;

	// Outputs
	wire [7:0] IN_PORT;
	wire INTERRUPT;
	wire TX;

	// Instantiate the Unit Under Test (UUT)
	UART uut (
		.clk(clk), 
		.reset(reset), 
		.OUT_PORT(OUT_PORT), 
		.WRITE2(WRITE2), 
		.WRITE0(WRITE0), 
		.READ(READ), 
		.RX(RX), 
		.SWITCH(SWITCH), 
		.IN_PORT(IN_PORT), 
		.INTERRUPT(INTERRUPT), 
		.INT_ACK(INT_ACK), 
		.TX(TX)
	);

	always #5
		clk = ~clk;
		
	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		OUT_PORT = 8'b1001_1100;
		WRITE2 = 0;
		WRITE0 = 0;
		READ = 0;
		RX = 1;
		SWITCH = 0;
		INT_ACK = 0;

		@(negedge clk)
			reset = 1;
		@(negedge clk)
			reset = 0;

		// START
		RX = 0;
		
		// d0
		#1085
		RX = 1;
		
		// d1
		#1085
		RX = 1;
		
		// d2
		#1085
		RX = 0;
		
		// d3
		#1085
		RX = 0;
		
		// d4
		#1085 
		RX = 1;
		
		// d5
		#1085
		RX = 0;
		
		// d6
		#1085
		RX = 0;
		
		// d7
		#1085
		RX = 1;
		
		// parity
		#1085
		RX = 0;
		
		// stop
		#1085
		RX = 1;
		
		#1085
		$stop;
		

	end
      
endmodule

