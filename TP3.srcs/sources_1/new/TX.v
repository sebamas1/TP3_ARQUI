    `timescale 1ns / 1ps
    //////////////////////////////////////////////////////////////////////////////////
    // Company: 
    // Engineer: 
    // 
    // Create Date: 10.03.2023 18:59:56
    // Design Name: 
    // Module Name: TX
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
    
    
    module TX(
        input i_clk,
        input i_tick,
        input i_reset,
        input [31 : 0] i_gpregisters,
        input [31 : 0] i_data_memory,
        input [10 : 0] i_pc,
        output o_dato_enviado,
        output o_tx,
        output [31 : 0] o_next_memory_addr,
        output o_enviar_prev
        );

        initial begin
            enviar_prev = 1'b1;
        end

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
        
        reg [3 : 0] contador_ticks = 5'b00000;
        reg [4 : 0] reg_index = 0;
        reg terminado = 1'b1;
        reg salida = 1;
        reg contador = 1'b0;
        reg enviar_prev = 1'b1;

        reg next_enviar_prev = 1'b1;
        reg next_send_pc = 1'b0;
        reg next_send_data_memory = 1'b0;
        reg [4 : 0] next_rs_dir = 5'b0;
        reg [10 : 0] next_memory_addr = 11'b0;
        
        reg [3 : 0] contadorTX = 4'b0000;
        reg [7 : 0] dato_transmicion = 8'b00000000;
        reg [31 : 0] reg_instruccion = 32'b1111111111111111111111111111111111111111;
        reg [31 : 0] actual_memory_adress = 32'b0;
        reg [4 : 0] rs_dir = 5'b0;
        reg[10 : 0] memory_addr = 11'b0;
        reg send_data_memory = 1'b0;
        reg send_pc = 1'b0;

        always @(posedge i_clk)
        begin
            if(i_reset == 1)
            begin
                present_state <= IDDLE_STATE;
                enviar_prev <= 0;
                send_pc <= 0;
                send_data_memory <= 0;
                rs_dir <= 5'b0;
                memory_addr <= 11'b0;
                next_enviar_prev <= 0;
                next_send_pc <= 0;
                next_send_data_memory <= 0;
                next_rs_dir <= 0;
                next_memory_addr <= 0;
            end
            
            else 
            begin
                present_state <= next_state;
                enviar_prev <= next_enviar_prev;
                send_pc <= next_send_pc;
                send_data_memory <= next_send_data_memory;
                rs_dir <= next_rs_dir;
                memory_addr <= next_memory_addr;

                reg_instruccion <= 
                    send_pc == 1 ? i_pc 
                    : send_data_memory == 1 ? i_data_memory 
                    : i_gpregisters;
                if(contadorTX == 0) dato_transmicion <= reg_instruccion[31 : 24];
                else if(contadorTX == 1) dato_transmicion <= reg_instruccion[23 : 16];
                else if(contadorTX == 2) dato_transmicion <= reg_instruccion[15 : 8];
                else if(contadorTX == 3) dato_transmicion <= reg_instruccion[7 : 0];
            end
        end
        

        always @(posedge i_tick)
        begin
            contador_ticks <= contador_ticks + 1;

            // next_enviar_prev <= enviar_prev;
            // next_send_pc <= send_pc;
            // next_send_data_memory <= send_data_memory;
            // next_rs_dir <= rs_dir;
            // next_memory_addr <= memory_addr;
            case(present_state)
                IDDLE_STATE:
                begin
                    //salida <= 1;
                    if (enviar_prev == 0) 
                    begin //si se activa el envio por primera vez
                        terminado <= 0;
                        next_state <= WAITING_STATE;
                        contador_ticks <= 4'b0000; 
                        if(rs_dir == 5'b11111) begin 
                            next_send_data_memory <= 1;
                            next_memory_addr <= memory_addr + 1;
                            actual_memory_adress <= {21'b0, next_memory_addr};
                            if(memory_addr == 11'b00000001111) begin
                                next_send_pc <= 1;
                                next_enviar_prev <= 1;
                            end
                        end else 
                        begin 
                            next_rs_dir <= rs_dir + 1;
                            actual_memory_adress <= {6'b0, next_rs_dir[4 : 0], 21'b0}; 
                        end
                    end
                end

                WAITING_STATE:
                    begin
                        salida <= 0;
                        if(contador_ticks == 4'b1111)
                            begin
                                next_state <= BIT0_STATE;
                                contador_ticks <= 4'b0000;                     
                            end
                    end
                    
                BIT0_STATE:
                    begin
                        salida <= dato_transmicion[0];
                        if(contador_ticks == 4'b1111)
                        begin
                            next_state <= BIT1_STATE;
                            contador_ticks <= 4'b0000;
                        end
                    end
                
                BIT1_STATE:
                    begin
                        salida <= dato_transmicion[1];
                        if(contador_ticks == 4'b1111)
                        begin
                            next_state <= BIT2_STATE;
                            contador_ticks <= 4'b0000;
                        end
                    end
                BIT2_STATE:
                    begin
                        salida <= dato_transmicion[2];
                        if( contador_ticks == 4'b1111)
                        begin
                            next_state <= BIT3_STATE;
                            contador_ticks <= 4'b0000;
                        end
                    end
                BIT3_STATE:
                    begin 
                        salida <= dato_transmicion[3];
                        if(contador_ticks == 4'b1111)
                        begin
                            next_state <= BIT4_STATE;
                            contador_ticks <= 4'b0000;
                        end
                    end
                BIT4_STATE:
                    begin
                        salida <= dato_transmicion[4];
                        if(contador_ticks == 4'b1111)
                        begin
                            next_state <= BIT5_STATE;
                            contador_ticks <= 4'b0000;
                        end
                    end
                BIT5_STATE:
                    begin
                        salida <= dato_transmicion[5];
                        if(contador_ticks == 4'b1111)
                        begin
                            next_state <= BIT6_STATE;
                            contador_ticks <= 4'b0000;
                        end
                    end
                BIT6_STATE:
                    begin
                        salida <= dato_transmicion[6];
                        if(contador_ticks == 4'b1111)
                        begin
                            next_state <= BIT7_STATE;
                            contador_ticks <= 4'b0000;
                        end
                    end
                BIT7_STATE:
                    begin
                        salida <= dato_transmicion[7];
                        if(contador_ticks == 4'b1111)
                        begin
                            next_state <= STOP_STATE;
                            contador_ticks <= 4'b0000;
                        end
                    end
                STOP_STATE:
                    begin
                        salida <= 1;
                        if(contador_ticks == 4'b1111)
                            begin
                                contadorTX <= contadorTX + 1;
                            if(contadorTX == 3) // Si ya se enviaron los 3 bytes regresa a IDDLE_STATE
                                begin
                                    next_state <= IDDLE_STATE;
                                    contadorTX <= 0;
                                    contador_ticks <= 4'b0000;
                                end else begin
                                    next_state <= WAITING_STATE;
                                    contador_ticks <= 4'b0000;
                                end
                            end         
                    end
                endcase
        end

        assign o_tx = salida;
        assign o_dato_enviado = terminado;
        assign o_next_memory_addr = actual_memory_adress;
        assign o_enviar_prev = enviar_prev;
       
        
    endmodule