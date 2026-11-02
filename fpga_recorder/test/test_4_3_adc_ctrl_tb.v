module test_4_3_adc_ctrl_tb();
    // Test 4.3: start only matters in IDLE. Holding start high runs conversions back to back.
    reg clk;
    reg start;
    integer vin;
    wire comp, max;
    wire inc, clr, load;
    integer outfile;

    adc_ctrl uut(.clk(clk), .start(start), .comp(comp), .max(max), .inc(inc), .clr(clr), .load(load));

    // A model of the datapath and comparator, so that comp and max respond
    // to inc and clr. comp is high when the DAC value is greater than vin.
    reg [4:0] dac = 0;
    always @(posedge clk) begin
        if (clr) dac <= 0;
        else if (inc) dac <= dac + 1;
    end
    assign max = (dac == 31);
    assign comp = ($signed({1'b0, dac}) > vin);

    // The clock has a period of 10, with rising edges at 5, 15, 25, ...
    always #5 clk = ~clk;

    initial begin
        $dumpvars(0, test_4_3_adc_ctrl_tb);
        outfile = $fopen("test/results/test_4_3_adc_ctrl.txt", "w");
        $fdisplay(outfile, "time,start,comp,max,inc,clr,load");
        clk = 0;
        start = 0;
        vin = 4;
        // Writes a line to the file every time one of the signals changes
        $fmonitor(outfile, "%0t,%b,%b,%b,%b,%b,%b", $time, start, comp, max, inc, clr, load);

        start = 1; #10;
        start = 0; #30;
        start = 1; #30;     // start is ignored in the middle of a conversion
        start = 0; #150;
        vin = 2;
        start = 1; #300;    // back to back conversions
        start = 0; #50;
        $finish;
    end
endmodule
