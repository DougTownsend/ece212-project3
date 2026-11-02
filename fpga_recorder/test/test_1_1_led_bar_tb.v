module test_1_1_led_bar_tb();
    // Test 1.1: inputs 8 through 15.
    reg [3:0] in;
    wire [7:0] led;
    integer outfile;

    led_bar uut(.in(in), .led(led));

    initial begin
        $dumpvars(0, test_1_1_led_bar_tb);
        outfile = $fopen("test/results/test_1_1_led_bar.txt", "w");
        $fdisplay(outfile, "time,in,led");
        // Writes a line to the file every time one of the signals changes
        $fmonitor(outfile, "%0t,%0d,%b", $time, in, led);

        in = 8; #10;
        in = 9; #10;
        in = 10; #10;
        in = 11; #10;
        in = 12; #10;
        in = 13; #10;
        in = 14; #10;
        in = 15; #10;
        $finish;
    end
endmodule
