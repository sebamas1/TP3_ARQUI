module pulse_generator (
    input wire clk,
    input wire button,
    output reg pulse1,
    output reg pulse2,
    output reg flag_pulse1,
    output reg flag_pulse2
);
    parameter DEBOUNCE_DELAY = 4'b1111;
    parameter PULSE2_DURATION = 10; // Duración del pulso2 en ciclos de reloj

    reg [3:0] debounce_counter;
    reg button_debounced;
    reg button_released;
    reg [3:0] state;
    reg [3:0] counter;
    reg [3:0] pulse2_counter; // Contador para duración del pulso2

    localparam IDLE = 4'd0,
               PULSE1 = 4'd1,
               WAIT1 = 4'd2,
               WAIT2 = 4'd3,
               PULSE2 = 4'd4,
               WAIT_RELEASE = 4'd5;

    // Combined always block
    always @(posedge clk) begin
        // Debounce logic
        if (button == 1) begin
            if (debounce_counter < DEBOUNCE_DELAY) begin
                debounce_counter <= debounce_counter + 1;
            end else begin
                button_debounced <= 1;
            end
        end else begin
            debounce_counter <= 0;
            button_debounced <= 0;
            button_released <= 1;
        end

        // State machine to generate pulses
        case (state)
            IDLE: begin
                pulse1 <= 1'b0;
                pulse2 <= 1'b0;
                if (button_debounced && button_released) begin
                    state <= PULSE1;
                    button_released <= 0;
                end
            end
            PULSE1: begin
                pulse1 <= 1'b1;  // Example value for pulse1
                flag_pulse1 <= 1;
                state <= WAIT1;
                counter <= 0;
            end
            WAIT1: begin
                pulse1 <= 1'b0;
                if (counter < 4'd1) begin
                    counter <= counter + 1;
                end else begin
                    state <= WAIT2;
                    counter <= 0;
                end
            end
            WAIT2: begin
                if (counter < 4'd1) begin
                    counter <= counter + 1;
                end else begin
                    state <= PULSE2;
                    counter <= 0;
                    pulse2_counter <= 0;
                end
            end
            PULSE2: begin
                pulse2 <= 1'b1;  // Example value for pulse2
                flag_pulse2 <= 1;
                if (pulse2_counter < PULSE2_DURATION - 1) begin
                    pulse2_counter <= pulse2_counter + 1;
                end else begin
                    pulse2 <= 1'b0;
                    state <= WAIT_RELEASE;
                end
            end
            WAIT_RELEASE: begin
                if (!button_debounced) begin
                    state <= IDLE;
                end
            end
            default: state <= IDLE;
        endcase
    end


endmodule
