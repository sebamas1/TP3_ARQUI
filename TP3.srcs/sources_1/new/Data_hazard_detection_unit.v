`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.01.2024 18:17:56
// Design Name: 
// Module Name: Data_hazard_detection_unit
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


module Data_hazard_detection_unit #(
    parameter   OP_SIZE = 5,
    parameter   REGISTER_SIZE = 5
)
(
    input  [OP_SIZE - 1 : 0]              i_op,
    input  [REGISTER_SIZE - 1 : 0 ]       i_actual_rt_dir,
    input  [REGISTER_SIZE - 1 : 0 ]       i_next_rs_dir,
    input  [REGISTER_SIZE - 1 : 0 ]       i_next_rt_dir,
    
    output o_stall
    );
    
    assign o_stall =  ((i_op[2] == 1'b1 && i_op[4] == 1'b1) &&
                      (i_actual_rt_dir == i_next_rs_dir || i_actual_rt_dir == i_next_rt_dir) &&
                      (i_op !== 6'bxxxxx && i_actual_rt_dir !== 6'bxxxxx && i_next_rs_dir !== 6'bxxxxx && i_next_rt_dir !== 6'bxxxxx)) ? 1 : 0;


endmodule
