module main(
    input clk,
    input [3:0] btn,
    input [7:0] sw,
    input comp,
    output [4:0] dac,
    output strobe,
    output data,
    output shift_clk
);
    /*
    Top module. The following modules will be used in this:
        -tick
        -adc
        -led_bar

    Inputs:
        -comp is the comparator output.
        -btn and sw are not used in this project.

    Connections:
        -tick's output is the adc's start input, so a new conversion
         starts 10 times per second.
        -The dac output comes from the adc.

    Display:
        -The LEDs show the adc's result using the led_bar module.
        -The seven-segment display is not used, and all of its segments
         are off.

    You can change the wire declared below to a reg.
    */
    wire [7:0] led;
    shift_reg sreg(led, 8'b00000000, clk, strobe, data, shift_clk);
    //Do not modify above this line



endmodule
