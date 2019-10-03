`timescale 1ns / 1ps
//****************************************************************// 
//  File name: transmit_tb.v                                      // 
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
module transmit_tb;

	// Inputs
	reg clk;
	reg reset;
	reg PEN;
	reg OHEL;
	reg EIGHT;
	reg LOAD;
	reg [7:0] OUT_PORT;
	reg [18:0] BAUD_COUNT;

	// Outputs
	wire TX;
	wire TX_RDY;

	// Instantiate the Unit Under Test (UUT)
	transmit uut (
		.clk(clk), 
		.reset(reset), 
		.PEN(PEN), 
		.OHEL(OHEL), 
		.EIGHT(EIGHT), 
		.LOAD(LOAD), 
		.OUT_PORT(OUT_PORT), 
		.TX(TX), 
		.BAUD_COUNT(BAUD_COUNT), 
		.TX_RDY(TX_RDY)
	);
	
	// Variables for file
	integer f;
	reg     flip;
	time    t;
	
	always #5
		clk = ~clk;
	
	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 1;
		PEN = 0;
		OHEL = 0;
		EIGHT = 0;
		LOAD = 0;
		OUT_PORT = 0;
		BAUD_COUNT = 0;

		f = $fopen("output.txt");
		flip = 0;
		
		#100
		reset = 1'b0;
		#50_000_000
		$fclose(f);
		$finish;
	end
	
	always #t
		begin
		flip = !flip;
		$fwrite(f, TX, " ");
		end
      
endmodule

