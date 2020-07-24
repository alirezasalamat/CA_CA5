`timescale 1 ns / 1 ns
`include "./constants.vh"

module mux_4_to_1_32bit(in0, in1, in2, in3, sel, out);
    input [`WORD_LENGTH - 1: 0] in0, in1, in2, in3;
    input [1:0] sel;
    output reg [`WORD_LENGTH - 1: 0] out;

    always @(in0, in1, in2, in3, sel) begin
        case (sel)
            2'b00: out = in0;
            2'b01: out = in1;
            2'b10: out = in2;
            2'b11: out = in3;
        endcase
    end
endmodule