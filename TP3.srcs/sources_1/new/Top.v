`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.01.2024 22:25:03
// Design Name: 
// Module Name: Top
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


module Top(
            input rx,//UART RX
            input i_reset,
            input i_clk,
            output [7 : 0] salida,
            output [7 : 0] salida_operadores,
            output tx,
            output [6:0] display1,
            output [3:0] an
    );
    initial begin
        step = 1'b0;
    end
    
    Instruction_fetch etapa_if(
        .i_clk(step == 1 ? i_reset : i_clk),
        .i_reset(i_reset),
        .i_branch(ex.o_branch), 
        .i_branch_addr(ex.o_branch_dir), 
        .i_stall(dtu.o_stall),
        .i_instruccion_carga(instruccion_para_guardar),
        .i_instruccion_carga_addr(etapa_if.o_end_pipeline ? transmisor.o_next_memory_addr : instruccion_addr),
        .i_wea(wea),
        .i_start_pipeline(reception_end)
    );

    IF_ID latch_ifid(
        step == 1 ? i_reset : i_clk,
        i_reset,
        etapa_if.o_pc_value,
        etapa_if.o_instruccion,
        ex.o_branch, //esta es la se�al de flush
        dtu.o_stall
    );
    
    Instruction_decode etapa_id(
        .i_clk(step == 1 ? i_reset : i_clk),
        .i_reset(i_reset),
        .i_instruccion(etapa_if.o_end_pipeline ? transmisor.o_next_memory_addr : latch_ifid.o_instruccion),
        .i_pc(latch_ifid.o_pc_value),
        
        .i_reg_write_mem_wb(etapa_if.o_end_pipeline ? 0 : wb.o_reg_write_enable),
        .i_dato_de_escritura_en_reg(wb.o_res),
        .i_direc_de_escritura_en_reg(etapa_if.o_end_pipeline ? transmisor.o_next_memory_addr : wb.o_wb_reg_write)
    );
    
    latch_idex latch_idex(
        step == 1 ? i_reset  : i_clk,
        i_reset,
        etapa_id.o_pc,
        etapa_id.o_op,
        etapa_id.o_inmediato,
        etapa_id.o_shamt,
        etapa_id.o_funct,
        etapa_id.o_direccion,
        etapa_id.o_rs,
        etapa_id.o_rt,
        etapa_id.o_rs_dir,
        etapa_id.o_rt_dir,
        etapa_id.o_rd_dir,
        ex.o_branch,
        dtu.o_stall
    );
    
    etapa_ex ex(
        step == 1 ? i_reset  : i_clk,
        i_reset,
        latch_idex.o_pc,
        latch_idex.o_op,
        latch_idex.o_inmediato,
        latch_idex.o_shamt,
        latch_idex.o_funct,
        latch_idex.o_direccion,
        latch_idex.o_rs,
        latch_idex.o_rt,
        latch_idex.o_rt_dir,
        latch_idex.o_rd_dir,
        
        fu.o_mem_res_rs_enable,
        fu.o_wb_res_rs_enable,
        fu.o_mem_res_rt_enable,
        fu.o_wb_res_rt_enable,
        fu.o_mem_res,
        fu.o_wb_res
     
    );
    latch_exmem exmem(
        step == 1 ? i_reset : i_clk,// OJO, si no lee las instrucciones, ES POSIBLE QUE EL REA este deshabilitado segun la instruccion
        i_reset,
        ex.o_pc,
        ex.o_res,
        ex.o_alu_ctrl,
        ex.o_rt,
        ex.o_wb_reg_write
    );
    
    Etapa_MEM mem(
        step == 1 ? i_reset : i_clk,
        i_reset,
        
        exmem.o_pc,
        exmem.o_res,
        exmem.o_rt,
        exmem.o_wb_reg_write,
        exmem.o_alu_ctrl,
        transmisor.o_next_memory_addr,
        etapa_if.o_end_pipeline
    
    );
    latch_memwb memwb(
        step == 1 ? i_reset : i_clk,
        i_reset,
        
        mem.o_pc,
        mem.o_res,
        mem.o_wb_reg_write,
        mem.o_reg_write_enable
    
    );
    
   etapa_wb wb(
        step == 1 ? i_reset : i_clk,
        i_reset,
        
        memwb.o_pc,
        memwb.o_res,
        memwb.o_wb_reg_write,
        memwb.o_reg_write_enable
        
    );
    
    Forwarding_unit fu(
        latch_idex.o_rs_dir,
        latch_idex.o_rt_dir,
        exmem.o_wb_reg_write,
        memwb.o_wb_reg_write,
        exmem.o_res,
        memwb.o_res,
        exmem.o_alu_ctrl[3],
        memwb.o_reg_write_enable
        
    );
    
    Data_hazard_detection_unit dtu(
        ex.o_alu_ctrl,
        ex.o_wb_reg_write,
        etapa_id.o_rs_dir,
        etapa_id.o_rt_dir //por el lugar desde que el que tomo los datos, esto va a ser detectado en un rising edge
    );


    Baud_gen baud_gen(
        .i_clk(i_clk),
        .o_tick(o_tick)
    );

    RX receptor(
        .i_clk(i_clk),   
        .i_tick(o_tick),
        .i_rx(rx),
        .i_reset(i_reset),
        .o_dato_recibido(),
        .o_recibido(i_recibido)              
    );

    TX transmisor(
        .i_clk(i_clk),
        .i_tick(o_tick),
        .i_reset(i_reset),
        .i_gpregisters(etapa_id.o_rs),
        .i_data_memory(mem.o_data_memory),
        .i_pc(etapa_if.o_pc_value),
        .o_dato_enviado(),
        .o_tx(tx)
    );

    Basys3_7SegmentMultiplexing basys3_7SegmentMultiplexing (      
        .data(salida_operadores),
        .seg(display1),
        .an(an),
        .clk(o_tick),
        .rst(resultado)
    );

    pulse_generator pulse_generator (
        .clk(i_clk),
        .reset(i_reset),
        .data_ready(receptor.o_dato_recibido)
    );

        wire            i_recibido;
        wire [7 : 0]    resultado;

        reg [7 : 0]     salida_op = 8'b00000000;
        reg [31 : 0]    instruccion_addr = 32'b00000000000000000000000000000000;
        reg             wea = 1'b0;
        reg             reception_end = 1'b0;
        reg [31 : 0]    instruccion_para_guardar = 0;
        reg [3 : 0]     present_state = IDDLE_STATE;
        reg [3 : 0]     next_state = IDDLE_STATE;
        reg             step = 1'b0;


        localparam PRIMER_HEXA = 3'b000;
        localparam SEGUNDO_HEXA = 3'b001;
        localparam TERCER_HEXA = 3'b010;
        localparam CUARTO_HEXA = 3'b011;
        localparam IDDLE_STATE = 3'b101;

        assign salida = resultado;
        assign salida_operadores = i_reset;

        always @(posedge i_clk)
        begin
                if(i_reset == 1)
                begin
                present_state <= IDDLE_STATE;
                end
                else begin
                present_state <= next_state;
                end
        end

        always @(posedge i_recibido)
                begin
                        case(present_state)
                                IDDLE_STATE:
                                begin
                                        if (receptor.o_dato_recibido == 8'b11111111)
                                        begin
                                                next_state = PRIMER_HEXA;
                                        end
                                end
                                PRIMER_HEXA:
                                begin
                                        wea = 0;
                                        next_state = SEGUNDO_HEXA;
                                        instruccion_para_guardar [31 : 24] = receptor.o_dato_recibido;

                                end
                                
                                SEGUNDO_HEXA:
                                begin
                                        next_state = TERCER_HEXA;
                                        instruccion_para_guardar [23 : 16] = receptor.o_dato_recibido;
                                end

                                TERCER_HEXA:
                                begin
                                        next_state = CUARTO_HEXA;
                                        instruccion_para_guardar [15 : 8] = receptor.o_dato_recibido;
                                end
                                
                                CUARTO_HEXA:
                                begin
                                        if(receptor.o_dato_recibido == 8'b11111111)
                                        begin //step
                                                wea = 0;
                                                instruccion_para_guardar [7 : 0] = 8'b11111111;
                                                next_state = IDDLE_STATE;
                                                reception_end = 1'b1;
                                                step = 1'b1;
                                        end else if (receptor.o_dato_recibido == 8'b11111110) begin
                                            //ejecucion continua
                                                wea = 0;
                                                instruccion_para_guardar [7 : 0] = 8'b11111111;
                                                next_state = IDDLE_STATE;
                                                reception_end = 1'b1;
                                                step = 1'b0;
                                        end else
                                            begin
                                                instruccion_para_guardar [7 : 0] = receptor.o_dato_recibido;
                                                next_state = PRIMER_HEXA;
                                                instruccion_addr = instruccion_addr + 1;
                                                wea = 1;
                                        end       
                                end
                        endcase   
                end 


        endmodule
