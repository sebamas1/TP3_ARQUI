`timescale 1ns / 1ps
//en el rising edge las etapas escribe, en el falling leen

module Instruction_fetch#(
        parameter   TAM_DATA = 32,
        parameter   BYTE = 8
    )
    (
        input                           i_clk,
        input                           i_reset,
        output  [TAM_DATA - 1 : 0]      o_instruccion,
        output  [TAM_DATA - 1 : 0]      o_pc_value

);

reg [TAM_DATA - 1 : 0] program_counter = 0;
reg [TAM_DATA - 1 : 0] instruccion;
wire [TAM_DATA - 1 : 0] instruccion_tmp;


ROM mem_inst(
    .i_addra(program_counter), //La salida del PC entra a la mem
    .i_dina(32'b0),
    .i_clka(i_clk),
    .i_wea(1'b0),
    .i_ena(1'b1),
    .i_rsta(1'b0),                           // Output reset (does not affect memory contents)
    .i_regcea(1'b1),
    .o_douta(instruccion_tmp),
    .o_halt()
);

always @(posedge i_clk)
begin
    if(program_counter < 2048)
    begin
        program_counter <= program_counter + 1;
    end
    else begin
        program_counter <= 0;
    end
    instruccion <= instruccion_tmp;

end

assign o_pc_value   =   program_counter;
assign o_instruccion = instruccion;

endmodule