`timescale 1ns / 1ps
//****************************************************************// 
//  File name: receive.v                                          // 
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
module receive( clk, reset, k, EIGHT, PEN, OHEL, RX_RDY, 
                RX_DATA, PERR, FERR, OVF, RX, READ
				  );

	input         clk, reset;
	input         EIGHT, PEN, OHEL;
	input         RX, READ;
	input  [18:0] k;
	
	output        RX_RDY;
	output        PERR, FERR, OVF;
	output  [7:0] RX_DATA;
	
	reg           RX_RDY;
	
	reg           STOP_BIT_SEL;
	reg           PERR, FERR, OVF;

	reg     [1:0] present_state, next_state;
	reg           START, DO_IT, N_START, N_DO_IT;

	reg     [9:0] SHIFT_REG;

	reg     [9:0] REMAP;
	
	reg    [18:0] BIT_TIME_COUNTER, BIT_TIME_COUNTER1;
	reg     [3:0] BIT_COUNTER, BIT_COUNTER1;
	
	reg     [3:0] DONE_COMPARE;
	
	wire   [18:0] BTU_COMPARE;
	wire          BTU, DONE;
	wire          SH;
	wire          PAR_EN_SEL, PAR_BIT_SEL;
	wire          XOR_COMPARE_1, XOR_COMPARE_2, XOR_OUT; 
	wire          PERR_AND, FERR_AND, OVF_AND;
		
	// STATE MACHINE: START, DO_IT
	always @ (posedge clk, posedge reset)
		if (reset)
			begin
				present_state <= 2'b00;
				START <= 1'b0;
				DO_IT <= 1'b0;
			end
		
		else
			begin
				present_state <= next_state;
				START <= N_START;
				DO_IT <= N_DO_IT;
			end
	
	always @ (*)
		begin
			next_state = present_state;
			N_START = START;
			N_DO_IT = DO_IT;
			case (present_state)
				2'b00: {next_state, N_START, N_DO_IT} = (RX)   ? {2'b00, 1'b0, 1'b0} : 
				                                                 {2'b01, 1'b1, 1'b1} ;
																				 
				2'b01: {next_state, N_START, N_DO_IT} = (RX)   ? {2'b00, 1'b0, 1'b0} : 
				                                        (BTU)  ? {2'b10, 1'b0, 1'b1} : 
																	          {2'b01, 1'b1, 1'b1} ;
																				 
				2'b10: {next_state, N_START, N_DO_IT} = (DONE) ? {2'b00, 1'b0, 1'b0} :  
				                                                 {2'b10, 1'b0, 1'b1} ;
			endcase
		end
	
	// BIT TIME COUNTER
	// Counter used to match the set baud rate
	always @ (*)
		case({DO_IT, BTU})
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
	// Determines when all the bits have been shifted
	always @ (*)
		case({DO_IT, BTU})
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
	
	// BTU COMPARE WIRE
	assign BTU_COMPARE = (START) ? (k >> 1) : k;
	
	// BTU
	assign BTU = ( BIT_TIME_COUNTER1 == BTU_COMPARE );
	
	// DONE_COMPARE WIRE
	always @ (*)
		case({EIGHT, PEN})
			2'b00:   DONE_COMPARE = 4'd9;
			2'b01:   DONE_COMPARE = 4'd10;
			2'b10:   DONE_COMPARE = 4'd10;
			2'b11:   DONE_COMPARE = 4'd11;
			default: DONE_COMPARE = 4'd11;
		endcase
	
	// DONE
	assign DONE = ( BIT_COUNTER1 == DONE_COMPARE );
	
	// SHIFT REGISTER
	assign SH = (BTU & ~START);
	
	always @ (posedge clk, posedge reset)
		if (reset)
			SHIFT_REG <= 10'b00_0000_0000;
		else
			if (SH)
				SHIFT_REG <= {RX, SHIFT_REG[9:1]};
			else
				SHIFT_REG <= SHIFT_REG;
	
	// REMAP COMBO
	always @ (*)
		case({EIGHT, PEN})
			2'b00:   REMAP = SHIFT_REG >> 2;
			2'b01:   REMAP = SHIFT_REG >> 1;
			2'b10:   REMAP = SHIFT_REG >> 1;
			2'b11:   REMAP = SHIFT_REG;
			default: REMAP = REMAP;
		endcase
		
	// PARTIY ERROR SELECTS
	assign PAR_EN_SEL  = (EIGHT) ? REMAP[7] : 1'b0;
	
	assign PAR_BIT_SEL = (EIGHT) ? REMAP[8] : REMAP[7];
	
	// FRAMING ERROR SELECT
	always @ (*)
		case({EIGHT, PEN})
			2'b00:   STOP_BIT_SEL = REMAP[7];
			2'b01:   STOP_BIT_SEL = REMAP[8];
			2'b10:   STOP_BIT_SEL = REMAP[8];
			2'b11:   STOP_BIT_SEL = REMAP[9];
			default: STOP_BIT_SEL = STOP_BIT_SEL;
		endcase
	
	// RX_DATA
	assign RX_DATA       = REMAP[7:0];
	
	// XOR COMPARES
	assign XOR_COMPARE_1 = ^{REMAP[6:0], PAR_EN_SEL};
	
	assign XOR_OUT       = (~OHEL) ? XOR_COMPARE_1 : ~XOR_COMPARE_1;
	
	assign XOR_COMPARE_2 = ( XOR_OUT ^ PAR_BIT_SEL );
		
	// AND GATE WIRES
	assign PERR_AND      = ( PEN & XOR_COMPARE_2 & DONE );
	
	assign FERR_AND      = ( DONE & ~STOP_BIT_SEL );
	
	assign OVF_AND       = ( DONE & RX_RDY );
	
	// RX_RDY SR FLOP
	always @(posedge clk, posedge reset)
		if (reset)
			RX_RDY <= 1'b0;
      else if (DONE)        // S      
         RX_RDY <= 1'b1;
      else if (READ)        // R
         RX_RDY <= 1'b0;
		else
			RX_RDY <= RX_RDY;
	
	// PERR SR FLOP
	always @(posedge clk, posedge reset)
		if (reset)
			PERR <= 1'b0;
      else if (PERR_AND)    // S      
         PERR <= 1'b1;
      else if (READ)        // R
         PERR <= 1'b0;
		else
			PERR <= PERR;
	
	// FERR SR FLOP
	always @(posedge clk, posedge reset)
		if (reset)
			FERR <= 1'b0;
      else if (FERR_AND)    // S      
         FERR <= 1'b1;
      else if (READ)        // R
         FERR <= 1'b0;
		else
			FERR <= FERR;
	
	// OVF SR FLOP
	always @(posedge clk, posedge reset)
		if (reset)
			OVF <= 1'b0;
      else if (OVF_AND)    // S      
         OVF <= 1'b1;
      else if (READ)       // R
         OVF <= 1'b0;
		else
			OVF <= OVF;
	
endmodule
