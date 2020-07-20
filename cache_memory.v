timescale 1ns/1ns
`define SETS 1024
`define TAGS 3
`define WORD_LENGTH 32
`define VALID 1

module cache_memory();
    input clk;
    input [14:0] address;
    input [`WORD_LENGTH - 1:0] dataIn1;
    input [`WORD_LENGTH - 1:0] dataIn2;
    input [`WORD_LENGTH - 1:0] dataIn3;
    input [`WORD_LENGTH - 1:0] dataIn4;
    output reg hit;
    reg [131:0] cache [0:`SETS - 1];

    initial begin
        integer i;
        for (i = 0; i < `SETS; i = i + 1) begin
            cache[i][131:128] = 4'b0000;
        end
    end

    always @(posedge clk)begin
        if(cache[address[11:2]][131] == `VALID || cache[adderss[11:2]][130:128] == adderss[14:12])begin
            hit <= 1;
        end
        else begin
            hit <= 0;
            cache[address[11:2]] <= {1 , adderss[14:12] , dataIn1 , dataIn2 , dataIn3 , dataIn4};
        end
    end
endmodule
