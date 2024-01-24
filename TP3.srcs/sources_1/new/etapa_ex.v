`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.01.2024 14:59:13
// Design Name: 
// Module Name: etapa_ex
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


module etapa_ex#(
        parameter   PC_SIZE = 11,
        parameter   TAM_DATA = 32,
        parameter   BYTE = 8,
        parameter   REGISTER_SIZE = 5,
        parameter   OP_SIZE = 6,
        parameter   INMEDIATE_SIZE = 16,
        parameter   DIRECCION_SIZE = 26,
        parameter   ALU_CTRL = 5,
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
        input  [REGISTER_SIZE - 1 : 0 ]       i_rt_dir,
        input  [REGISTER_SIZE - 1 : 0 ]       i_rd_dir,
        
        output  [PC_SIZE - 1 : 0 ]             o_pc,
        output  [TAM_DATA - 1 : 0 ]            o_res,
        output  [TAM_DATA - 1 : 0 ]            o_rt,
        output  [REGISTER_SIZE - 1 : 0 ]       o_wb_reg_write,
        output  [ALU_CTRL - 1  : 0 ]           o_alu_ctrl,
        output                                 o_branch,
        output  [PC_SIZE - 1 : 0]              o_branch_dir

    );
    
    reg [TAM_DATA - 1 : 0] rs_tmp;
    reg [TAM_DATA - 1 : 0] rt_tmp;
    reg [OP_SIZE - 1 : 0] funct_tmp;
    reg [OP_SIZE - 1 : 0] op_tmp;
    reg [REGISTER_SIZE - 1 : 0] rt_dir_tmp;
    reg [REGISTER_SIZE - 1 : 0] rd_dir_tmp;
    reg [PC_SIZE - 1 : 0] pc_tmp;
    reg [TAM_DATA - 1 : 0] inmediato_tmp;
    reg [SHAMT_SIZE - 1 : 0] shamt_tmp;
    reg [DIRECCION_SIZE - 1 : 0] direccion_tmp;
    
    
    ALU alu(
        rs_tmp,
        rt_tmp,
        inmediato_tmp,
        shamt_tmp,
        direccion_tmp,
        {op_tmp, funct_tmp}
    );
    
    
    always @(posedge i_clk)
    begin
            rs_tmp <= i_rs;
            rt_tmp <= i_rt;
            funct_tmp <= i_funct;
            op_tmp <= i_op;
            pc_tmp <= i_pc;
            rt_dir_tmp <= i_rt_dir;
            rd_dir_tmp <= i_rd_dir;
            inmediato_tmp <= i_inmediato;
            shamt_tmp <= i_shamt;
            direccion_tmp <= i_direccion;
            
    end
    
    assign o_rt =                    rt_tmp;
    assign o_wb_reg_write = (alu.o_ins_type[7 : 5] == 3'b110)   ? 31     :
                            (alu.o_ins_type[2] == 1'b1)         ? i_rt_dir : //los load salen asi
                            (alu.o_ins_type[4 : 0] == 5'b00000) ? i_rd_dir : //las operaciones tipo R salen asi
                            0; 
    //assign o_wb_reg_write =          (alu.o_ins_type[3] == 1 || alu.o_ins_type[2] == 1) ? i_rt_dir : i_rd_dir;//true=TIPO I, false= TIPO R o store
    
    assign o_res =                   (alu.o_ins_type[7 : 5] == 3'b110) ? (i_pc + 1) :
                                     (alu.o_ins_type[7 : 5] == 3'b111) ? (i_pc + 1) : //ni idea si esto funcionaria bien en caso limite
                                      alu.o_res; //siempre que no haya que guardar la direccion de retorno
                                      
    assign o_branch_dir =             (alu.o_ins_type[7 : 5] == 3'b100) ? (pc_tmp + alu.o_res) : //pc = pc + offset
                                       alu.o_res;        //pc = lo que me devuelva la ALU
                                      
    assign o_alu_ctrl =              alu.o_ins_type;
    assign o_pc =                    pc_tmp;
    assign o_branch =                alu.o_ins_type[7];
   
endmodule
