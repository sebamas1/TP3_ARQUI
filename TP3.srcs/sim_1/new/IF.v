`timescale 1ns / 1ps


module instruction_fetch#(
        parameter   TAM_DATA = 32,
        parameter   BYTE = 8
    )
    (
        input                           i_clk,
        input                           i_reset,
        input   [TAM_DATA - 1 : 0]      i_new_pc,
        output  [TAM_DATA - 1 : 0]      o_instruction,
        output  [TAM_DATA - 1 : 0]      o_pc_value

);

reg [TAM_DATA - 1 : 0] program_counter = 0;

ROM mem_inst(
    .i_addra(program_counter), //La salida del PC entra a la mem
    .i_dina(32'b0),
    .i_clka(i_clk),
    .i_wra(1'b0),
    .i_ena(1'b1),
    .i_rsta(1'b0),                           // Output reset (does not affect memory contents)
    .i_regcea(1'b1),
    .o_douta(o_instruction),
    .o_halt(1'b0)
);
always @(posedge i_clk)
begin
    program_counter = program_counter + 32;
end

assign o_pc_value   =   program_counter;

endmodule