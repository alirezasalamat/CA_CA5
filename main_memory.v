`timescale 1 ns / 1 ns
`include "./constants.vh"

// main_memory returns data stored in the received address.
// Note: we don't need to write anything in this module;
// so we wouldn't need a clock either.

module main_memory(address, hit, dataOut1, dataOut2, dataOut3, dataOut4);
    input [14:0] address;
    input hit;

    output reg [31:0] dataOut1, dataOut2, dataOut3, dataOut4;
    
    reg [31:0] RAM [0:2 ** 15 - 1];

    integer i;
    initial begin
        for (i = 0; i < `SETS; i = i + 1) begin
            RAM[i] = i;
        end
    end

    initial begin
        $readmemb("./main_memory.bin", RAM);
        $display("%t: MEMORY::INIT\n", $time);
    end

    always @(address or hit) begin
        {dataOut1, dataOut2, dataOut3, dataOut4} = 128'bz;

        if (hit == 1'b0) begin
            dataOut1 = RAM[{address[14:2] , 2'b00}];
            dataOut2 = RAM[{address[14:2] , 2'b01}];
            dataOut3 = RAM[{address[14:2] , 2'b10}];
            dataOut4 = RAM[{address[14:2] , 2'b11}];

            $display("@%t: MAIN_MEM::READ: address: %d", $time, address);
        end
    end

endmodule

module mem_test();
    reg [14:0] address;
    reg hit;
    wire [31:0] dataOut1, dataOut2, dataOut3, dataOut4;
    main_memory ram(address, hit, dataOut1, dataOut2, dataOut3, dataOut4);
    
    integer i;
    initial begin
        hit = 1'b0;
        for (i = 1024; i < 1124; i = i + 1) begin
            #100 address = i;   
        end

        hit = 1'b1;
        for (i = 1124; i < 1134; i = i + 1) begin
            #100 address = i;
        end

        #100;
    end
endmodule