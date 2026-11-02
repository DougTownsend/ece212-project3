module test_6_2_memory_tb();
    // Test 6.2: reading and writing at the same time. Reading the address being written gives the old value, then the new value one clock later.
    reg clk;
    reg we;
    reg [7:0] waddr, raddr;
    reg [3:0] wdata;
    wire [3:0] rdata;
    integer outfile;

    memory uut(.clk(clk), .we(we), .waddr(waddr), .wdata(wdata), .raddr(raddr), .rdata(rdata));

    // The clock has a period of 10, with rising edges at 5, 15, 25, ...
    always #5 clk = ~clk;

    initial begin
        $dumpvars(0, test_6_2_memory_tb);
        outfile = $fopen("test/results/test_6_2_memory.txt", "w");
        $fdisplay(outfile, "time,we,waddr,wdata,raddr,rdata");
        clk = 0;
        we = 0; waddr = 0; wdata = 0; raddr = 0;
        // The memory is not initialized, so address 10 is written first.
        we = 1; waddr = 10; wdata = 3; raddr = 10; #20;
        // Writes a line to the file every time one of the signals changes
        $fmonitor(outfile, "%0t,%b,%0d,%0d,%0d,%0d", $time, we, waddr, wdata, raddr, rdata);

        wdata = 6; #10;                                  // rdata is still 3
        wdata = 11; #10;                                 // rdata = 6
        we = 0; #20;                                     // rdata = 11
        we = 1; waddr = 20; wdata = 4; raddr = 10; #10;  // write 20, read 10
        waddr = 21; wdata = 5; raddr = 20; #10;          // write 21, read 20
        waddr = 22; wdata = 13; raddr = 21; #10;
        we = 0; raddr = 22; #20;
        $finish;
    end
endmodule
