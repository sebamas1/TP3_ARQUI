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
            parameter BUS_SIZE = 32
        )
        (
            input [BUS_SIZE - 1 : 0] i_operando_1,
            input [BUS_SIZE - 1 : 0] i_operando_2,
            input [5 : 0] i_operacion,
            output [BUS_SIZE - 1 : 0] o_res
            
        );
        
        localparam OP_ADD = 6'b100001;
        localparam OP_SUB = 6'b100011;
        localparam OP_AND = 6'b100100;
        localparam OP_OR = 6'b100101;
        localparam OP_XOR = 6'b100110;
        localparam OP_SRA = 6'b000011;
        localparam OP_SRL = 6'b000010;
        localparam OP_NOR = 6'b100111;
        
        localparam OP_SLL = 6'b000000;
        localparam OP_SLLV = 6'b000100;
        localparam OP_SRLV = 6'b000110;
        localparam OP_SRAV = 6'b000111;
        localparam OP_SLT = 6'b101010;//set if less than
        
        
        reg [BUS_SIZE - 1 : 0] operador_1; 
        reg [BUS_SIZE - 1 : 0] operador_2; 
        reg [5 : 0] operacion; 
        reg[BUS_SIZE-1 : 0] resultado;
        
        
        //assign o_res[BUS_SIZE] = resultado[BUS_SIZE]; //carry despues fijate si te interesa agregar la logica del zero y carry
       // assign o_res[BUS_SIZE + 1] = ~| resultado[BUS_SIZE - 1 : 0]; //zero acordate que esto lo pegabas al res, por lo que era 2 bits mas grande de lo que es ahora
        assign o_res[BUS_SIZE - 1 : 0] = resultado;
    
            always @(*)  
        begin       
            operador_1 = i_operando_1;
            operador_2 = i_operando_2;//que onda, por que esto no es un assign?
            operacion = i_operacion;
        end
            
            always @(i_operando_1, i_operando_2, i_operacion) 
       begin     
           // resultado[BUS_SIZE] <= 0;//que es esto? no daria error porque resultado ahora es mas chico?
            
            case(operacion)
                OP_ADD:
                    resultado <= operador_1 + operador_2;//cualquier cosa fijate en el tp si queres volverlo a como estaba antes           
                OP_SUB:
                    resultado <= operador_1 - operador_2 ;
                OP_AND: 
                    resultado <= operador_1 & operador_2;
                OP_OR:
                    resultado <= operador_1 | operador_2;
                OP_XOR:
                    resultado <= operador_1 ^ operador_2;
                OP_SRA:
                    resultado <= operador_1 >>> 1;
                OP_SRL:
                    resultado <= operador_1 >> 1;
                OP_NOR:
                    resultado <= ~(operador_1 | operador_2);
                OP_SLL:
                    resultado <= operador_1 << 1;
                OP_SLLV:
                    resultado <= operador_1 << operador_2;//sera asi?
                OP_SRLV:
                    resultado <= operador_1 >> operador_2;
                OP_SRAV:
                    resultado <= operador_1 >>> operador_2;
                OP_SLT:
                    resultado <= operador_1 << operador_2; //setea un registro si op1 < op2 COMO HAGO ESO?  
                default: resultado <= operador_1 & operador_2 ; 
            endcase
        end
    endmodule
