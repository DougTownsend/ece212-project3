module test_3_0_adc_dp_tb();
    // Test 3.0: inc counts dac up through 31, where max is high, and then dac wraps around to 0.
    reg clk;
    reg inc, clr, load;
    wire [4:0] dac;
    wire [3:0] result;
    wire max;
    integer outfile;

    adc_dp uut(.clk(clk), .inc(inc), .clr(clr), .load(load), .dac(dac), .result(result), .max(max));

    // The clock has a period of 10, with rising edges at 5, 15, 25, ...
    always #5 clk = ~clk;

    initial begin
        $dumpvars(0, test_3_0_adc_dp_tb);
        outfile = $fopen("test/results/test_3_0_adc_dp.txt", "w");
        $fdisplay(outfile, "time,inc,clr,load,dac,result,max");
        clk = 0;
        inc = 0; clr = 0; load = 0;
        // Writes a line to the file every time one of the signals changes
        $fmonitor(outfile, "%0t,%b,%b,%b,%0d,%0d,%b", $time, inc, clr, load, dac, result, max);

        #20;              // nothing changes while inc, clr, and load are low
        inc = 1; #340;    // count up through 31 and wrap around to 0
        inc = 0; #30;     // dac holds its value
        $finish;
    end
endmodule
