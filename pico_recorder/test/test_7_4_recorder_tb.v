module test_7_4_recorder_tb();
    // Test 7.4: changing the bank takes effect right away during playback and recording.
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
        $dumpvars(0, test_7_4_recorder_tb);
        outfile = $fopen("test/results/test_7_4_recorder.txt", "w");
        $fdisplay(outfile, "time,rec,play,bank,sample,recording,playing,out");
        clk = 0;
        rec = 0; play = 0; bank = 0; sample = 0;
        // Writes a line to the file every time one of the signals changes
        $fmonitor(outfile, "%0t,%b,%b,%0d,%0d,%b,%b,%0d", $time, rec, play, bank, sample, recording, playing, out_shown);

        rec = 1; #400;      // record 10 samples into bank 0
        rec = 0; #40;
        bank = 1;
        rec = 1; #400;      // record 10 samples into bank 1
        rec = 0; #40;
        rec = 1; #120;      // record 3 samples over the start of bank 1
        rec = 0; #40;
        bank = 0;
        play = 1; #300;     // play bank 0 past address 2
        bank = 1; #200;     // address is past bank 1's last address, so it wraps to 0
        bank = 0; #200;
        play = 0; #40;
        bank = 3;
        rec = 1; #160;      // record 4 samples into bank 3
        rec = 0; #40;
        bank = 2;
        rec = 1; #120;      // record 3 samples into bank 2
        bank = 3; #120;     // switch to bank 3 while recording: addresses 3-5 of bank 3
        rec = 0; #40;
        play = 1; #280;     // bank 3: addresses 0-2 from the first recording, then 3-5
        bank = 2; #200;     // bank 2: last address is still 2
        play = 0; #40;
        $finish;
    end
endmodule
