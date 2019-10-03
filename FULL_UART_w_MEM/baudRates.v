`timescale 1ns / 1ps
//****************************************************************// 
//  File name: baudRates.v                                        // 
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
module baudRates(BAUD, COUNT);

	input   [3:0] BAUD;
	
	output [18:0] COUNT;
	reg    [18:0] COUNT;
	
	always @ (*)
		case(BAUD)
			4'b0000: COUNT = 333333;
			4'b0001: COUNT = 83333;
			4'b0010: COUNT = 41667;
			4'b0011: COUNT = 20833;
			4'b0100: COUNT = 10417;
			4'b0101: COUNT = 5208;
			4'b0110: COUNT = 2604;
			4'b0111: COUNT = 1736;
			4'b1000: COUNT = 868;
			4'b1001: COUNT = 434;
			4'b1010: COUNT = 217;
			4'b1011: COUNT = 109;
			default: COUNT = 333333;
		endcase
		
endmodule
