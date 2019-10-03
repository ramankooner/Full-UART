`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:47:32 05/01/2019
// Design Name:   staticRAM
// Module Name:   C:/Users/Sandeep Kooner/Desktop/460 Labs/Full_UART_w_Memory/FULL_UART_w_MEM/memory32k_tb.v
// Project Name:  FULL_UART_w_MEM
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: staticRAM
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module memory32k_tb;

	// Inputs
	reg clka;
	reg [0:0] wea;
	reg [14:0] addra;
	reg [15:0] dina;

	// Outputs
	wire [15:0] douta;

	// Instantiate the Unit Under Test (UUT)
	staticRAM uut (
		.clka(clka), 
		.wea(wea), 
		.addra(addra), 
		.dina(dina), 
		.douta(douta)
	);

	always #5
		clka = ~clka;
		
	initial begin
		// Initialize Inputs
		clka = 0;
		wea = 0;
		addra = 0;
		dina = 0;
        
		#1085;
      
		addra = 15'h0001;
		dina = 16'hAAAA;
		wea = 1;
		
		#1085;
		
		addra = 15'h0002;
		dina = 16'h5555;
		wea = 1;
		
		#1085;
		
		addra = 15'h0003;
		dina = 16'hCCCC;
		wea = 1;
		
		#1085;
      
		addra = 15'h0004;
		dina = 16'h3333;
		wea = 1;
		
		#1085;
      
		addra = 15'h0005;
		dina = 16'h1111;
		wea = 1;
				
		
		#1085
		
		wea = 0;
		
		addra = 15'h0001;
		
		#1085
		
		wea = 0;
		
		addra = 15'h0002;
		
		#1085
		
		$stop;

	end
      
endmodule

