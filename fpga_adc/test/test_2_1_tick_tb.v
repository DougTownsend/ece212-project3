module test_2_1_tick_tb();
    // Test 2.1: a longer run. There must be exactly 100 clock cycles between pulses.
    reg clk;
    wire tick;
    integer outfile;

    tick uut(.clk(clk), .tick(tick));

    // The clock has a period of 10, with rising edges at 5, 15, 25, ...
    always #5 clk = ~clk;

    initial begin
        $dumpvars(0, test_2_1_tick_tb);
        outfile = $fopen("test/results/test_2_1_tick.txt", "w");
        $fdisplay(outfile, "time,tick");
        clk = 0;
        // Writes a line to the file every time one of the signals changes
        $fmonitor(outfile, "%0t,%b", $time, tick);

        #10500;
        $finish;
    end
endmodule
