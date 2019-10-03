`timescale 1ns / 1ps
//****************************************************************// 
//  File name: core.v                                             // 
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
module core(clk, reset, TX, LED, RX, SWITCH);

	input         clk, reset;
	input         RX;
	input   [7:0] SWITCH;
	
	output        TX;
	output [15:0] LED;
	reg    [15:0] LED;
	
	wire   [15:0] OUT_PORT, PORT_ID;
	wire    [7:0] READS, WRITES;
	wire    [7:0] IN_PORT;
	wire          READ_STROBE, WRITE_STROBE;
	wire          INT_ACK, INTERRUPT;
	wire          TX_RDY, PED_OUT;
	wire          reset_s;
	wire          writeEnable;
	
	wire   [15:0] staticRAMOut;
	
	wire   [15:0] IN_PORT_WIRE;
	
	assign IN_PORT_WIRE = (PORT_ID[15] && READ_STROBE) ?  staticRAMOut : {8'b0, IN_PORT};
	
	assign writeEnable = (PORT_ID[15] && WRITE_STROBE) ? 1'b1 : 1'b0;
	
	staticRAM          u4 (.addra(PORT_ID[14:0]),
								  .dina(OUT_PORT[15:0]),
								  .wea(writeEnable),
								  .clka(clk),
								  .douta(staticRAMOut)	 
	                      );
	
	addressDecoder     u3 (.PORT_ID({PORT_ID[15], PORT_ID[2:0]})                 , 
	                       .READ_STROBE(READ_STROBE), .WRITE_STROBE(WRITE_STROBE), 
	                       .READS(READS)            , .WRITES(WRITES)
								 );
	 
	tramelblaze_top    u2 (.CLK(clk)                , .RESET(reset_s)            , 
	                       .IN_PORT(IN_PORT_WIRE)   , .INTERRUPT(INTERRUPT)      , 
								  .OUT_PORT(OUT_PORT)      , .PORT_ID(PORT_ID)          , 
								  .READ_STROBE(READ_STROBE), .WRITE_STROBE(WRITE_STROBE), 
								  .INTERRUPT_ACK(INT_ACK)
							    );
	
	UART               u1 (.clk(clk)               , .reset(reset_s)   , 
	                       .OUT_PORT(OUT_PORT[7:0]), 
	                       .WRITE2(WRITES[2])      , .WRITE0(WRITES[0]), 
	                       .READ(READS[2:0])       , .RX(RX)           , 
								  .SWITCH(SWITCH)         , .IN_PORT(IN_PORT) , 
								  .INTERRUPT(INTERRUPT)   , .INT_ACK(INT_ACK) , .TX(TX)
								 );
	
	AISOO              u0 (.clk(clk)        , .reset(reset), 
	                       .reset_s(reset_s)
	                      );
	
	always @ (posedge clk, posedge reset_s)
		if (reset_s)
			LED <= 16'b0;
			
		else if (WRITES[3])
			LED <= OUT_PORT;
		
		else
			LED <= LED;
		
endmodule
 