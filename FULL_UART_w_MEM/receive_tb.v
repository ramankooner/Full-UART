`timescale 1ns / 1ps
//****************************************************************// 
//  File name: receive_tb.v                                       // 
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
module receive_tb;

	// Inputs
	reg clk;
	reg reset;
	reg [18:0] k;
	reg EIGHT;
	reg PEN;
	reg OHEL;
	reg RX;
	reg READ;

	// Outputs
	wire RX_RDY;
	wire [7:0] RX_DATA;
	wire PERR;
	wire FERR;
	wire OVF;
	
	// Instantiate the Unit Under Test (UUT)
	receive uut (
		.clk(clk), 
		.reset(reset), 
		.k(k), 
		.EIGHT(EIGHT), 
		.PEN(PEN), 
		.OHEL(OHEL), 
		.RX_RDY(RX_RDY), 
		.RX_DATA(RX_DATA), 
		.PERR(PERR), 
		.FERR(FERR), 
		.OVF(OVF), 
		.RX(RX), 
		.READ(READ)
	);
	
	reg [0:0] mem [0:999_999];
	integer i;
	
	always #5
		clk = ~clk;
	
	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		k = 4'b1011;
		EIGHT = 1;
		PEN = 1;
		OHEL = 0;
		RX = 1;
		READ = 0;
		
		
		@(negedge clk)
			reset = 1;
		@(negedge clk)
			reset = 0;
		/*
		$readmemb("output.txt", mem);
		for (i = 0; i < 1_000_000; i = i + 1)
			begin
			#100
			rx = mem[i];
			end
		*/
		
		// START
		reset = 0;
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
		RX = 1;
		
		// stop
		#1085
		RX = 1;
		
		#1085
		$stop;
		
	end
      
endmodule

