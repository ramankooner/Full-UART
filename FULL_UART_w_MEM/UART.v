`timescale 1ns / 1ps
//****************************************************************// 
//  File name: UART.v                                             // 
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
module UART( clk, reset, OUT_PORT, WRITE2, WRITE0, READ, RX, SWITCH, 
             IN_PORT, INTERRUPT, INT_ACK, TX
			  );

	input         clk, reset;
	input   [7:0] OUT_PORT, SWITCH;
	input   [2:0] READ;
	input         WRITE2, WRITE0;
	input         INT_ACK, RX;
	
	output  [7:0] IN_PORT;
	output        INTERRUPT, TX;
	
	reg           INTERRUPT;
	reg     [7:0] UART_CONFIG;
	wire    [7:0] RX_DATA;
	wire   [18:0] k;
	wire          PED_OUT, TX_PED_OUT, RX_PED_OUT;
	wire          TX_RDY, RX_RDY;
	wire          PERR, FERR, OVF;
	
	
	// UART CONFIG
	always @ (posedge clk, posedge reset)
		if (reset)
			UART_CONFIG <= 8'b0;
		else
			if (WRITE2)
				UART_CONFIG <= OUT_PORT;
			else
				UART_CONFIG <= UART_CONFIG;
	
	// INTERRUPT SR FLOP
	always @(posedge clk, posedge reset)
		if (reset)
			INTERRUPT <= 1'b1;
      else if (PED_OUT)       // S      
         INTERRUPT <= 1'b1;
      else if (INT_ACK)       // R
         INTERRUPT <= 1'b0;
		else
			INTERRUPT <= INTERRUPT;
	
	// IN_PORT OUTPUT
	assign IN_PORT = (READ[0]) ? RX_DATA                                   : 
	                 (READ[1]) ? {3'b000, OVF, FERR, PERR, TX_RDY, RX_RDY} : 
						  (READ[2]) ? SWITCH                                    : 
						              8'b0000_0000; 
	
	assign PED_OUT = (TX_PED_OUT | RX_PED_OUT);
	
	// TRANSMIT ENGINE
	transmit           u4 (.clk(clk)             , .reset(reset)        , 
	                       .PEN(UART_CONFIG[2])  , .OHEL(UART_CONFIG[1]), 
								  .EIGHT(UART_CONFIG[3]), 
					           .LOAD(WRITE0)         , .OUT_PORT(OUT_PORT)  , 
					           .TX(TX)               , .BAUD_COUNT(k)       , 
								  .TX_RDY(TX_RDY)
					          );
	
	// RECEIVER ENGINE
	receive            u3 (.clk(clk)             , .reset(reset)       , 
	                       .k(k)                 , 
	                       .EIGHT(UART_CONFIG[3]), .PEN(UART_CONFIG[2]), 
								  .OHEL(UART_CONFIG[1]) , 
					           .RX_RDY(RX_RDY)       , .RX_DATA(RX_DATA)   , 
					           .PERR(PERR)           , .FERR(FERR)         , .OVF(OVF), 
					           .RX(RX)               , .READ(READ[0])
				             );
	
	// BAUD RATE
	baudRates          u2 (.BAUD(UART_CONFIG[7:4]), 
	                       .COUNT(k)
	                      );
	
	// TX PED
	PositiveEdgeDetect u1 (.clk(clk)  , .reset(reset)   , 
	                       .db(TX_RDY), .ped(TX_PED_OUT)
	                      );
	
	// RX PED
	PositiveEdgeDetect u0 (.clk(clk)  , .reset(reset)   , 
	                       .db(RX_RDY), .ped(RX_PED_OUT)
								 );
	
	
endmodule
