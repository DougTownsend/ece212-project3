module test_1_0_led_bar_tb();
    // Test 1.0: inputs 0 through 7.
    reg [3:0] in;
    wire [7:0] led;
    integer outfile;

    led_bar uut(.in(in), .led(led));

    initial begin
        $dumpvars(0, test_1_0_led_bar_tb);
        outfile = $fopen("test/results/test_1_0_led_bar.txt", "w");
        $fdisplay(outfile, "time,in,led");
        // Writes a line to the file every time one of the signals changes
        $fmonitor(outfile, "%0t,%0d,%b", $time, in, led);

        in = 0; #10;
        in = 1; #10;
        in = 2; #10;
        in = 3; #10;
        in = 4; #10;
        in = 5; #10;
        in = 6; #10;
        in = 7; #10;
        $finish;
    end
endmodule
