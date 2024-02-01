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
    
    Instruction_fetch etapa_if(
        i_clock,
        i_reset,
        ex.o_branch,
        ex.o_branch_dir,
        dtu.o_stall 
    );
    
    IF_ID latch_ifid(
        i_clock,
        i_reset,
        etapa_if.o_pc_value,
        etapa_if.o_instruccion,
        ex.o_branch, //esta es la señal de flush
        dtu.o_stall
    );
    
    Instruction_decode etapa_id(
        i_clock,
        i_reset,
        latch_ifid.o_instruccion,
        latch_ifid.o_pc_value,
        
        wb.o_reg_write_enable,
        wb.o_res,
        wb.o_wb_reg_write
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
        etapa_id.o_rs_dir,
        etapa_id.o_rt_dir,
        etapa_id.o_rd_dir,
        ex.o_branch,
        dtu.o_stall
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
        latch_idex.o_rt_dir,
        latch_idex.o_rd_dir,
        
        fu.o_mem_res_rs_enable,
        fu.o_wb_res_rs_enable,
        fu.o_mem_res_rt_enable,
        fu.o_wb_res_rt_enable,
        fu.o_mem_res,
        fu.o_wb_res
     
    );
    latch_exmem exmem(
        i_clock,
        i_reset,
        ex.o_pc,
        ex.o_res,
        ex.o_alu_ctrl,
        ex.o_rt,
        ex.o_wb_reg_write
    );
    
    Etapa_MEM mem(
        i_clock,
        i_reset,
        
        exmem.o_pc,
        exmem.o_res,
        exmem.o_rt,
        exmem.o_wb_reg_write,
        exmem.o_alu_ctrl
    
    );
    latch_memwb memwb(
        i_clock,
        i_reset,
        
        mem.o_pc,
        mem.o_res,
        mem.o_wb_reg_write,
        mem.o_reg_write_enable
    
    );
    
   etapa_wb wb(
        i_clock,
        i_reset,
        
        memwb.o_pc,
        memwb.o_res,
        memwb.o_wb_reg_write,
        memwb.o_reg_write_enable
        
    );
    
    Forwarding_unit fu(
        latch_idex.o_rs_dir,
        latch_idex.o_rt_dir,
        exmem.o_wb_reg_write,
        memwb.o_wb_reg_write,
        exmem.o_res,
        memwb.o_res,
        exmem.o_alu_ctrl[3],
        memwb.o_reg_write_enable
        
    );
    
    Data_hazard_detection_unit dtu(
        ex.o_alu_ctrl,
        ex.o_wb_reg_write,
        etapa_id.o_rs_dir,
        etapa_id.o_rt_dir //por el lugar desde que el que tomo los datos, esto va a ser detectado en un rising edge
    );

endmodule
