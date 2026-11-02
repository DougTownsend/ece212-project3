module test_3_2_adc_dp_tb();
    // Test 3.2: load saves dac[4:1] in result. With clr and load both high, result gets dac's value before it is cleared.
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
        $dumpvars(0, test_3_2_adc_dp_tb);
        outfile = $fopen("test/results/test_3_2_adc_dp.txt", "w");
        $fdisplay(outfile, "time,inc,clr,load,dac,result,max");
        clk = 0;
        inc = 0; clr = 0; load = 0;
        // Writes a line to the file every time one of the signals changes
        $fmonitor(outfile, "%0t,%b,%b,%b,%0d,%0d,%b", $time, inc, clr, load, dac, result, max);

        inc = 1; #70;           // dac = 7
        inc = 0; load = 1; #10; // result = 3
        load = 0; inc = 1; #120;// dac = 19, result holds
        inc = 0; load = 1; #10; // result = 9
        load = 0; inc = 1; #110;// dac = 30
        inc = 0; load = 1; clr = 1; #10;  // result = 15, dac = 0
        load = 0; clr = 0; inc = 1; #30;  // dac = 3, result holds
        inc = 0; load = 1; clr = 1; #10;  // result = 1, dac = 0
        load = 0; clr = 0; #20;
        $finish;
    end
endmodule
