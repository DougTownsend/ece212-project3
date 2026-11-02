module tick(
    input clk,
    output tick
);
    /*
    Produces a pulse that is high for one clock cycle out of every 100.
    With the 1kHz clock, this is 10 pulses per second, which sets the
    sample rate for recording and playback.

    Use a 7 bit counter that starts at 0 and increases by 1 at every
    positive clock edge. When the counter is 99, the next value is 0.
    tick is high while the counter is 99, and low otherwise.
    */
    //Do not modify above this line



endmodule
