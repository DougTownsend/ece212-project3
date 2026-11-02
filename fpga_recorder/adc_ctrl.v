module adc_ctrl(
    input clk,
    input start,
    input comp,
    input max,
    output reg inc,
    output reg clr,
    output reg load
);
    /*
    Control FSM for the ADC. It has four states, and starts in IDLE:

    IDLE:   Waiting for a conversion to start. All outputs are 0.
            If start is high, go to SETTLE. Otherwise stay in IDLE.
    SETTLE: Gives the DAC and comparator a clock cycle to settle on the
            new voltage. All outputs are 0.
            If comp is high or max is high, go to DONE. Otherwise go to INC.
    INC:    inc is high, so the datapath adds 1 to dac. Always go to SETTLE.
    DONE:   load and clr are high, so the datapath saves the result and
            sets dac back to 0. Always go to IDLE.

    This holds each DAC value for two clock cycles (SETTLE and then INC or
    DONE), and samples the comparator on the clock edge in between.

    comp is the comparator output. It is high when the DAC output voltage
    is higher than the analog input voltage.
    max is high when dac is 31, so the conversion stops instead of wrapping
    around to 0 if the input is higher than the DAC can go.
    */
    //Do not modify above this line



endmodule
