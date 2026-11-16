module adc_dp(
    input clk,
    input inc,
    input clr,
    input load,
    output reg [4:0] dac,
    output reg [3:0] result,
    output max
);
    /*
    Datapath for the ADC. It holds two registers, which both start at 0:
        -dac: the 5 bit value being output to the R-2R ladder
        -result: the most recent ADC reading

    At each positive clock edge:
        -If clr is high, dac is set to 0
        -Otherwise, if inc is high, dac increases by 1
        -If load is high, result is set to the upper 4 bits of dac (dac[4:1])
    clr and load can be high at the same time. result gets the value dac
    had before it was cleared.

    max is high whenever dac is 31, its largest value.
    */
    //Do not modify above this line



endmodule
