`timescale 1 ns / 1 ns
`include "./constants.vh"

module memory_controller(clk, clear, hit, address, ready, cache_read,
                         cache_write);
    
    input clk, clear, hit;
    input [14:0] address;
    output reg ready, cache_read, cache_write;

    reg [1:0] ps, ns;

    parameter DECODE = 2'b00;
    parameter C_WRITE = 2'b01;
    parameter C_READ = 2'b10;

    always @(ps or hit or address) begin
        case (ps)
            DECODE: begin
                if (hit == 1'b1)
                    ns = C_READ;
                else
                    ns = C_WRITE;
            end
            C_WRITE: ns = C_READ;
            C_READ: ns = DECODE;
        endcase
    end

    always @(ps) begin
        // $display("@%t: MEM_CTRL: ps is now: %d", $time, ps);
        {ready, cache_read, cache_write} = 3'b000;
        case (ps)
            DECODE: ready = 1'b1;
            C_WRITE: cache_write = 1'b1;
            C_READ: cache_read = 1'b1;
        endcase
    end

    always @(posedge clk or posedge clear) begin
        if (clear == 1'b1)
            ps <= 2'b00;
        else
            ps <= ns;
    end
endmodule