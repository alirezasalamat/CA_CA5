`timescale 1ns / 1ns
`include "./constants.vh"

module memory(clk, address, hit, mem_out);
    input clk;
    input [14:0] address;
    output hit;
    output [`WORD_LENGTH - 1:0] mem_out;

    wire [`WORD_LENGTH - 1:0] ram_out1, ram_out2, ram_out3, ram_out4;
    wire cache_write;
    wire [`WORD_LENGTH - 1:0] cache_out;

    cache_memory cache(clk , cache_write , address , ram_out1 , ram_out2 , ram_out3, 
                       ram_out4 , hit , cache_out);
    main_memory RAM(address , hit , ram_out1 , ram_out2 , ram_out3 , ram_out4);
    // memory_controller controller(hit , address , cache_out , ram_out1 , ram_out2 , 
    //                              ram_out3 , ram_out4 , cache_write , mem_out);

    wire [`WORD_LENGTH - 1:0] mux_ram_out;
    mux_4_to_1_32bit mux_ram(ram_out1, ram_out2, ram_out3, ram_out4,
                             address[1:0], mux_ram_out);

    mux_2_to_1_32bit mux_out(mux_ram_out, cache_out, hit, mem_out);

    assign cache_write = ~hit;

endmodule



module mem_test();
    reg clk;
    reg [14:0] address;
    wire hit;
    wire [`WORD_LENGTH - 1:0] mem_out;

    memory mem(clk , address , hit , mem_out);

    initial begin
        clk = 1'b1;
        repeat(32000 + 1)
            #50 clk = ~clk;
    end

    integer i, hit_count;
    initial begin
        for (i = 1024; i < 9 * 1024; i = i + 1) begin
            address = i;
            $display("\n@%t: reading address %d...", $time, address);
            #100;
        end
        $stop;
    end

endmodule