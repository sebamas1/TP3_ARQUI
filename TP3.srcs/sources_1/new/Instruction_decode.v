`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.01.2024 14:08:32
// Design Name: 
// Module Name: Instruction_decode
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


module Instruction_decode#(
        parameter   TAM_DATA = 32,
        parameter   BYTE = 8
    )
    (
        input                           i_clk,
        input                           i_reset,
        input   [31 : 0]                i_instruccion,
        output  [5 : 0]                 o_op,
        output  [15 : 0]                o_inmediato,
        output  [4 : 0]                 o_shamt,
        output  [5 : 0]                 o_funct,
        output  [25 : 0]                o_direccion,
        output  [TAM_DATA - 1 : 0 ]     salida_del_ra,
        output  [TAM_DATA - 1 : 0 ]     salida_del_rb
    );
    
    wire i_reg_write_mem_wb = 0;
    wire [TAM_DATA - 1 : 0] i_dato_de_escritura_en_reg = 32'b0;
    wire [TAM_DATA - 1 : 0] i_direc_de_escritura_en_reg = 5'b0;//estos se dejan provisionalmente para que el modulo funcione, pero cuando se haga
                                                                //wb, hay que usar entra salida desde wb que sobreescriba estos valores
    
    
    Registros gp(
        i_clk,
        i_reset,
        i_reg_write_mem_wb,
        i_dato_de_escritura_en_reg,
        i_direc_de_escritura_en_reg,
        i_instruccion[25:21],
        i_instruccion[20:16],

        salida_del_ra,
        salida_del_rb
    );
    
   assign o_op =                i_instruccion[31 : 26];
   assign o_inmediato =        i_instruccion[15 : 0];
   assign o_shamt =             i_instruccion[10 : 6];
   assign o_funct =             i_instruccion[5 : 0];
   assign o_direccion =         i_instruccion[25 : 0];
   
endmodule
