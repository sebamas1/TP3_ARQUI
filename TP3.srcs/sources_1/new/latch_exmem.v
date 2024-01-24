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
     parameter   PC_SIZE = 11,
     parameter   TAM_DATA = 32,
     parameter   DIRECCION_SIZE = 26,
     parameter   ALU_CTRL = 5,
     parameter   REGISTER_SIZE = 5
)
(
        input                                 i_clk,
        input                                 i_reset,
            
        input  [PC_SIZE - 1 : 0]              i_pc,
        input  [TAM_DATA - 1 : 0]             i_res,
        input  [ALU_CTRL  - 1: 0]             i_alu_ctrl,
        input  [TAM_DATA - 1 : 0]             i_rt,
        input  [REGISTER_SIZE - 1 : 0]        i_wb_reg_write,
        
        output  [TAM_DATA - 1 : 0]             o_rt,
        output  [TAM_DATA - 1 : 0]             o_res,
        output  [PC_SIZE - 1 : 0]              o_pc,
        output  [REGISTER_SIZE - 1 : 0]        o_wb_reg_write,
        output  [ALU_CTRL - 1 : 0]             o_alu_ctrl //en realidad aluctrl tiene 8 bits, pero a partir de aca solo me interesan 5
        
        
    );
    
   // reg  [DIRECCION_SIZE - 1 : 0]       direccion_tmp;
    reg  [TAM_DATA - 1 : 0]             rt_tmp;
    reg  [REGISTER_SIZE - 1 : 0]        wb_reg_write_tmp;
    reg  [PC_SIZE - 1 : 0]              pc_tmp;
    reg  [TAM_DATA - 1 : 0]             res_tmp;
    reg  [ALU_CTRL - 1 : 0]             alu_tmp;
    
    
always @(negedge i_clk)
begin
    //direccion_tmp <= i_direccion;
    rt_tmp <= i_rt;
    wb_reg_write_tmp <= i_wb_reg_write;
    pc_tmp <= i_pc;
    res_tmp <= i_res;
    alu_tmp <= i_alu_ctrl;
end

        assign o_pc =                    pc_tmp;
        assign o_res =                   res_tmp;
        assign o_rt =                    rt_tmp;
        assign o_wb_reg_write =          wb_reg_write_tmp;
        assign o_alu_ctrl =              alu_tmp;
endmodule
