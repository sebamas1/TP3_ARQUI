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
     parameter   PC_SIZE = 11,
     parameter   TAM_DATA = 32,
     parameter   DIRECCION_SIZE = 26,
     parameter   ALU_CTRL = 5,
     parameter   REGISTER_SIZE = 5
)
(
        input                                  i_clk,
        input                                  i_reset,
            
        input  [PC_SIZE - 1 : 0]               i_pc,
        input  [TAM_DATA - 1 : 0]              i_res,
        input  [TAM_DATA - 1 : 0]              i_rt,
        input  [REGISTER_SIZE - 1 : 0]         i_wb_reg_write,
        input  [ALU_CTRL - 1  : 0]             i_alu_ctrl,
        input  [TAM_DATA - 1 : 0]              i_data_addr_memory,
        input                                  i_end_pipeline,
        
        output  [TAM_DATA - 1 : 0]             o_res,
        output  [PC_SIZE - 1 : 0]              o_pc,
        output  [REGISTER_SIZE - 1 : 0]        o_wb_reg_write,
        output                                 o_reg_write_enable,
        output  [TAM_DATA - 1 : 0]             o_data_memory
    );
    
    RAM mem_datos(
    .i_addra(i_end_pipeline == 0 ? i_res : i_data_addr_memory), //La salida del PC entra a la mem
    .i_dina(i_rt),
    .i_clka(i_clk),
    .i_wea(i_end_pipeline == 0 ? i_alu_ctrl[3] : 0),                      //write enable    
    .i_ena(i_end_pipeline == 0 ? i_alu_ctrl[4] : 1),                      //memory enable
    .i_rsta(1'b0),                           // Output reset (does not affect memory contents)
    .i_regcea(i_alu_ctrl[2]),               // output register enable
    .i_output_format(i_alu_ctrl[1 : 0]),
    .o_douta(),                             //output
    .o_halt()
);


    reg  [REGISTER_SIZE - 1 : 0]        wb_reg_write_tmp;
    reg  [PC_SIZE - 1 : 0]              pc_tmp;
    reg                                 reg_write_enable_tmp;
    
always @(posedge i_clk)
begin
    pc_tmp <= i_pc;
    reg_write_enable_tmp <= !i_alu_ctrl[3]; //voy a querer escribir en los registros siempre que no sea una instruccion store
    wb_reg_write_tmp <= i_wb_reg_write; 

end

        assign o_pc =                    pc_tmp;
        assign o_res =                   (i_alu_ctrl[4] == 1 && i_alu_ctrl[3] == 0) ? mem_datos.o_douta : i_res; //si es un load toma la memoria, si no, sigue con el resultado de la ALU
        assign o_wb_reg_write =          wb_reg_write_tmp;
        assign o_reg_write_enable =      reg_write_enable_tmp;
        assign o_data_memory =           mem_datos.o_douta;
endmodule
