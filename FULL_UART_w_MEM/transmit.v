`timescale 1ns / 1ps
//****************************************************************// 
//  File name: transmit.v                                         // 
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
module transmit(clk, reset, PEN, OHEL, EIGHT, LOAD, OUT_PORT, TX, BAUD_COUNT, TX_RDY);

	input        clk, reset, LOAD;
	input        PEN, OHEL, EIGHT;
	
	input [18:0] BAUD_COUNT;
	input  [7:0] OUT_PORT;
	
	output       TX, TX_RDY;
	
	reg          TX_RDY;
	
	wire         DONE, BTNU;
	reg          DONE_D1;
	reg          DO_IT, WRITE_D1;
	
	reg    [7:0] LOAD_DATA;
	
	reg   [18:0] BIT_TIME_COUNTER, BIT_TIME_COUNTER1;
	reg    [3:0] BIT_COUNTER, BIT_COUNTER1;
	
	reg   [10:0] SHIFT_REG;
	reg    [1:0] DEC;

	// TX_RDY SR FLOP
	always @(posedge clk, posedge reset)
		if (reset)
			TX_RDY <= 1'b1;
      else if (DONE_D1)    // S      
         TX_RDY <= 1'b1;
      else if (LOAD)       // R
         TX_RDY <= 1'b0;
		else
			TX_RDY <= TX_RDY;
	
	// DO_IT SR FLOP
	always @(posedge clk, posedge reset)
		if (reset)
			DO_IT <= 1'b0;
      else if (LOAD)      // S  
         DO_IT <= 1'b1;
      else if (DONE)      // R
         DO_IT <= 1'b0;
		else
			DO_IT <= DO_IT;
	
	// 8 BIT LOAD FLOP
	always @ (posedge clk, posedge reset)
		if (reset)
			LOAD_DATA <= 8'b0;
		else if (LOAD)
			LOAD_DATA <= OUT_PORT;
		else
			LOAD_DATA <= LOAD_DATA;
	
	
	// WRITE_D1 D FLIP FLOP
	always @ (posedge clk, posedge reset)
		if (reset)
			WRITE_D1 <= 1'b0;	
		else
			WRITE_D1 <= LOAD;
	
	
	// BIT TIME COUNTER
	always @ (*)
		case({DO_IT, BTNU})
			2'b00  : BIT_TIME_COUNTER = 19'b0;
			2'b01  : BIT_TIME_COUNTER = 19'b0;
			2'b10  : BIT_TIME_COUNTER = BIT_TIME_COUNTER1 + 19'b1;
			2'b11  : BIT_TIME_COUNTER = 19'b0;
			default: BIT_TIME_COUNTER = BIT_TIME_COUNTER;
		endcase
	
	always @ (posedge clk, posedge reset)
		if (reset)
			BIT_TIME_COUNTER1 <= 19'b0;
		else
			BIT_TIME_COUNTER1 <= BIT_TIME_COUNTER;
	
	// BIT COUNTER
	always @ (*)
		case({DO_IT, BTNU})
			2'b00  : BIT_COUNTER = 4'b0;
			2'b01  : BIT_COUNTER = 4'b0;
			2'b10  : BIT_COUNTER = BIT_COUNTER1;
			2'b11  : BIT_COUNTER = BIT_COUNTER1 + 4'b1;
			default: BIT_COUNTER = BIT_COUNTER;
		endcase
		
	always @ (posedge clk, posedge reset)
		if (reset)
			BIT_COUNTER1 <= 4'b0;
			
		else
			BIT_COUNTER1 <= BIT_COUNTER;
	
	
	// DONE D1 FLOP
	always @ (posedge clk, posedge reset)
		if (reset)
			DONE_D1 <= 1'b0;
		else
			DONE_D1 <= DONE;
	
	// COMPARE VALUES
	assign BTNU = (BIT_TIME_COUNTER1 == BAUD_COUNT);

	assign DONE = (BIT_COUNTER1 == 4'd11);
			
	// SHIFT REGISTER
	always @ (posedge clk, posedge reset)
	
		if (reset)
			SHIFT_REG <= 11'b111_1111_1111;
		
		else 
			// Load the shift register
			if (WRITE_D1)
				SHIFT_REG <= {DEC, LOAD_DATA[6:0], 2'b01};
			
			// Shift the register to the right
			// Fill in bits with a 1
			else if (BTNU)
				SHIFT_REG <= {1'b1, SHIFT_REG[10:1]};
				
			else 
				SHIFT_REG <= SHIFT_REG;
			
	assign TX = SHIFT_REG[0];
	
	// 3 TO 8 DECODER
	always @ (*)
		case({EIGHT, PEN, OHEL})
			3'b000 :  DEC = 2'b11;
			3'b001 :  DEC = 2'b11;
			3'b010 :  DEC = {1'b1, ^LOAD_DATA[6:0]};
			3'b011 :  DEC = {1'b1, ~^LOAD_DATA[6:0]};
			3'b100 :  DEC = {1'b1, LOAD_DATA[7]};
			3'b101 :  DEC = {1'b1, LOAD_DATA[7]};
			3'b110 :  DEC = {^LOAD_DATA[7:0], LOAD_DATA[7]};
			3'b111 :  DEC = {~^LOAD_DATA[7:0], LOAD_DATA[7]};
		   default:  DEC = DEC;
		endcase
		
	
endmodule
