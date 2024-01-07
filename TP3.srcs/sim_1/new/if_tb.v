`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.01.2024 22:33:06
// Design Name: 
// Module Name: if_tb
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


module if_tb;

reg clk = 1'b0;

Instruction_fetch ins(.i_clk(clk), .i_reset(0));

    always begin
        #10
        clk = ~clk;
    end
endmodule
