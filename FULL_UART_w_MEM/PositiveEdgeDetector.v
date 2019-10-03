`timescale 1ns / 1ps
//****************************************************************// 
//  File name: PositiveEdgeDetector.v                             // 
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

module PositiveEdgeDetect(clk, reset, db, ped);

	input  clk, reset, db; 
	
	output ped; 
	
	reg    Q1, Q2;
	
	always @(posedge clk, posedge reset)
		if(reset)
			{Q1, Q2} <= 2'b0;
		else
			{Q1, Q2} <= {db, Q1};
	
	assign ped = ~Q2 & Q1;


endmodule
