`timescale 1ns / 1ps
//en el rising edge las etapas escribe, en el falling leen

module Instruction_fetch#(
        parameter   PC_SIZE = 11, //para los 2048
        parameter   TAM_DATA = 32,
        parameter   BYTE = 8
    )
    (
        input                           i_clk,
        input                           i_reset,
        input                           i_branch,
        input   [PC_SIZE - 1 : 0]       i_branch_addr,
        
        output  [TAM_DATA - 1 : 0]      o_instruccion,
        output  [PC_SIZE - 1 : 0]       o_pc_value

);

reg [PC_SIZE - 1 : 0] program_counter = 0;


ROM mem_inst(
    .i_addra({21'b0 ,program_counter}), //La salida del PC entra a la mem
    .i_dina(32'b0),
    .i_clka(i_clk),
    .i_wea(1'b0),
    .i_ena(1'b1),
    .i_rsta(1'b0),                           // Output reset (does not affect memory contents)
    .i_regcea(1'b1),
    .o_douta(),
    .o_halt()
);

always @(posedge i_clk)
begin
    if(program_counter < 2048)
    begin
       program_counter <= i_branch == 1 ?  i_branch_addr :  program_counter + 1;
    end
    else begin
       program_counter <= i_branch == 1 ?  i_branch_addr :  0;
    end

end

assign o_pc_value   =   program_counter - 1;//es una negrada esto
assign o_instruccion =  mem_inst.o_douta;

endmodule