module test_6_1_memory_tb();
    // Test 6.1: write several addresses, then read them back. rdata changes on the clock edge after raddr changes.
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
        $dumpvars(0, test_6_1_memory_tb);
        outfile = $fopen("test/results/test_6_1_memory.txt", "w");
        $fdisplay(outfile, "time,we,waddr,wdata,raddr,rdata");
        clk = 0;
        we = 0; waddr = 0; wdata = 0; raddr = 0;
        // The memory is not initialized, so the first value is written
        // before the monitor starts.
        we = 1; waddr = 0; wdata = 3; #20;
        // Writes a line to the file every time one of the signals changes
        $fmonitor(outfile, "%0t,%b,%0d,%0d,%0d,%0d", $time, we, waddr, wdata, raddr, rdata);

        waddr = 1;   wdata = 12; #10;
        waddr = 2;   wdata = 7;  #10;
        waddr = 128; wdata = 15; #10;
        waddr = 255; wdata = 1;  #10;
        we = 0;
        raddr = 0;   #10;
        raddr = 1;   #10;
        raddr = 2;   #10;
        raddr = 128; #10;
        raddr = 255; #10;
        $finish;
    end
endmodule
