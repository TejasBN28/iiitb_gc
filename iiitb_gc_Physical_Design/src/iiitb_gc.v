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

module iiitb_gc ( clk, enable, reset, gray_count);
  
 
  input clk, reset, enable; 
  output [ 7:0] gray_count;
  reg [7:0] count;
  
  always @ (posedge clk) 
  if (reset) 
    count <= 0; 
  else if (enable) 
    count <= count + 1; 
    
  assign gray_count = { count[7], (count[7] ^ count[6]),(count[6] ^ 
               count[5]),(count[5] ^ count[4]), (count[4] ^ 
               count[3]),(count[3] ^ count[2]), (count[2] ^ 
               count[1]),(count[1] ^ count[0]) };
    
endmodule 

