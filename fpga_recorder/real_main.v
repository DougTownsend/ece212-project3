module real_main(
    input clk,
    input [3:0] btn,
    input [7:0] sw,
    input comp,
    output [4:0] dac,
    output strobe,
    output data,
    output shift_clk
);

    wire clk_1khz;
    clockdiv div_1khz(clk, 6000, clk_1khz);
    main m(clk_1khz, btn, sw, comp, dac, strobe, data, shift_clk);

endmodule
