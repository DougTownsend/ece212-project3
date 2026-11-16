module led_bar(
    input [3:0] in,
    output reg [7:0] led
);
    /*
    Displays a 4 bit value on the 8 LEDs as a position along the bar.
    The 16 possible values map onto the 8 LEDs as follows:
        -0 turns all LEDs off
        -An odd value lights one LED: 1 -> led[0], 3 -> led[1], ... 15 -> led[7]
        -An even value lights the two LEDs on either side of it, since it
         is in between them: 2 -> led[1:0], 4 -> led[2:1], ... 14 -> led[7:6]

        in   led
        0    00000000
        1    00000001
        2    00000011
        3    00000010
        4    00000110
        ...
        14   11000000
        15   10000000
    */
    //Do not modify above this line



endmodule
