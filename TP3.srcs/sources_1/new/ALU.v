`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.01.2024 23:29:38
// Design Name: 
// Module Name: ALU
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


module ALU#(
            parameter BUS_SIZE = 32,
            parameter CTRL_SIZE = 5,
            parameter SHAMT_SIZE = 5
        )
        (
            input [BUS_SIZE - 1 : 0]      i_operando_1,
            input [BUS_SIZE - 1 : 0]      i_operando_2,
            input [BUS_SIZE - 1 : 0]      i_operando_i,
            input [SHAMT_SIZE - 1 : 0]    i_shamt,
            input [11 : 0]                i_operacion,
            output [BUS_SIZE - 1 : 0]     o_res,
            output [CTRL_SIZE - 1 : 0]    o_ins_type,
            output                        o_branch
            
        );
        
        //Operaciones tipo R
        
        localparam OP_ADD = 12'b000000100001;
        localparam OP_SUB = 12'b000000100011;
        localparam OP_AND = 12'b000000100100;
        localparam OP_OR =  12'b000000100101;
        localparam OP_XOR = 12'b000000100110;
        localparam OP_SRA = 12'b000000000011;
        localparam OP_SRL = 12'b000000000010;
        localparam OP_NOR = 12'b000000100111;
        
        localparam OP_SLL =  12'b000000000000;
        localparam OP_SLLV = 12'b000000000100;
        localparam OP_SRLV = 12'b000000000110;
        localparam OP_SRAV = 12'b000000000111;
        localparam OP_SLT =  12'b000000101010;
        
        //Operaciones tipo I
        
        localparam OP_LB =    12'b100000000000;
        localparam OP_LH =    12'b100001000000;
        localparam OP_LW =    12'b100011000000;
        localparam OP_SB =    12'b101000000000;
        localparam OP_SH =    12'b101001000000;
        localparam OP_SW =    12'b101011000000;
        localparam OP_ADDI =  12'b001000000000;
        localparam OP_ANDI =  12'b001100000000;
        localparam OP_ORI =   12'b001101000000;
        localparam OP_XORI =  12'b001110000000;
        localparam OP_LUI =   12'b001111000000;
        localparam OP_SLTI =  12'b001010000000;
        localparam OP_BEQ =   12'b000100000000;
        
        reg [BUS_SIZE - 1 : 0] operador_1; 
        reg [BUS_SIZE - 1 : 0] operador_2; 
        reg [BUS_SIZE - 1 : 0] operador_i; 
        reg [SHAMT_SIZE - 1 : 0] shamt;
        reg [11 : 0] operacion; 
        reg[BUS_SIZE-1 : 0] resultado;
        reg [CTRL_SIZE - 1 : 0] ins_type;
        reg                      branch_tmp = 0;
        
        //assign o_res[BUS_SIZE] = resultado[BUS_SIZE]; //carry despues fijate si te interesa agregar la logica del zero y carry
       // assign o_res[BUS_SIZE + 1] = ~| resultado[BUS_SIZE - 1 : 0]; //zero acordate que esto lo pegabas al res, por lo que era 2 bits mas grande de lo que es ahora
        assign o_res[BUS_SIZE - 1 : 0] = resultado;
        assign o_ins_type = ins_type;
        assign o_branch = branch_tmp;
    
            always @(*)  
        begin  
             
            operador_1 = i_operando_1;
            operador_2 = i_operando_2;//que onda, por que esto no es un assign?
            operador_i = i_operando_i;
            shamt = i_shamt;
            
            branch_tmp = 0;
            
            if(i_operacion[11 : 6] == 6'b000000)
            begin
                operacion = i_operacion;
            end
            else begin
                operacion = {i_operacion[11 : 6], 6'b000000};
            end
        end
            
            always @(i_operando_1, i_operando_2, i_operacion) 
       begin     
           // resultado[BUS_SIZE] <= 0;//que es esto? no daria error porque resultado ahora es mas chico?
           
            
            case(operacion)
                OP_ADD:
                begin
                    resultado <= operador_1 + operador_2;//cualquier cosa fijate en el tp si queres volverlo a como estaba antes     
                    ins_type <= 5'b00000;  //el mas significativo es el memory enable, el siguiente es el write enable y  
                                          // el siguente el output enable, los otros dos son 
                                        //para el mux; oo es 32 bits, 01 es 16 bits, 10 es 8 bits, todo esto para la siguiente etapa
                end
                     
                OP_SUB:
                begin
                    resultado <= operador_1 - operador_2 ;
                    ins_type <= 5'b00000;
                end
                
                OP_AND: 
                begin
                    resultado <= operador_1 & operador_2;
                    ins_type <= 5'b00000;
                end
                
                OP_OR:
                begin
                    resultado <= operador_1 | operador_2;
                    ins_type <= 5'b00000;
                end
                
                OP_XOR:
                begin
                    resultado <= operador_1 ^ operador_2;
                    ins_type <= 5'b00000;
                end
                
                OP_SRA:
                begin
                    resultado <= operador_2 >>> shamt; //shiftea sa lugares el operador 2 y lo guarda en rd
                    ins_type <= 5'b00000;
                end
                
                OP_SRL:
                begin
                    resultado <= operador_2 >> shamt;
                    ins_type <= 5'b00000;
                end
                
                OP_NOR:
                begin
                    resultado <= ~(operador_1 | operador_2);
                    ins_type <= 5'b00000;
                end
                
                OP_SLL:
                begin
                    resultado <= operador_2 << shamt;
                    ins_type <= 5'b00000;
                end
                
                OP_SLLV:
                begin
                    resultado <= operador_1 << operador_2;//sera asi?
                    ins_type <= 5'b00000;
                end
                
                OP_SRLV:
                begin
                    resultado <= operador_1 >> operador_2;
                    ins_type <= 5'b00000;
                end
                
                OP_SRAV:
                begin
                    resultado <= operador_1 >>> operador_2;
                    ins_type <= 5'b00000;
                end
                
                OP_SLT:
                begin
                    resultado <= operador_1 < operador_2; //setea un registro si op1 < op2
                    ins_type <= 5'b00000;
                end
                
                OP_LB:
                begin
                    resultado <= operador_1 + operador_i;//bueno aca tenes que hacer que se meta el inmediato a la ALU y que se sume con rs, supongo que tenes que devolver
                    ins_type <= 5'b10110;// este va a ser un read enable
                end 
                
                OP_LH:
                begin
                    resultado <= operador_1 + operador_i;
                    ins_type <= 5'b10101;// este va a ser un read enable
                end   
                  
                OP_LW:
                begin
                    resultado <= operador_1 + operador_i;
                    ins_type <= 5'b10100;
                end 
                
                OP_SB:
                begin
                    resultado <= operador_1 + operador_i;
                    ins_type <= 5'b11010; //este va a ser un write enable
                end  
                   
                OP_SH:
                begin
                    resultado <= operador_1 + operador_i;
                    ins_type <= 5'b11001;
                end   
                  
                OP_SW:
                begin
                    resultado <= operador_1 + operador_i;
                    ins_type <= 5'b11000;
                end 
                
                OP_ADDI:
                begin
                    resultado <= operador_1 + operador_i;
                    ins_type <= 5'b00100;//este codigo indica que es una operacion tipo I para que se guarde el res en rt
                end 
                
                OP_ANDI:
                begin
                    resultado <= operador_1 & operador_i;
                    ins_type <= 5'b00100;
                end 
                
                OP_ORI:
                begin
                    resultado <= operador_1 | operador_i;
                    ins_type <= 5'b00100;
                end 
 
                OP_XORI:
                begin
                    resultado <= operador_1 ^ operador_i;
                    ins_type <= 5'b00100;
                end 
                
                OP_LUI:
                begin
                    resultado <= operador_i << 16;
                    ins_type <= 5'b00100; //esto es para reconocer que es tipo I 
                end 
                
                OP_SLTI:
                begin
                    resultado <= operador_1 < operador_i; //setea un registro si op1 < opi
                    ins_type <= 5'b00100;
                end
                
                OP_BEQ: //si op1 == op2 --> pc += (inmediato << 2)
                begin
                if(operador_1 == operador_2) begin
                    resultado <= operador_i << 2;
                    ins_type <= 5'b01000;
                    branch_tmp = 1;
                end else begin
                    resultado <= 1;
                    ins_type <= 5'b01000; //marco que es un store para que no haga nada en wb, pero no le habilito la memoria, por lo que no hace nada
                end
                end
                
                default: resultado <= operador_1 & operador_2 ; 
            endcase
        end
    endmodule
