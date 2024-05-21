`timescale 1ns / 1ps

module Basys3_7SegmentMultiplexing(
  input wire [7:0] data,
  output wire [6:0] seg,
  output wire [3:0] an,
  input wire clk,
  input wire [7 : 0] rst
  );


  reg [3:0] display_select;
  reg [6:0] seg_out;
  reg [6:0] seg_reg;
  reg [3:0] an_reg;

  always @(posedge clk) begin
    //shiftea el display select para que se active el siguiente display
    case(display_select)
      4'b0001: display_select <= 4'b0010;
      4'b0010: display_select <= 4'b0100;
      4'b0100: display_select <= 4'b1000;
      4'b1000: display_select <= 4'b0001;
      default: display_select <= 4'b0001;
    endcase
    case (display_select)
      4'b0001: seg_out = rst[3 : 0];
      4'b0010: seg_out = rst[7 : 4];
      4'b0100: seg_out = data[3 : 0];
      4'b1000: seg_out = data[7 : 4];
      default: seg_out = 7'b111_1111; // Display desactivado
    endcase
    case (seg_out)
      4'b0000: seg_reg = 7'b100_0000;  // 0
      4'b0001: seg_reg = 7'b111_1001;  // 1
      4'b0010: seg_reg = 7'b010_0100;  // 2
      4'b0011: seg_reg = 7'b011_0000;  // 3
      4'b0100: seg_reg = 7'b001_1001;  // 4
      4'b0101: seg_reg = 7'b001_0010;  // 5
      4'b0110: seg_reg = 7'b000_0010;  // 6
      4'b0111: seg_reg = 7'b111_1000;  // 7
      4'b1000: seg_reg = 7'b000_0000;  // 8
      4'b1001: seg_reg = 7'b001_0000;  // 9
      4'b1010: seg_reg = 7'b000_1000; // Display A
      4'b1011: seg_reg = 7'b000_0011; // Display B
      4'b1100: seg_reg = 7'b100_0110; // Display C
      4'b1101: seg_reg = 7'b010_0001; // Display D
      4'b1110: seg_reg = 7'b000_0110; // Display E
      4'b1111: seg_reg = 7'b000_1110; // Display F
      default: seg_reg = 7'b111_1111;  // Display desactivado
    endcase

    case (display_select)
      4'b0001: an_reg = 4'b1110;  // Primer display
      4'b0010: an_reg = 4'b1101;  // Segundo display
      4'b0100: an_reg = 4'b1011;  // Tercer display
      4'b1000: an_reg = 4'b0111;  // Cuarto display
      default: an_reg = 4'b1111; // Todos los displays desactivados
    endcase
    #50000;
  end

  // always @* begin
    
  // end

  // always @* begin
    
  // end

  // always @* begin
    
  // end

  assign seg = seg_reg;
  assign an = an_reg;


endmodule
