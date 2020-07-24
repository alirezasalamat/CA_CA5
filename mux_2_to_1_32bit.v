`timescale 1 ns / 1 ns
`include "./constants.vh"

module mux_2_to_1_32bit(in0, in1, sel, out);
    input [`WORD_LENGTH - 1: 0] in0, in1;
    input sel;
    output reg [`WORD_LENGTH - 1: 0] out;

    always @(in0, in1, sel) begin
        case (sel)
            1'b0: out = in0;
            1'b1: out = in1;
        endcase
    end
endmodule