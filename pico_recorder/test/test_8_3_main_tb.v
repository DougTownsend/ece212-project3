module test_8_3_main_tb();
    // Test 8.3: record takes priority over play, and button presses shorter than the debounce time are ignored.
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
    // A sample is taken every 100 clocks (1000 time units). Buttons must be
    // held for 11 clocks to get through debounce.
    always #5 clk = ~clk;

    initial begin
        $dumpvars(0, test_8_3_main_tb);
        outfile = $fopen("test/results/test_8_3_main.txt", "w");
        $fdisplay(outfile, "time,btn,sw,vin,dac_sample,led,sevseg_in,sevseg_dp");
        clk = 0;
        btn = 0; sw = 0; vin = 0;
        // Writes a line to the file every time one of the signals changes
        $fmonitor(outfile, "%0t,%b,%b,%0d,%0d,%b,%0d,%b", $time, btn, sw, vin, dac_sample, uut.led, uut.sevseg_in, uut.sevseg_dp);

        vin = 10; #1500;
        btn[0] = 1; #4000;  // record about 4 samples of 10
        btn[0] = 0; vin = 28; #1000;
        btn[1] = 1; #3000;  // playing bank 0
        btn[0] = 1; #3000;  // record wins: the ADC runs and bank 0 is recorded again
        btn[0] = 0; #4000;  // still holding play, so it plays the new recording
        btn[1] = 0; #1000;
        btn[1] = 1; #50;    // these presses are too short to get through debounce
        btn[1] = 0; #500;
        btn[0] = 1; #80;
        btn[0] = 0; #2000;
        $finish;
    end
endmodule
