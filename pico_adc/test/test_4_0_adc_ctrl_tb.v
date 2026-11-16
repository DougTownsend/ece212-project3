module test_4_0_adc_ctrl_tb();
    // Test 4.0: single conversions. The FSM steps through SETTLE and INC until comp is high, then goes through DONE back to IDLE.
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
        $dumpvars(0, test_4_0_adc_ctrl_tb);
        outfile = $fopen("test/results/test_4_0_adc_ctrl.txt", "w");
        $fdisplay(outfile, "time,start,comp,max,inc,clr,load");
        clk = 0;
        start = 0;
        vin = 3;
        // Writes a line to the file every time one of the signals changes
        $fmonitor(outfile, "%0t,%b,%b,%b,%b,%b,%b", $time, start, comp, max, inc, clr, load);

        #30;                // stays in IDLE until start is high
        start = 1; #10;
        start = 0; #150;    // convert vin = 3
        vin = 0;
        start = 1; #10;
        start = 0; #60;     // convert vin = 0
        vin = 9;
        start = 1; #10;
        start = 0; #250;    // convert vin = 9
        $finish;
    end
endmodule
