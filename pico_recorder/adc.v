module adc(
    input clk,
    input start,
    input comp,
    output [4:0] dac,
    output [3:0] result
);
    /*
    Analog to digital converter. Instantiate one adc_ctrl and one adc_dp,
    and connect them with wires:
        -adc_ctrl's inc, clr, and load outputs go to adc_dp
        -adc_dp's max output goes to adc_ctrl
        -clk, start, and comp go to adc_ctrl (and clk to adc_dp)
        -adc_dp's dac and result outputs are the outputs of this module

    When start is high, a conversion begins. dac counts up from 0 until the
    comparator output goes high, and result is set to dac[4:1].
    */
    //Do not modify above this line



endmodule
