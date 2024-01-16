`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.01.2024 22:25:03
// Design Name: 
// Module Name: Top
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


module Top(
    input i_clock,
    input i_reset
    );
    
    wire b = 0;
    
    Instruction_fetch etapa_if(
    i_clock,
    i_reset
    );
    
    IF_ID latch_ifid(
    i_clock,
    i_reset,
    etapa_if.o_pc_value,
    etapa_if.o_instruccion
    );
    
    Instruction_decode etapa_id(
    i_clock,
    i_reset,
    latch_ifid.o_instruccion,
    latch_ifid.o_pc_value,
    
    b,
    wb.o_res,
    wb.o_rd_dir
    );
    
    latch_idex latch_idex(
    i_clock,
    i_reset,
    etapa_id.o_pc,
    etapa_id.o_op,
    etapa_id.o_inmediato,
    etapa_id.o_shamt,
    etapa_id.o_funct,
    etapa_id.o_direccion,
    etapa_id.o_rs,
    etapa_id.o_rt,
    etapa_id.o_rd_dir
    );
    
    etapa_ex ex(
    i_clock,
    i_reset,
    latch_idex.o_pc,
    latch_idex.o_op,
    latch_idex.o_inmediato,
    latch_idex.o_shamt,
    latch_idex.o_funct,
    latch_idex.o_direccion,
    latch_idex.o_rs,
    latch_idex.o_rt,
    latch_idex.o_rd_dir
     
    );
    latch_exmem exmem(
    i_clock,
    i_reset,
    ex.o_pc,
    ex.o_res,
    ex.o_rd_dir
    );
    
    Etapa_MEM mem(
    i_clock,
    i_reset,
    
    exmem.o_pc,
    exmem.o_res,
    exmem.o_rd_dir
    
    );
    latch_memwb memwb(
    i_clock,
    i_reset,
    
    mem.o_pc,
    mem.o_res,
    mem.o_rd_dir
    
    );
    
   etapa_wb wb(
    i_clock,
    i_reset,
    
    memwb.o_pc,
    memwb.o_res,
    memwb.o_rd_dir
    
    );

endmodule