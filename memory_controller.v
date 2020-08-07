`timescale 1 ns / 1 ns
`include "./constants.vh"

module memory_controller(clk, clear, hit, address, ready, cache_read,
                         cache_write);
    
    input clk, clear, hit;
    input [14:0] address;
    output reg ready, cache_read, cache_write;

    reg [1:0] ps, ns;

    parameter DECODE = 2'b00;
    parameter CACHE_WRITE = 2'b01;
    parameter CACHE_READ = 2'b10;

    integer miss = 0, total = 0;
    always @(ps or hit or address) begin
        case (ps)
            DECODE: begin
                if (hit == 1'b1)
                    ns = CACHE_READ;
                else
                    ns = CACHE_WRITE;
            end
            CACHE_WRITE: ns = CACHE_READ;
            CACHE_READ: ns = DECODE;
        endcase
    end

    always @(ps) begin
        {ready, cache_read, cache_write} = 3'b000;
        case (ps)
            DECODE: ready = 1'b1;
            CACHE_WRITE: begin 
                cache_write = 1'b1;
                miss = miss + 1; 
            end
            CACHE_READ: begin
                cache_read = 1'b1;
                total = total + 1;
                $display("@%t: CTRL: hit_count: %d", $time, total - miss);
            end
        endcase
    end

    always @(posedge clk or posedge clear) begin
        if (clear == 1'b1)
            ps <= 2'b00;
        else
            ps <= ns;
    end
endmodule