`timescale 1ns / 1ps
//****************************************************************// 
//  File name: AISO.v                                             // 
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

module AISOO(clk, reset, reset_s);

	input  clk, reset;
	output reset_s;
	
	reg    Q_meta;
	reg    Q_ok;
	
	always @ (posedge clk, posedge reset)
		if (reset)
			{Q_meta, Q_ok} <= 2'b0;
		else
			{Q_meta, Q_ok} <= {1'b1, Q_meta};
			
	assign reset_s = ~Q_ok;
	
endmodule
