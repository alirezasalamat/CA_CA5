`timescale 1 ns / 1 ns
`include "./constants.vh"

module memory_controller(hit, address, cache_out, 
                        ram_out1, ram_out2, ram_out3, ram_out4,
                        cache_write, mem_out);
    
    input hit;
    input [14:0] address;
    input [`WORD_LENGTH - 1:0] cache_out, ram_out1, ram_out2, ram_out3, ram_out4;
    output reg cache_write;
    output reg [`WORD_LENGTH - 1:0] mem_out;

    always @(hit or address) begin
        cache_write = 1'b0;
        mem_out = 32'bz;
        if (hit == 1'b1) begin
            mem_out = cache_out;
            $display("@%t: MEM_CTRL: mem_out = cache_out = %b", $time, mem_out);
        end
        else begin
            cache_write = 1'b1;
            case (address[1:0])
                2'b00: mem_out = ram_out1;
                2'b01: mem_out = ram_out2;
                2'b10: mem_out = ram_out3;
                2'b11: mem_out = ram_out4;
            endcase
            $display("@%t: MEM_CTRL: mem_out = ram_out = %b", $time, mem_out);
        end
    end
endmodule