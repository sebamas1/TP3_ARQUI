`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.01.2024 22:03:08
// Design Name: 
// Module Name: Forwarding_unit
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


module Forwarding_unit#(
    parameter   TAM_DATA = 32,
    parameter   REGISTER_SIZE = 5
)
(

    input [REGISTER_SIZE - 1 : 0] i_rs_ex,
    input [REGISTER_SIZE - 1 : 0] i_rt_ex,
    input [REGISTER_SIZE - 1 : 0] i_mem_reg_dir,
    input [REGISTER_SIZE - 1 : 0] i_wb_reg_dir,
    input [TAM_DATA - 1 : 0] i_mem_data,
    input [TAM_DATA - 1 : 0] i_wb_data,
    
    output                    o_mem_res_rs_enable,
    output                    o_wb_res_rs_enable,
    output                    o_mem_res_rt_enable,
    output                    o_wb_res_rt_enable,
    output [TAM_DATA - 1 : 0] o_mem_res,
    output [TAM_DATA - 1 : 0] o_wb_res
    
    );
    
    assign o_mem_res_rs_enable = (i_rs_ex == i_mem_reg_dir) ? 1 : 0;
    assign o_wb_res_rs_enable = (i_rs_ex == i_wb_reg_dir) ? 1 : 0;
    
    assign o_mem_res_rt_enable = (i_rt_ex == i_mem_reg_dir) ? 1 : 0;
    assign o_wb_res_rt_enable =  (i_rt_ex == i_wb_reg_dir) ? 1 : 0;
    
    assign o_mem_res = i_mem_data;
    assign o_wb_res = i_wb_data;                               

endmodule
