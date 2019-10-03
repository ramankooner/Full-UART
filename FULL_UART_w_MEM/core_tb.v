`timescale 1ns / 1ps
//****************************************************************// 
//  File name: core_tb.v                                          // 
//                                                                // 
//  Created by       Raman Kooner on April 1st, 2019.             // 
//  Copyright © 2019 Raman Kooner. All rights reserved.           // 
//                                                                // 
//                                                                // 
//  In submitting this file for class work at CSULB               // 
//  I am confirming that this is my work and the work             // 
//  of no one else. In submitting this code I acknowledge that    // 
//  plagiarism in student project work is subject to dismissal.   //  
//  from the class                                                // 
//****************************************************************//
module core_tb;

	// Inputs
	reg clk;
	reg reset;
	reg RX;
	reg [7:0] SWITCH;

	// Outputs
	wire TX;
	wire [15:0] LED;

	// Instantiate the Unit Under Test (UUT)
	core uut (
		.clk(clk), 
		.reset(reset), 
		.TX(TX), 
		.LED(LED), 
		.RX(RX), 
		.SWITCH(SWITCH)
	);

	always #5
		clk = ~clk;

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		RX = 0;
		SWITCH = 0;
	
		@(negedge clk)
			reset = 1;
		@(negedge clk)
			reset = 0;
			
		// Wait 100 ns for global reset to finish
		#1085;
      
		uut.u4.addra = 15'h0001;
		uut.u4.dina = 16'hAAAA;
		uut.u4.wea = 1;
		
		#1085;
      
		uut.u4.addra = 15'h0002;
		uut.u4.dina = 16'h5555;
		uut.u4.wea = 1;
		
		#1085;
      
		uut.u4.addra = 15'h0003;
		uut.u4.dina = 16'hCCCC;
		uut.u4.wea = 1;
		
		#1085;
      
		uut.u4.addra = 15'h0004;
		uut.u4.dina = 16'h3333;
		uut.u4.wea = 1;
		
		#1085;
      
		uut.u4.addra = 15'h0005;
		uut.u4.dina = 16'h1111;
		uut.u4.wea = 1;
		
		$stop;

	end
      
endmodule

