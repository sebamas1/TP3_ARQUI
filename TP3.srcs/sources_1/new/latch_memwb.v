`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.01.2024 18:23:22
// Design Name: 
// Module Name: latch_memwb
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


module latch_memwb# (
     parameter   TAM_DATA = 32,
     parameter   DIRECCION_SIZE = 26,
     parameter   REGISTER_SIZE = 5
)
(
        input                                 i_clk,
        input                                 i_reset,

        input  [TAM_DATA - 1 : 0]             i_pc,
        input  [TAM_DATA - 1 : 0]             i_res,
        input  [REGISTER_SIZE - 1 : 0]        i_rd_dir,

        output  [TAM_DATA - 1 : 0]            o_pc,
        output  [TAM_DATA - 1 : 0]            o_res,
        output  [REGISTER_SIZE - 1 : 0]       o_rd_dir

    );
    
    reg  [REGISTER_SIZE - 1 : 0]        rd_dir_tmp;
    reg  [DIRECCION_SIZE - 1 : 0]       res_tmp;
    reg  [DIRECCION_SIZE - 1 : 0]       pc_tmp;
    
    
always @(negedge i_clk)
begin
    rd_dir_tmp <= i_rd_dir;
    res_tmp <= i_res;
    pc_tmp <= i_pc;
end
        assign o_res =                   res_tmp;
        assign o_rd_dir =                rd_dir_tmp;
        assign o_pc =                    pc_tmp;
endmodule
