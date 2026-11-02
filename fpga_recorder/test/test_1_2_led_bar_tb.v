module test_1_2_led_bar_tb();
    // Test 1.2: inputs in a mixed order, including jumps up and down the bar.
    reg [3:0] in;
    wire [7:0] led;
    integer outfile;

    led_bar uut(.in(in), .led(led));

    initial begin
        $dumpvars(0, test_1_2_led_bar_tb);
        outfile = $fopen("test/results/test_1_2_led_bar.txt", "w");
        $fdisplay(outfile, "time,in,led");
        // Writes a line to the file every time one of the signals changes
        $fmonitor(outfile, "%0t,%0d,%b", $time, in, led);

        in = 15; #10;
        in = 0; #10;
        in = 9; #10;
        in = 2; #10;
        in = 14; #10;
        in = 7; #10;
        in = 1; #10;
        in = 12; #10;
        in = 3; #10;
        in = 10; #10;
        in = 5; #10;
        in = 8; #10;
        in = 13; #10;
        in = 4; #10;
        in = 11; #10;
        in = 6; #10;
        $finish;
    end
endmodule
