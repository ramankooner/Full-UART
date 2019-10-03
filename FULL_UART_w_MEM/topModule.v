`timescale 1ns / 1ps
//****************************************************************// 
//  File name: topModule.v                                        // 
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
module topModule(clk, reset, TX, LED, RX, SWITCH);

	input          clk, reset, RX;
	input    [7:0] SWITCH;
	
	output  [15:0] LED;
	output         TX;
	
	wire           CLK_W, RESET_W, TX_W, RX_W;
	wire    [15:0] LED_W;
	wire     [7:0] SWITCH_W;
	
	
	core u1 ( .clk(CLK_W), .reset(RESET_W)   , 
	          .TX(TX_W)  , .LED(LED_W)       ,
				 .RX(RX_W)  , .SWITCH(SWITCH_W)
			  );
			  
	tsi  u0 ( .I_CLK(clk)        , .I_RESET(reset)  , 
	          .I_RX(RX)          , .I_TX(TX_W)      , 
	          .I_SWITCH(SWITCH)  , .I_LED(LED_W)    ,
             .O_CLK(CLK_W)      , .O_RESET(RESET_W), 
				 .O_RX(RX_W)        , .O_TX(TX)        , 
				 .O_SWITCH(SWITCH_W), .O_LED(LED)
	        );

endmodule
