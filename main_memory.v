timescale 1ns/1ns
`define SETS 1024
`define TAGS 3
`define WORD_LENGTH 32
`define VALID 1

module main_memory();
    input clk;
    input [14:0] address;
    input hit;

    output [31:0] dataOut1;
    output [31:0] dataOut2;
    output [31:0] dataOut3;
    output [31:0] dataOut4;
    
    reg [31:0] RAM [0:2 ** 15 - 1];

    initial begin
        integer i;
        for (i = 0; i < `SETS; i = i + 1) begin
            RAM[i] = i;
        end
    end

    always @(posedge clk)begin
        dataOut1 <= 32'bz
        dataOut2 <= 32'bz
        dataOut3 <= 32'bz
        dataOut4 <= 32'bz

        if(hit == 0)begin 
            dataOut1 <= RAM[{address[14:2] , 2'b00}];
            dataOut2 <= RAM[{address[14:2] , 2'b01}];
            dataOut3 <= RAM[{address[14:2] , 2'b10}];
            dataOut4 <= RAM[{address[14:2] , 2'b11}];
        end
    end

endmodule