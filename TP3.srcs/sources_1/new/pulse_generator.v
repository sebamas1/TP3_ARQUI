module pulse_generator (
    input wire clk,    // Señal de reloj
    input wire reset,  // Señal de reset
    output reg pulse   // Señal de pulso
);

reg reset_d;  // Flip-flop para detectar flanco ascendente de reset

always @(posedge clk) begin
    if (reset) begin
        pulse <= 1'b1;  // Genera pulso de 1 ciclo
    end else if (reset_d) begin
        pulse <= 1'b0;  // Apaga pulso después de 1 ciclo
    end
    reset_d <= reset;   // Actualiza flip-flop
end

endmodule