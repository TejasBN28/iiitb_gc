`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.07.2022 16:21:35
// Design Name: 
// Module Name: iiitb_gc_tb
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


module iiitb_gc_tb();
    reg clk, enable, reset;
    wire [7:0] gray_count;
    
    gray_count gc1(clk, enable, reset, gray_count);
    
    initial
    begin
        clk = 0;
        reset = 1;
        enable = 1;
        
        #5 reset = 0;
        #4000 $finish;     
    end 
    
    always #2 clk = ~clk;
       
endmodule
