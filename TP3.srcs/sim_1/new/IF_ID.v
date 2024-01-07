`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.01.2024 20:12:50
// Design Name: 
// Module Name: IF_ID
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


module IF_ID# (
        parameter   TAM_DATA = 32,
        parameter   BYTE = 8
    )
    (
        input                           i_clk,
        input                           i_reset,
        input   [TAM_DATA - 1 : 0]      i_new_pc,
        input   [TAM_DATA - 1 : 0]      i_instruction,
        output  [TAM_DATA - 1 : 0]      o_instruction,
        output  [TAM_DATA - 1 : 0]      o_pc_value
);

assign o_pc_value = i_new_pc;
assign o_instruction = i_instruction;
endmodule
