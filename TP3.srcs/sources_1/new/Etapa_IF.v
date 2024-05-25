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
        input                           i_stall,
        input  [TAM_DATA - 1 : 0]       i_instruccion,
        input  [TAM_DATA - 1 : 0]       i_instruccion_addr,
        input                           i_wea,
        input                           i_start_pipeline,
        
        output  [TAM_DATA - 1 : 0]      o_instruccion,
        output  [PC_SIZE - 1 : 0]       o_pc_value,
        output  reg                     o_end_pipeline

);
initial begin
o_end_pipeline = 0;
end

reg [PC_SIZE - 1 : 0] program_counter = 0;


ROM mem_inst(
    .i_addra(i_wea ? i_instruccion_addr : 
    o_end_pipeline ? i_instruccion_addr : {21'b0 ,program_counter}), //La salida del PC entra a la mem
    .i_dina(i_instruccion),
    .i_clka(i_clk),
    .i_wea(i_wea),
    .i_ena(!i_stall),
    .i_rsta(1'b0),                           // Output reset (does not affect memory contents)
    .i_regcea(1'b1),
    .o_douta(),
    .o_halt()
);

always @(posedge i_clk)
begin
    if(i_start_pipeline == 1)
    begin
        if(program_counter < 2048)
        begin
            program_counter <= i_branch == 1 ?  i_branch_addr :  
                                                program_counter + 1;
        end else begin
        program_counter <= i_branch == 1 ?  i_branch_addr :  
                            0;
        end
        if(mem_inst.o_douta == 32'b00000000000000000000000000000001) o_end_pipeline <= 1;
    end
end

// always @(posedge i_stall)
// begin
//     program_counter <= program_counter - 1;
// end

assign o_pc_value   =   program_counter - 1;//es una negrada esto
assign o_instruccion =  mem_inst.o_douta;

endmodule