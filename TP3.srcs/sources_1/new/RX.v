`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.10.2022 16:17:17
// Design Name: 
// Module Name: RX
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


module RX(

    input i_clk,
    input i_tick,
    input i_rx,
    input i_reset,
    output [7 : 0] o_dato_recibido,
    output o_recibido
    );
          
    localparam IDDLE_STATE = 4'b0000;
    localparam WAITING_STATE = 4'b0001;
    localparam BIT0_STATE = 4'b0100;
    localparam BIT1_STATE = 4'b0101;
    localparam BIT2_STATE = 4'b0110;
    localparam BIT3_STATE = 4'b0111;
    localparam BIT4_STATE = 4'b1000;
    localparam BIT5_STATE = 4'b1001;
    localparam BIT6_STATE = 4'b1010;
    localparam BIT7_STATE = 4'b1011;
    localparam STOP_STATE = 4'b1100;
    
    reg [3 : 0] present_state = IDDLE_STATE;
    reg [3 : 0] next_state = IDDLE_STATE;
    reg [7 : 0] dato;
    reg [3 : 0] contador_ticks = 4'b0000;
    reg recibido = 1'b0;
    
    
    always @(posedge i_clk) //hay que ver que venga desde un alto y empiece con un flanco descendente
        begin
        //$display("dato: %d", dato);
            if(i_reset == 1)
                present_state <= IDDLE_STATE;
            else 
                present_state <= next_state;
        end
        
     always @(posedge i_tick)
     begin
        contador_ticks <= contador_ticks + 1;
        case(present_state)
            IDDLE_STATE:
            begin
                if(i_rx == 0)
                     begin
                         next_state <= WAITING_STATE;
                         contador_ticks <= 0;
                     end //hay que ver si tengo que resetear el dato para que el step no se rompa
                recibido <= 1'b0;
            end
            WAITING_STATE:
            
                case(i_rx)
                    0:
                        begin
                            if(contador_ticks == 7)
                                begin
                                    next_state <= BIT0_STATE;
                                    contador_ticks <= 0;                        
                                end
                        end
                     1: 
                        begin
                            next_state <= IDDLE_STATE;
                            contador_ticks <= 0;
                        end
                      default:
                        begin
                            next_state <= IDDLE_STATE;
                            contador_ticks <= 0;
                        end
                   endcase
                
            BIT0_STATE:
                begin
                    if(contador_ticks == 15)
                    begin
                        next_state <= BIT1_STATE;
                        dato[0] <= i_rx;
                        contador_ticks <= 0;
                       //  $display("00000000000 i_rx: %d", i_rx); 
                    end
                end
            
            BIT1_STATE:
                begin
                    if(contador_ticks == 15)
                    begin
                        next_state <= BIT2_STATE;
                        dato[1] <= i_rx;
                        contador_ticks <= 0;
                      //   $display("1111111111 i_rx: %d", i_rx);
                    end
                end
            BIT2_STATE:
                begin
                    if( contador_ticks == 15)
                    begin
                        next_state <= BIT3_STATE;
                        dato[2] <= i_rx;
                        contador_ticks <= 0;
                       //  $display("22222222222 i_rx: %d", i_rx); 
                    end
                end
            BIT3_STATE:
                begin 
                    if(contador_ticks == 15)
                    begin
                        next_state <= BIT4_STATE;
                        dato[3] <= i_rx;
                        contador_ticks <= 0;
                      //   $display("3333333333 i_rx: %d", i_rx); 
                    end
                end
            BIT4_STATE:
                begin
                    if(contador_ticks == 15)
                    begin
                        next_state <= BIT5_STATE;
                        dato[4] <= i_rx;
                        contador_ticks <= 0;
                        // $display("4444444444444 i_rx: %d", i_rx); 
                    end
                end
            BIT5_STATE:
                begin
                    if(contador_ticks == 15)
                    begin
                        next_state <= BIT6_STATE;
                        dato[5] <= i_rx;
                        contador_ticks <= 0;
                        // $display("555555555555 i_rx: %d", i_rx); 
                    end
                end
            BIT6_STATE:
                begin
                    if(contador_ticks == 15)
                    begin
                        next_state <= BIT7_STATE;
                        dato[6] <= i_rx;
                        contador_ticks <= 0;
                     //   $display("66666666666 i_rx: %d", i_rx); 
                    end
                end
            BIT7_STATE:
                begin
                    if(contador_ticks == 15)
                    begin
                        next_state <= STOP_STATE;
                        dato[7] <= i_rx;
                        contador_ticks <= 0;
                       // $display("777777777777777 i_rx: %d", i_rx); 
                    end
                end
            STOP_STATE:
            case(i_rx)
                1:
                    begin
                        if(contador_ticks == 15)
                            begin
                                next_state <= IDDLE_STATE;
                                contador_ticks <= 0;    
                                //$display("exitoo: %d", dato); 
                                recibido <= 1'b1;                
                            end
                    end
                 0: 
                    begin
                         if(contador_ticks == 15)
                         begin
                             //$display("es ceroooo el i_rx: %d", i_rx); 
                            dato[7 : 0] <= 8'b00000000;
                            next_state <= IDDLE_STATE;
                            contador_ticks <= 0;
                         end
                       
                    end
                  default:
                    begin
                        next_state <= IDDLE_STATE;
                        contador_ticks <= 0;
                    end
               endcase
            endcase
     end
    assign o_dato_recibido = dato;
    assign o_recibido = recibido;
        
    endmodule