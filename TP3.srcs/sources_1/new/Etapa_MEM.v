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
     parameter   REGISTER_SIZE = 5
)
(
        input                                 i_clk,
        input                                 i_reset,
            
        input  [TAM_DATA - 1 : 0]             i_pc,
        input  [TAM_DATA - 1 : 0]             i_res,
        input  [REGISTER_SIZE - 1 : 0]        i_rd_dir,
        
        output  [TAM_DATA - 1 : 0]             o_res,
        output  [TAM_DATA - 1 : 0]             o_pc,
        output  [REGISTER_SIZE - 1 : 0]        o_rd_dir
    );
    
    RAM mem_datos(
    .i_addra(), //La salida del PC entra a la mem
    .i_dina(32'b0),
    .i_clka(i_clk),
    .i_wea(1'b0),
    .i_ena(1'b1),
    .i_rsta(1'b0),                           // Output reset (does not affect memory contents)
    .i_regcea(1'b1),
    .o_douta(),
    .o_halt()
);

    reg  [REGISTER_SIZE - 1 : 0]        rd_dir_tmp;
    reg  [DIRECCION_SIZE - 1 : 0]       pc_tmp;
    reg  [DIRECCION_SIZE - 1 : 0]       res_tmp;
    
    
always @(posedge i_clk)
begin
    rd_dir_tmp <= i_rd_dir;
    pc_tmp <= i_pc;
    res_tmp <= i_res;
end

        assign o_pc =                    pc_tmp;
        assign o_res =                   res_tmp;
        assign o_rd_dir =                rd_dir_tmp;
endmodule
