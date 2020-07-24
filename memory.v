`timescale 1ns / 1ns
`include "./constants.vh"

module memory(clk, address, hit, mem_out);
    input clk;
    input [14:0] address;
    output reg hit;
    output reg [`WORD_LENGTH - 1:0] mem_out;

    reg [`WORD_LENGTH - 1:0] ram_out1 , ram_out2, ram_out3, ram_out4;
    reg hit , cache_write;
    reg [`WORD_LENGTH - 1:0] cache_out

    cache_memory cache(clk , cache_write , address , ram_out1 , ram_out2 , ram_out3, ram_out4 , hit , cache_out);
    main_memory RAM(address , hit , ram_out1 , ram_out2 , ram_out3 , ram_out4);
    memory_controller controller(hit , address , cache_out , ram_out1 , ram_out2 , ram_out3 , ram_out4 , cache_write , mem_out);

endmodule



module mem_test();
    reg clk;
    reg [14:0] address;
    wire hit;
    wire [`WORD_LENGTH - 1:0] mem_out;

    memory mem(clk , address , hit , mem_out);

    integer i;
    initial begin
        
        //.....
    end

endmodule