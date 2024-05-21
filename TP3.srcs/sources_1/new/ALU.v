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
            parameter CTRL_SIZE = 8,
            parameter SHAMT_SIZE = 5,
            parameter DIRECCION_SIZE = 26
        )
        (
            input [BUS_SIZE - 1 : 0]          i_operando_1,
            input [BUS_SIZE - 1 : 0]          i_operando_2,
            input [BUS_SIZE - 1 : 0]          i_operando_i,
            input [SHAMT_SIZE - 1 : 0]        i_shamt,
            input [DIRECCION_SIZE - 1 : 0]    i_direccion,
            input [11 : 0]                    i_operacion,
            output [BUS_SIZE - 1 : 0]         o_res,
            output [CTRL_SIZE - 1 : 0]        o_ins_type
            
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
        localparam OP_BNE =   12'b000101000000;
        
        //Tipo J
        
        localparam OP_J =     12'b000010000000;
        localparam OP_JAL =   12'b000011000000;
        
        localparam OP_JR =    12'b000000001000;
        localparam OP_JALR =  12'b000000001001;
        
        
        reg [BUS_SIZE - 1 : 0]        operador_1; 
        reg [BUS_SIZE - 1 : 0]        operador_2; 
        reg [BUS_SIZE - 1 : 0]        operador_i; 
        reg [SHAMT_SIZE - 1 : 0]      shamt;
        reg [11 : 0] operacion; 
        reg[BUS_SIZE-1 : 0]           resultado;
        reg [CTRL_SIZE - 1 : 0]       ins_type;
        reg [DIRECCION_SIZE - 1 : 0]  direccion_tmp;
        
        //assign o_res[BUS_SIZE] = resultado[BUS_SIZE]; //carry despues fijate si te interesa agregar la logica del zero y carry
       // assign o_res[BUS_SIZE + 1] = ~| resultado[BUS_SIZE - 1 : 0]; //zero acordate que esto lo pegabas al res, por lo que era 2 bits mas grande de lo que es ahora
        assign o_res[BUS_SIZE - 1 : 0] = resultado;
        assign o_ins_type = ins_type;
        
        /* Antes esto tenia una lista de sensibilidad, pero lo cambie porque si venian 2 instrucciones iguales, como eran 2 ADDI seguidos
        que tenian su rt igual, su inmediato igual, en fin, todo igual, pero que yo ponia una direccion de destino distinta, no se
        ejecutaba este always porque no habia cambio en los operadores*/    
            always @(*)
       begin     
           // resultado[BUS_SIZE] <= 0;//que es esto? no daria error porque resultado ahora es mas chico?
            operador_1 = i_operando_1;
            operador_2 = i_operando_2;//que onda, por que esto no es un assign?
            operador_i = i_operando_i;
            direccion_tmp = i_direccion;
            shamt = i_shamt
            ;
            ins_type = 8'b0;
            
            if(i_operacion[11 : 6] == 6'b000000)
            begin
                operacion = i_operacion;
            end
            else begin
                operacion = {i_operacion[11 : 6], 6'b000000};
            end
            
            case(operacion)
                OP_ADD:
                begin
                    resultado = operador_1 + operador_2;//cualquier cosa fijate en el tp si queres volverlo a como estaba antes     
                    ins_type = 8'b00000000;  //el mas significativo es el memory enable, el siguiente es el write enable y  
                                          // el siguente el output enable, los otros dos son 
                                        //para el mux; oo es 32 bits, 01 es 16 bits, 10 es 8 bits, todo esto para la siguiente etapa
                end
                     
                OP_SUB:
                begin
                    resultado = operador_1 - operador_2 ;
                    ins_type = 8'b00000000;
                end
                
                OP_AND: 
                begin
                    resultado = operador_1 & operador_2;
                    ins_type = 8'b00000000;
                end
                
                OP_OR:
                begin
                    resultado = operador_1 | operador_2;
                    ins_type = 8'b00000000;
                end
                
                OP_XOR:
                begin
                    resultado = operador_1 ^ operador_2;
                    ins_type = 8'b00000000;
                end
                
                OP_SRA:
                begin
                    resultado = operador_2 >>> shamt; //shiftea sa lugares el operador 2 y lo guarda en rd
                    ins_type = 8'b00000000;
                end
                
                OP_SRL:
                begin
                    resultado = operador_2 >> shamt;
                    ins_type = 8'b00000000;
                end
                
                OP_NOR:
                begin
                    resultado = ~(operador_1 | operador_2);
                    ins_type = 8'b00000000;
                end
                
                OP_SLL:
                begin
                    resultado = operador_2 << shamt;
                    ins_type = 8'b00000000;
                end
                
                OP_SLLV:
                begin
                    resultado = operador_1 << operador_2;//sera asi?
                    ins_type = 8'b00000000;
                end
                
                OP_SRLV:
                begin
                    resultado = operador_1 >> operador_2;
                    ins_type = 8'b00000000;
                end
                
                OP_SRAV:
                begin
                    resultado = operador_1 >>> operador_2;
                    ins_type = 8'b00000000;
                end
                
                OP_SLT:
                begin
                    resultado = operador_1 < operador_2; //setea un registro si op1 < op2
                    ins_type = 8'b00000000;
                end
                
                OP_LB:
                begin
                    resultado = operador_1 + operador_i;//bueno aca tenes que hacer que se meta el inmediato a la ALU y que se sume con rs, supongo que tenes que devolver
                    ins_type = 8'b00010110;// este va a ser un read enable
                end 
                
                OP_LH:
                begin
                    resultado = operador_1 + operador_i;
                    ins_type = 8'b00010101;// este va a ser un read enable
                end   
                  
                OP_LW:
                begin
                    resultado = operador_1 + operador_i;
                    ins_type = 8'b00010100;
                end 
                
                OP_SB:
                begin
                    resultado = operador_1 + operador_i;
                    ins_type = 8'b00011010; //este va a ser un write enable
                end  
                   
                OP_SH:
                begin
                    resultado = operador_1 + operador_i;
                    ins_type = 8'b00011001;
                end   
                  
                OP_SW:
                begin
                    resultado = operador_1 + operador_i;
                    ins_type = 8'b00011000;
                end 
                
                OP_ADDI:
                begin
                    resultado = operador_1 + operador_i;
                    ins_type = 8'b00000100;//este codigo indica que es una operacion tipo I para que se guarde el res en rt
                end 
                
                OP_ANDI:
                begin
                    resultado = operador_1 & operador_i;
                    ins_type = 8'b00000100;
                end 
                
                OP_ORI:
                begin
                    resultado = operador_1 | operador_i;
                    ins_type = 8'b00000100;
                end 
 
                OP_XORI:
                begin
                    resultado = operador_1 ^ operador_i;
                    ins_type = 8'b00000100;
                end 
                
                OP_LUI:
                begin
                    resultado = operador_i << 16;
                    ins_type = 8'b00000100; //esto es para reconocer que es tipo I 
                end 
                
                OP_SLTI:
                begin
                    resultado = operador_1 < operador_i; //setea un registro si op1 < opi
                    ins_type = 8'b00000100;
                end
                
                OP_BEQ: //si op1 == op2 --> pc += (inmediato << 2)
                begin
                if(operador_1 == operador_2) begin
                    resultado = operador_i << 2;
                    ins_type = 8'b10001000;
                end else begin
                    resultado = 1; //le pongo 1 para que haga ruido en caso de que se escriba esto en algun lado
                    ins_type = 8'b00001000; //marco que es un store para que no haga nada en wb, pero no le habilito la memoria, por lo que no hace nada
                end
                end
                
                OP_BNE: //si op1 != op2 --> pc += (inmediato << 2)
                begin
                if(operador_1 != operador_2) begin
                    resultado = operador_i << 2;
                    ins_type = 8'b10001000;
                end else begin
                    resultado = 1;
                    ins_type = 8'b00001000; //marco que es un store para que no haga nada en wb, pero no le habilito la memoria, por lo que no hace nada
                end
                end
                
                OP_J: //no entiendo que hace esta instruccion, leer el manual
                begin
                    resultado = {4'b0000, direccion_tmp << 2};
                    ins_type = 8'b10101000;
                end
                
                OP_JAL: //no entiendo que hace esta instruccion, leer el manual
                begin
                    resultado = {4'b0000, direccion_tmp << 2};
                    ins_type = 8'b11000000;
                end
                
                OP_JR:
                begin
                    resultado = operador_1;
                    ins_type = 8'b10101000;
                end
                
                OP_JALR:
                begin
                    resultado = operador_1;
                    ins_type = 8'b11100000;
                end
                
                default: 
                begin
                    resultado = 0;
                    ins_type = 8'b00001000;
                end 
            endcase
        end
    endmodule
