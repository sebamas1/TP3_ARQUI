`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.01.2024 17:43:47
// Design Name: 
// Module Name: etapa_wb
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


module etapa_wb# (
     parameter   PC_SIZE = 11,
     parameter   TAM_DATA = 32,
     parameter   DIRECCION_SIZE = 26,
     parameter   REGISTER_SIZE = 5
)
(
        input                                 i_clk,
        input                                 i_reset,

        input  [PC_SIZE - 1 : 0]              i_pc,
        input  [TAM_DATA - 1 : 0]             i_res,
        input  [REGISTER_SIZE - 1 : 0]        i_wb_reg_write,
        input                                 i_reg_write_enable,

        output  [TAM_DATA - 1 : 0]            o_res,
        output  [REGISTER_SIZE - 1 : 0]       o_wb_reg_write,
        output                                o_reg_write_enable

    );
    
    reg                                 reg_write_enable_tmp;
    reg  [REGISTER_SIZE - 1 : 0]        wb_reg_write_tmp;
    reg  [TAM_DATA - 1 : 0]             res_tmp;
    
    
always @(posedge i_clk)
begin
    reg_write_enable_tmp <= i_reg_write_enable;
    wb_reg_write_tmp <= i_wb_reg_write;
    res_tmp <= i_res;
end
        assign o_res =                   res_tmp;
        assign o_wb_reg_write =          wb_reg_write_tmp;
        assign o_reg_write_enable =      reg_write_enable_tmp;
    
    
endmodule
