module test_6_0_memory_tb();
    // Test 6.0: nothing is written while we is low.
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
        $dumpvars(0, test_6_0_memory_tb);
        outfile = $fopen("test/results/test_6_0_memory.txt", "w");
        $fdisplay(outfile, "time,we,waddr,wdata,raddr,rdata");
        clk = 0;
        we = 0; waddr = 0; wdata = 0; raddr = 0;
        // The memory is not initialized, so first write the addresses that
        // will be read.
        we = 1; waddr = 5; wdata = 9; raddr = 6; #10;   // write 9 to address 5
        waddr = 6; wdata = 2; raddr = 5; #10;           // write 2 to address 6
        we = 0; #10;
        // Writes a line to the file every time one of the signals changes
        $fmonitor(outfile, "%0t,%b,%0d,%0d,%0d,%0d", $time, we, waddr, wdata, raddr, rdata);

        waddr = 5; wdata = 3; #20;           // we is low, so nothing is written
        raddr = 5; #20;                      // still 9
        waddr = 6; wdata = 14; #20;          // we is low, so nothing is written
        raddr = 6; #20;                      // still 2
        we = 1; #10;                         // now 14 is written to address 6
        we = 0; #20;
        $finish;
    end
endmodule
