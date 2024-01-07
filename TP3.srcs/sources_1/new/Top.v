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
    latch_ifid.o_instruccion
    );
endmodule
