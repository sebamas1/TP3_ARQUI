`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.01.2024 14:59:13
// Design Name: 
// Module Name: etapa_ex
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


module etapa_ex#(
        parameter   TAM_DATA = 32,
        parameter   BYTE = 8,
        parameter   REGISTER_SIZE = 5,
        parameter   OP_SIZE = 6,
        parameter   INMEDIATE_SIZE = 16,
        parameter   DIRECCION_SIZE = 26,
        parameter   SHAMT_SIZE = 5
)
(
        input                                 i_clk,
        input                                 i_reset,

        input  [TAM_DATA - 1 : 0]             i_pc,
        input  [OP_SIZE - 1 : 0]              i_op,
        input  [TAM_DATA - 1 : 0]             i_inmediato,
        input  [SHAMT_SIZE - 1 : 0]           i_shamt,
        input  [OP_SIZE - 1 : 0]              i_funct,
        input  [DIRECCION_SIZE - 1 : 0]       i_direccion,
        input  [TAM_DATA - 1 : 0 ]            i_rs,
        input  [TAM_DATA - 1 : 0 ]            i_rt,
        input  [REGISTER_SIZE - 1 : 0 ]       i_rd_dir

    );
    
    reg [TAM_DATA - 1 : 0] rs_tmp;
    reg [TAM_DATA - 1 : 0] rt_tmp;
    reg [OP_SIZE - 1 : 0] funct_tmp;
    
    ALU alu(
        rs_tmp,
        rt_tmp,
        funct_tmp
    );
    
    
    always @(posedge i_clk)
    begin
        rs_tmp <= i_rs;
        rt_tmp <= i_rt;
        funct_tmp <= i_funct;
    end
endmodule
