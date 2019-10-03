`timescale 1ns / 1ps
//****************************************************************// 
//  File name: SR_Flop.v                                          // 
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
module SR_Flop(clk, reset, r, s, Q);

	input  reset, r, s, clk;
	output Q;
	reg    Q;
	
	always @(posedge clk, posedge reset)
		if(reset)
			Q <= 1'b0;
      else if(s)       
         Q <= 1'b1;
      else if(r)       
         Q <= 1'b0;
      else
         Q <= Q;


endmodule
