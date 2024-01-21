`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.01.2024 16:39:14
// Design Name: 
// Module Name: Etapa_MEM
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


module Etapa_MEM #(
     parameter   TAM_DATA = 32,
     parameter   DIRECCION_SIZE = 26,
     parameter   ALU_CTRL = 5,
     parameter   REGISTER_SIZE = 5
)
(
        input                                  i_clk,
        input                                  i_reset,
            
        input  [TAM_DATA - 1 : 0]              i_pc,
        input  [TAM_DATA - 1 : 0]              i_res,
        input  [TAM_DATA - 1 : 0]              i_rt,
        input  [REGISTER_SIZE - 1 : 0]         i_rt_dir,
        input  [REGISTER_SIZE - 1 : 0]         i_rd_dir,
        input  [ALU_CTRL - 1  : 0]             i_alu_ctrl,
        
        output  [TAM_DATA - 1 : 0]             o_res,
        output  [TAM_DATA - 1 : 0]             o_pc,
        output  [REGISTER_SIZE - 1 : 0]        o_wb_reg_write,
        output                                 o_reg_write_enable
    );
    
    RAM mem_datos(
    .i_addra(i_res), //La salida del PC entra a la mem
    .i_dina(i_rt),
    .i_clka(i_clk),
    .i_wea(i_alu_ctrl[3]),                      //write enable    
    .i_ena(i_alu_ctrl[4]),                      //memory enable
    .i_rsta(1'b0),                           // Output reset (does not affect memory contents)
    .i_regcea(i_alu_ctrl[2]),               // output register enable
    .i_output_format(i_alu_ctrl[1 : 0]),
    .o_douta(),                             //output
    .o_halt()
);


    reg  [REGISTER_SIZE - 1 : 0]        wb_reg_write_tmp;
    reg  [DIRECCION_SIZE - 1 : 0]       pc_tmp;
    reg  [DIRECCION_SIZE - 1 : 0]       res_tmp;
    reg                                 reg_write_enable_tmp;
    
    
always @(posedge i_clk)
begin
    pc_tmp <= i_pc;
    reg_write_enable_tmp = !i_alu_ctrl[3]; //voy a querer escribir en los registros siempre que no sea una instruccion store
   
    if(i_alu_ctrl[4] == 1 && i_alu_ctrl[3] == 0) //entonces es un load, y tengo que tomar al res como la salida de la memoria 
        wb_reg_write_tmp <= i_rt_dir; //osea que como es un load, lo que me importa es rt para el wb
    else
     //en otro caso, es una instruccion tipo R o un store, por lo que simplemente tomo el res como viene
        wb_reg_write_tmp <= i_rd_dir; //en este caso, solo me importa rd, por si es una tipo R, si es un store en el wb no va a hacer nada con esto
end

        assign o_pc =                    pc_tmp;
        assign o_res =                   (i_alu_ctrl[4] == 1 && i_alu_ctrl[3] == 0) ? mem_datos.o_douta : i_res;
        assign o_wb_reg_write =          wb_reg_write_tmp;
        assign o_reg_write_enable =      reg_write_enable_tmp;
endmodule
