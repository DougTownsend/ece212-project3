module test_6_0_main_tb();
    // Test 6.0: the ADC runs on every tick and its result is shown on the LEDs.
    reg clk;
    reg [3:0] btn;
    reg [7:0] sw;
    integer vin;
    wire comp;
    wire [4:0] dac;
    wire strobe, data, shift_clk;
    integer outfile;

    main uut(.clk(clk), .btn(btn), .sw(sw), .comp(comp), .dac(dac),
             .strobe(strobe), .data(data), .shift_clk(shift_clk));

    // A model of the comparator. comp is high when the DAC value is greater than vin.
    assign comp = ($signed({1'b0, dac}) > vin);

    // The ADC changes dac every 2 clocks, so instead of writing every change,
    // dac_sample copies dac once every 50 clocks.
    reg [4:0] dac_sample = 0;
    integer cycle = 0;
    always @(negedge clk) begin
        cycle = cycle + 1;
        if (cycle % 50 == 0) dac_sample = dac;
    end

    // The clock has a period of 10, with rising edges at 5, 15, 25, ...
    // A sample is taken every 100 clocks (1000 time units).
    always #5 clk = ~clk;

    initial begin
        $dumpvars(0, test_6_0_main_tb);
        outfile = $fopen("test/results/test_6_0_main.txt", "w");
        $fdisplay(outfile, "time,btn,sw,vin,dac_sample,led");
        clk = 0;
        btn = 0; sw = 0; vin = 0;
        // Writes a line to the file every time one of the signals changes
        $fmonitor(outfile, "%0t,%b,%b,%0d,%0d,%b", $time, btn, sw, vin, dac_sample, uut.led);

        #2000;
        vin = 5;  #3000;
        vin = 12; #3000;
        sw = 8'b11111101; vin = 20; #3000;  // sw is not used
        sw = 8'b00000010; vin = 31; #3000;  // above the DAC's range
        sw = 8'b00000011; vin = 1;  #3000;
        $finish;
    end
endmodule
