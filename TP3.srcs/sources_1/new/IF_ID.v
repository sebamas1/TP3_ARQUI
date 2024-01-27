`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.01.2024 22:24:48
// Design Name: 
// Module Name: IF_ID
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



module IF_ID# (
        parameter   PC_SIZE = 11,
        parameter   TAM_DATA = 32,
        parameter   BYTE = 8
    )
    (
        input                           i_clk,
        input                           i_reset,
        input   [PC_SIZE - 1 : 0]       i_new_pc,
        input   [TAM_DATA - 1 : 0]      i_instruccion,
        input                           i_flush,
        input                           i_stall,
        
        
        output  [TAM_DATA - 1 : 0]      o_instruccion,
        output  [PC_SIZE - 1 : 0]       o_pc_value
);

reg [TAM_DATA - 1 : 0] instruccion;
reg [PC_SIZE - 1 : 0] pc;

always @(negedge i_clk)
begin
    if(!i_flush) begin
        if(!i_stall) begin
            instruccion <= i_instruccion;
            pc <= i_new_pc;
        end
    end else begin
        instruccion <= 0;
        pc <= 0;
    end
end

assign o_pc_value = pc;
assign o_instruccion = instruccion;
endmodule
