`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.01.2024 18:19:30
// Design Name: 
// Module Name: latch_idex
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


module latch_idex#(
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
        input                                 i_clk,
        input                                 i_reset,
            
        input  [PC_SIZE - 1 : 0]              i_pc,
        input  [OP_SIZE - 1 : 0]              i_op,
        input  [TAM_DATA - 1 : 0]             i_inmediato,
        input  [SHAMT_SIZE - 1 : 0]           i_shamt,
        input  [OP_SIZE - 1 : 0]              i_funct,
        input  [DIRECCION_SIZE - 1 : 0]       i_direccion,
        input  [TAM_DATA - 1 : 0 ]            i_rs,
        input  [TAM_DATA - 1 : 0 ]            i_rt,
        input  [REGISTER_SIZE - 1 : 0 ]       i_rs_dir,
        input  [REGISTER_SIZE - 1 : 0 ]       i_rt_dir,
        input  [REGISTER_SIZE - 1 : 0 ]       i_rd_dir,
        input                                 i_flush,
        
        
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
        output  [REGISTER_SIZE - 1 : 0 ]       o_rd_dir,
        output                                 o_stall
        
);
    reg [OP_SIZE - 1 : 0] op_tmp;
    reg [TAM_DATA - 1 : 0] inmediato_tmp;
    reg [SHAMT_SIZE - 1 : 0] shamt_tmp;
    reg [OP_SIZE - 1 : 0] funct_tmp;
    reg [DIRECCION_SIZE - 1 : 0] direccion_tmp;
    reg [TAM_DATA - 1 : 0] rs_tmp;
    reg [TAM_DATA - 1 : 0] rt_tmp;
    reg [REGISTER_SIZE - 1 : 0] rs_dir_tmp;
    reg [REGISTER_SIZE - 1 : 0] rt_dir_tmp;
    reg [REGISTER_SIZE - 1 : 0] rd_dir_tmp;
    reg [PC_SIZE - 1 : 0] pc_tmp;
    reg                   stall_tmp = 0;


always @(negedge i_clk)
begin
    if(i_flush) begin
        nop_introduce_task;
    end else if(stall_tmp) begin
        nop_introduce_task;
        end else begin
        continue_pipeline_task;
    end 
end

always @(posedge i_clk)
begin
     if((o_op == 6'b100000 || o_op == 6'b100001 || o_op == 6'b100011) &&
        (o_rt_dir == i_rs_dir || o_rt_dir == i_rt_dir)) 
        
        begin
            stall_tmp <= 1;
        end

end


task nop_introduce_task;
    begin
        op_tmp <= 0;
        inmediato_tmp <= 0;
        shamt_tmp <= 0;
        funct_tmp <= 0;
        direccion_tmp <= 0;
        rs_dir_tmp <= 0;
        rt_dir_tmp <= 0;
        rd_dir_tmp <= 0;
        pc_tmp <= 0;
        rs_tmp <= 0;
        rt_tmp <= 0;
        stall_tmp <= 0;
    end
endtask

task continue_pipeline_task;
    begin
        op_tmp <= i_op;
        inmediato_tmp <= i_inmediato;
        shamt_tmp <= i_shamt;
        funct_tmp <= i_funct;
        direccion_tmp <= i_direccion;
        rs_dir_tmp <= i_rs_dir;
        rt_dir_tmp <= i_rt_dir;
        rd_dir_tmp <= i_rd_dir;
        pc_tmp <= i_pc;
        rs_tmp <= i_rs;
        rt_tmp <= i_rt;
        stall_tmp <= 0;
    end
endtask


   assign o_op =                op_tmp;
   assign o_inmediato =         inmediato_tmp;
   assign o_shamt =             shamt_tmp;
   assign o_funct =             funct_tmp;
   assign o_direccion =         direccion_tmp;
   assign o_rs_dir =            rs_dir_tmp;
   assign o_rt_dir =            rt_dir_tmp;
   assign o_rd_dir =            rd_dir_tmp;
   assign o_pc =                pc_tmp;
   assign o_rs =                rs_tmp;
   assign o_rt =                rt_tmp;
   assign o_stall =             stall_tmp;
   
endmodule
