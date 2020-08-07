`timescale 1ns / 1ns
`include "./constants.vh"

module cache_memory(clk, cache_read, cache_write, address,
                    dataIn1, dataIn2, dataIn3, dataIn4, hit, out);
    input clk, cache_read, cache_write;
    input [14:0] address;
    
    input [`WORD_LENGTH - 1:0] dataIn1;
    input [`WORD_LENGTH - 1:0] dataIn2;
    input [`WORD_LENGTH - 1:0] dataIn3;
    input [`WORD_LENGTH - 1:0] dataIn4;
    
    output reg hit;
    output reg [31:0] out;
    
    reg [131:0] cache [0:`SETS - 1];
    
    // alternative methods for initializing memory

    integer i, hit_count = 0;
    initial begin
        for (i = 0; i < `SETS; i = i + 1) begin
            cache[i][131:128] = 4'b0000;
        end
    end
    initial begin
        // $readmemb("./cache_memory.bin", cache);
        $display("%t: CACHE::INIT", $time);
    end

    always @(address) begin
        hit = 1'b0;

        if (cache[address[11:2]][131] == `VALID && 
            cache[address[11:2]][130:128] == address[14:12]) begin
            hit = 1'b1;
            hit_count = hit_count + 1;
            
            // $display("@%t: CACHE::HIT: address: %d, hit_count: %d", $time, address, hit_count);
            $display("@%t: CACHE::HIT: address: %d", $time, address);
        end
        
        else begin
            hit = 1'b0;
            $display("@%t: CACHE::MISS: address: %d", $time, address);
        end
    end

    always @(posedge clk) begin
        if (cache_write == 1'b1) begin
            cache[address[11:2]] <= {1'b1, address[14:12], dataIn1, dataIn2, dataIn3, dataIn4};
            $display("@%t: CACHE::WRITE: index: %d", $time, address[11:2]);
        end
    end

    always @(cache_read or address) begin
        out = 32'bz;
        if (cache_read == 1'b1) begin
            case (address[1:0])
                2'b11: out = cache[address[11:2]][31:0];
                2'b10: out = cache[address[11:2]][63:32];
                2'b01: out = cache[address[11:2]][95:64];
                2'b00: out = cache[address[11:2]][127:96];
            endcase
        end
    end

endmodule