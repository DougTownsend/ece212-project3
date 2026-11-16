module test_3_1_adc_dp_tb();
    // Test 3.1: clr sets dac to 0, and clr takes priority over inc.
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
        $dumpvars(0, test_3_1_adc_dp_tb);
        outfile = $fopen("test/results/test_3_1_adc_dp.txt", "w");
        $fdisplay(outfile, "time,inc,clr,load,dac,result,max");
        clk = 0;
        inc = 0; clr = 0; load = 0;
        // Writes a line to the file every time one of the signals changes
        $fmonitor(outfile, "%0t,%b,%b,%b,%0d,%0d,%b", $time, inc, clr, load, dac, result, max);

        inc = 1; #100;          // count up to 10
        inc = 0; clr = 1; #10;  // clear
        clr = 0; inc = 1; #50;  // count up to 5
        clr = 1; #20;           // clr and inc both high: dac is cleared
        clr = 0; #200;          // count up to 20
        inc = 0; #20;
        clr = 1; #10;
        clr = 0; #20;
        $finish;
    end
endmodule
