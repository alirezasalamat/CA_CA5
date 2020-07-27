`timescale 1ns / 1ns
`include "./constants.vh"

module memory(clk, clear, address, ready, mem_out);
    input clk, clear;
    input [14:0] address;
    output ready;
    output [`WORD_LENGTH - 1:0] mem_out;

    wire [`WORD_LENGTH - 1:0] ram_out1, ram_out2, ram_out3, ram_out4;
    wire hit, cache_read, cache_write;
    
    cache_memory cache(clk, cache_read, cache_write, address,
                        ram_out1, ram_out2, ram_out3, ram_out4, hit, mem_out);
    main_memory ram(address, hit, ram_out1, ram_out2, ram_out3, ram_out4);
    memory_controller controller(clk, clear, hit, address, ready, cache_read,
                                cache_write);

endmodule



module mem_test();
    reg clk, clear;
    reg [14:0] address;
    wire ready;
    wire [`WORD_LENGTH - 1:0] mem_out;

    memory mem(clk, clear, address, ready, mem_out);

    initial begin
        clk = 1'b1;
        repeat(2 ** 16 + 1)
            #5 clk = ~clk;
    end

    initial begin
        clear = 1'b1;
        #5 clear = 1'b0;
    end
    
    integer i = 1024;
    always @(ready) begin
        if (i == 1024 * 9 + 1)
            $stop;
        else if (ready == 1'b1) begin
            address = i;
            i = i + 1;
        end
    end
endmodule