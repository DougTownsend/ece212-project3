module test_5_0_adc_tb();
    // Test 5.0: convert several input values. result is the upper 4 bits of the first DAC value above vin.
    reg clk;
    reg start;
    integer vin;
    wire comp;
    wire [4:0] dac;
    wire [3:0] result;
    integer outfile;

    adc uut(.clk(clk), .start(start), .comp(comp), .dac(dac), .result(result));

    // A model of the comparator. comp is high when the DAC value is greater than vin.
    assign comp = ($signed({1'b0, dac}) > vin);

    // The clock has a period of 10, with rising edges at 5, 15, 25, ...
    always #5 clk = ~clk;

    initial begin
        $dumpvars(0, test_5_0_adc_tb);
        outfile = $fopen("test/results/test_5_0_adc.txt", "w");
        $fdisplay(outfile, "time,start,vin,comp,dac,result");
        clk = 0;
        start = 0;
        vin = 0;
        // Writes a line to the file every time one of the signals changes
        $fmonitor(outfile, "%0t,%b,%0d,%b,%0d,%0d", $time, start, vin, comp, dac, result);

        #20;
        vin = 6;  start = 1; #10; start = 0; #200;
        vin = 13; start = 1; #10; start = 0; #400;
        vin = 1;  start = 1; #10; start = 0; #100;
        vin = 22; start = 1; #10; start = 0; #600;
        $finish;
    end
endmodule
