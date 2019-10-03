`timescale 1ns / 1ps
//****************************************************************// 
//  File name: tsi.v                                              // 
//                                                                // 
//  Created by       Raman Kooner on April 30th, 2019.            // 
//  Copyright © 2019 Raman Kooner. All rights reserved.           // 
//                                                                // 
//                                                                // 
//  In submitting this file for class work at CSULB               // 
//  I am confirming that this is my work and the work             // 
//  of no one else. In submitting this code I acknowledge that    // 
//  plagiarism in student project work is subject to dismissal.   //  
//  from the class                                                // 
//****************************************************************//
module tsi( I_CLK, I_RESET, I_RX, I_TX, I_SWITCH, I_LED,
            O_CLK, O_RESET, O_RX, O_TX, O_SWITCH, O_LED
		    );

	input         I_CLK, I_RESET, I_RX, I_TX;
	input  [7:0]  I_SWITCH;
	input  [15:0] I_LED;
	
	output        O_CLK, O_RESET, O_RX, O_TX;
	output [7:0]  O_SWITCH;
	output [15:0] O_LED;
	
	
	// CLOCK INPUT BUFFER
	IBUFG CLK_inst (
		.I(I_CLK),
		.O(O_CLK)
	);	
	
	// INPUT BUFFER
	IBUF RESET_inst (
		.I(I_RESET),
		.O(O_RESET)
	);
	
	IBUF RX_inst (
		.I(I_RX),
		.O(O_RX)
	);
	
	IBUF SWITCH_inst [7:0] (
		.I(I_SWITCH[7:0]),
		.O(O_SWITCH[7:0])
	);
	
	// OUTPUT BUFFER
	OBUF TX_inst (
		.I(I_TX),
		.O(O_TX)
	);
	
	OBUF LED_inst [15:0] (
		.I(I_LED[15:0]),
		.O(O_LED[15:0])
	);
	
	
endmodule
