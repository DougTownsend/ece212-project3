module test_7_0_recorder_tb();
    // Test 7.0: record 6 samples into bank 0, then play them back in a loop.
    reg clk;
    reg rec, play;
    reg [1:0] bank;
    reg [3:0] sample;
    wire tick;
    wire recording, playing;
    wire [3:0] out;
    integer outfile;

    recorder uut(.clk(clk), .tick(tick), .rec(rec), .play(play), .bank(bank), .sample(sample),
                 .recording(recording), .playing(playing), .out(out));

    // To keep the test short, tick is high for one clock out of every 4
    // instead of every 100. The sample changes after every tick, like the
    // ADC result would.
    reg [1:0] count = 0;
    always @(posedge clk) count <= count + 1;
    assign tick = (count == 3);
    always @(posedge clk) if (tick) sample <= sample + 1;

    // out only matters while playing, so it is written as 0 otherwise.
    // The memory is not initialized, so out could be unknown when not playing.
    reg [3:0] out_shown;
    always @(*) begin
        if (playing) out_shown = out;
        else out_shown = 0;
    end

    // The clock has a period of 10, with rising edges at 5, 15, 25, ...
    always #5 clk = ~clk;

    initial begin
        $dumpvars(0, test_7_0_recorder_tb);
        outfile = $fopen("test/results/test_7_0_recorder.txt", "w");
        $fdisplay(outfile, "time,rec,play,bank,sample,recording,playing,out");
        clk = 0;
        rec = 0; play = 0; bank = 0; sample = 0;
        // Writes a line to the file every time one of the signals changes
        $fmonitor(outfile, "%0t,%b,%b,%0d,%0d,%b,%b,%0d", $time, rec, play, bank, sample, recording, playing, out_shown);

        #80;
        rec = 1; #240;      // record 6 samples
        rec = 0; #80;
        play = 1; #700;     // loop over the 6 samples a few times
        play = 0; #80;
        play = 1; #200;     // playback starts over from address 0
        play = 0; #40;
        $finish;
    end
endmodule
