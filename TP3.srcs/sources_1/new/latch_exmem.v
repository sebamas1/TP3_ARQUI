`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.01.2024 19:40:35
// Design Name: 
// Module Name: latch_exmem
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


module latch_exmem#(
     parameter   TAM_DATA = 32
)
(
        input                                 i_clk,
        input                                 i_reset,
            
        input  [TAM_DATA - 1 : 0]             i_pc,
        input  [TAM_DATA - 1 : 0]             i_res,
        input  [TAM_DATA - 1 : 0]             i_rd_dir
    );
    

endmodule
