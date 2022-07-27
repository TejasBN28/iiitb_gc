`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.07.2022 14:54:14
// Design Name: 
// Module Name: iiitb_gc
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

// Gray counter

module iiitb_gc
(
	input clk, enable, reset,
	output reg [7:0] gray_count
);

	reg q [8:0];
	reg no_ones_below [7:0];
	reg q_msb;
	
	integer i, j, k;
	
	always @ (posedge clk)
	begin
		if (reset)
		begin
		
			q[0] <= 1;
			for (i = 1; i <= 8; i = i + 1)
				q[i] <= 0;
				
		end
		else if (enable)
		begin
			q[0] <= ~q[0];
			
			for (i = 1; i < 8; i = i + 1)
			begin
				
				q[i] <= q[i] ^ (q[i-1] & no_ones_below[i-1]);
			
			end
			
			q[8] <= q[8] ^ (q_msb & no_ones_below[7]);
		end
	end
	
	
	always @(*)
	begin
		no_ones_below[0] = 1;
		
		for (j = 1; j < 8; j = j + 1)
			no_ones_below[j] = no_ones_below[j-1] & ~q[j-1];
			
		q_msb = q[8] | q[7];
		for (k = 0; k < 8; k = k + 1)
			gray_count[k] = q[k+1];
		end	
		
endmodule
