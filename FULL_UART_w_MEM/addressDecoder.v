`timescale 1ns / 1ps
//****************************************************************// 
//  File name: addressDecoder.v                                   // 
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
module addressDecoder(PORT_ID, READ_STROBE, WRITE_STROBE, READS, WRITES);

	
	input        READ_STROBE, WRITE_STROBE;
	input  [3:0] PORT_ID;
	
	output [7:0] READS, WRITES;
	reg    [7:0] READS, WRITES;

	always @ (*) 
		if (WRITE_STROBE)
			begin
				case({PORT_ID[3:0]})
					4'b0000:  WRITES = 8'b00000001;
					4'b0001:  WRITES = 8'b00000010;
					4'b0010:  WRITES = 8'b00000100;
					4'b0011:  WRITES = 8'b00001000;
					4'b0100:  WRITES = 8'b00010000;
					4'b0101:  WRITES = 8'b00100000;
					4'b0110:  WRITES = 8'b01000000;
					4'b0111:  WRITES = 8'b10000000;
					default:  WRITES = 8'b00000000;
				endcase
			end
		else 
			begin
				WRITES = 8'b00000000;
			end
			
	always @ (*) 
		if (READ_STROBE)
			begin
				case({PORT_ID[3:0]})	
					4'b0000:  READS = 8'b00000001;
					4'b0001:  READS = 8'b00000010;
					4'b0010:  READS = 8'b00000100;
					4'b0011:  READS = 8'b00001000;
					4'b0100:  READS = 8'b00010000;
					4'b0101:  READS = 8'b00100000;
					4'b0110:  READS = 8'b01000000;
					4'b0111:  READS = 8'b10000000;
					default:  READS = 8'b00000000;
				endcase
			end
		else
			begin
				READS = 8'b00000000;
			end
endmodule
