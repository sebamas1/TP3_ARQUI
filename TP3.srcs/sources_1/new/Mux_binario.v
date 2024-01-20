`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.01.2024 14:08:36
// Design Name: 
// Module Name: Mux_binario
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


module mux_load (
  input wire [31:0] data_input,
  input wire [1:0] select,
  output reg [31:0] mux_output
);

  always @*
  begin
    case (select)
      2'b10: mux_output = {24'b000000000000000000000000, data_input[7 : 0]};
      2'b01: mux_output = {16'b0000000000000000, data_input[15 : 0]};
      2'b00: mux_output = data_input;

      default: mux_output = 4'b0000; // Valor por defecto en caso de selección no válida
    endcase
  end

endmodule
