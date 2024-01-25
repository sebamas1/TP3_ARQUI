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
        parameter   PC_SIZE = 11,
        parameter   TAM_DATA = 32,
        parameter   BYTE = 8,
        parameter   REGISTER_SIZE = 5,
        parameter   OP_SIZE = 6,
        parameter   INMEDIATE_SIZE = 16,
        parameter   DIRECCION_SIZE = 26,
        parameter   SHAMT_SIZE = 5
    )
    (
        input                                  i_clk,
        input                                  i_reset,
        input   [TAM_DATA - 1 : 0]             i_instruccion,
        input   [PC_SIZE - 1 : 0]             i_pc,
        
        input                                  i_reg_write_mem_wb,
        input  [TAM_DATA - 1 : 0]              i_dato_de_escritura_en_reg,
        input  [REGISTER_SIZE - 1 : 0 ]        i_direc_de_escritura_en_reg,
        
        output  [PC_SIZE - 1 : 0]              o_pc,
        output  [OP_SIZE - 1 : 0]              o_op,
        output  [TAM_DATA - 1 : 0]             o_inmediato,
        output  [SHAMT_SIZE - 1 : 0]           o_shamt,
        output  [OP_SIZE - 1 : 0]              o_funct,
        output  [DIRECCION_SIZE - 1 : 0]       o_direccion,
        output  [TAM_DATA - 1 : 0 ]            o_rs,
        output  [TAM_DATA - 1 : 0 ]            o_rt,
        output  [REGISTER_SIZE - 1 : 0 ]       o_rs_dir,
        output  [REGISTER_SIZE - 1 : 0 ]       o_rt_dir,
        output  [REGISTER_SIZE - 1 : 0 ]       o_rd_dir//entiendo que no tiene sentidon transmitir el contenido de rd ya que unicamente lo voy usar de destino, 
                                                        //por lo que transmito la direccion por si mas tarde necesito escribir en este
        
    );
    
    //wire i_reg_write_mem_wb = 0;
    //wire [TAM_DATA - 1 : 0] i_dato_de_escritura_en_reg = 32'b0;
   // wire [REGISTER_SIZE - 1 : 0] i_direc_de_escritura_en_reg = 5'b0;//estos se dejan provisionalmente para que el modulo funcione, pero cuando se haga
                                                                //wb, hay que usar entra salida desde wb que sobreescriba estos valores
    
    
    reg [OP_SIZE - 1 : 0] op_tmp;
    reg [TAM_DATA - 1 : 0] inmediato_tmp;
    reg [SHAMT_SIZE - 1 : 0] shamt_tmp;
    reg [OP_SIZE - 1 : 0] funct_tmp;
    reg [DIRECCION_SIZE - 1 : 0] direccion_tmp;
    wire [TAM_DATA - 1 : 0] rs_tmp_wire;
    wire [TAM_DATA - 1 : 0] rt_tmp_wire;
    reg [REGISTER_SIZE - 1 : 0] rs_dir_tmp;
    reg [REGISTER_SIZE - 1 : 0] rt_dir_tmp;
    reg [REGISTER_SIZE - 1 : 0] rd_dir_tmp;
    reg [PC_SIZE - 1 : 0] pc_tmp;
     
     
     
     
    Registros gp(
        i_clk,
        i_reset,
        i_reg_write_mem_wb,
        i_dato_de_escritura_en_reg,
        i_direc_de_escritura_en_reg,
        i_instruccion[25 : 21],
        i_instruccion[20 : 16],

        rs_tmp_wire,
        rt_tmp_wire
    );
    
always @(posedge i_clk)
begin
    op_tmp <= i_instruccion[31 : 26];
    inmediato_tmp <= { 16'b0, i_instruccion[15 : 0] };
    shamt_tmp <= i_instruccion[10 : 6];
    funct_tmp <= i_instruccion[5 : 0];
    direccion_tmp <= i_instruccion[25 : 0];
    rs_dir_tmp <= i_instruccion[25 : 21];
    rt_dir_tmp <= i_instruccion[20 : 16];
    rd_dir_tmp <= i_instruccion[15 : 11];
    pc_tmp <= i_pc;
    
    
end
    
   assign o_op =                op_tmp;
   assign o_inmediato =         inmediato_tmp;
   assign o_shamt =             shamt_tmp;
   assign o_funct =             funct_tmp;
   assign o_direccion =         direccion_tmp;
   assign o_rs_dir =            rs_dir_tmp;
   assign o_rt_dir =            rt_dir_tmp;
   assign o_rd_dir =            rd_dir_tmp;
   assign o_pc =                pc_tmp;
   assign o_rs =                rs_tmp_wire;
   assign o_rt =                rt_tmp_wire;
   
endmodule
