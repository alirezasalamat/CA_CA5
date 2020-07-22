`timescale 1ns / 1ns
`include "./constants.vh"

module cache_memory(clk, cache_write, address,
                    dataIn1, dataIn2, dataIn3, dataIn4, hit, out);
    input clk, cache_write;
    input [14:0] address;
    
    input [`WORD_LENGTH - 1:0] dataIn1;
    input [`WORD_LENGTH - 1:0] dataIn2;
    input [`WORD_LENGTH - 1:0] dataIn3;
    input [`WORD_LENGTH - 1:0] dataIn4;
    
    output reg hit;
    output reg [31:0] out;
    
    reg [131:0] cache [0:`SETS - 1];
    
    integer i;
    initial begin
        for (i = 0; i < `SETS; i = i + 1) begin
            cache[i][131:128] = 4'b0000;
        end
    end

    always @(address) begin
        out = 32'bz;
        hit = 1'b0;

        if (cache[address[`IDX_START:`IDX_END]][131] == `VALID && 
            cache[address[`IDX_START:`IDX_END]][130:128] == address[`TAG_START:`TAG_END]) begin
            hit = 1'b1;
            case (address[1:0])
                2'b00: out = cache[address[`IDX_START:`IDX_END]][31:0];
                2'b01: out = cache[address[`IDX_START:`IDX_END]][63:32];
                2'b10: out = cache[address[`IDX_START:`IDX_END]][95:64];
                2'b11: out = cache[address[`IDX_START:`IDX_END]][127:96];
            endcase
            
            $display("@%t: CACHE::HIT: address: %d, out = %b\n", $time, address, out);
        end
        
        else begin
            hit = 1'b0;
            $display("@%t: CACHE::MISS: address: %d\n", $time, address);
        end
    end

    always @(posedge clk) begin
        if (cache_write == 1'b1)
            cache[address[`IDX_START:`IDX_END]] <= {1'b1, address[14:12], dataIn1, dataIn2, dataIn3, dataIn4};
    end

endmodule