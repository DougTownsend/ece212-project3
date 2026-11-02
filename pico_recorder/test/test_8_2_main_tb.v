module test_8_2_main_tb();
    // Test 8.2: record into two banks, then play each. Changing banks during playback switches right away.
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
        $dumpvars(0, test_8_2_main_tb);
        outfile = $fopen("test/results/test_8_2_main.txt", "w");
        $fdisplay(outfile, "time,btn,sw,vin,dac_sample,led,sevseg_in,sevseg_dp");
        clk = 0;
        btn = 0; sw = 0; vin = 0;
        // Writes a line to the file every time one of the signals changes
        $fmonitor(outfile, "%0t,%b,%b,%0d,%0d,%b,%0d,%b", $time, btn, sw, vin, dac_sample, uut.led, uut.sevseg_in, uut.sevseg_dp);

        sw = 1; vin = 24; #1500;
        btn[0] = 1; #2000;  // bank 1: about 2 samples of 24 then 3 of 6
        vin = 6; #3000;
        btn[0] = 0; #500;
        sw = 2; vin = 14; #1000;
        btn[0] = 1; #3000;  // bank 2: about 3 samples of 14 then 3 of 30
        vin = 30; #3000;
        btn[0] = 0; vin = 0; #1000;
        sw = 1;
        btn[1] = 1; #8000;  // play bank 1
        sw = 2; #8000;      // play bank 2
        btn[1] = 0; #1000;
        sw = 1;
        btn[1] = 1; #3000;  // play bank 1 again from the start
        btn[1] = 0; #2000;
        $finish;
    end
endmodule
