module recorder(
    input clk,
    input tick,
    input rec,
    input play,
    input [1:0] bank,
    input [3:0] sample,
    output recording,
    output playing,
    output reg [3:0] out
);
    /*
    Records ADC samples into one of 4 memory banks, and plays them back.

    Memory:
        -Instantiate 4 memory modules, one for each bank. Bank 0 is the
         first memory module, bank 1 is the second, and so on.
        -All of the memory modules share the same waddr (the record
         address), wdata (sample), and raddr (the play address).
        -Only the selected bank's memory module has its we input high.
        -out is the rdata output of the selected bank's memory module.
        -Each bank has an 8 bit "last" register that holds the address of
         the last sample recorded in that bank. These all start at 0.
        -bank selects which bank is recorded to or played from. If it
         changes, the new bank is used right away.

    Recording (rec is the debounced record button):
        -recording is high while rec is high and the bank is not full.
        -A record address register starts at 0. While rec is low, it is
         set to 0, so every press records from the start of the bank.
        -At each positive clock edge where recording and tick are both high:
            -sample is written to the current bank at the record address
            -that bank's last register is set to the record address
            -the record address increases by 1, unless it is 255. If it is
             255, the bank is full, and recording goes low until rec is
             released and pressed again.

    Playback (play is the debounced play button):
        -playing is high while play is high and rec is low. Recording
         takes priority over playback.
        -A play address register starts at 0. While playing is low, it is
         set to 0, so every press plays from the start of the bank.
        -At each positive clock edge where playing and tick are both high,
         the play address increases by 1. If the play address is greater
         than or equal to the bank's last register, it goes back to 0
         instead. This loops over the recording.
    */
    //Do not modify above this line



endmodule
