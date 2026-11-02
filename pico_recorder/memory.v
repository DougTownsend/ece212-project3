module memory(
    input clk,
    input we,
    input [7:0] waddr,
    input [3:0] wdata,
    input [7:0] raddr,
    output reg [3:0] rdata
);
    /*
    A memory that holds 256 4-bit values. The memory is not initialized,
    so an address that has never been written holds an unknown value.

    At each positive clock edge:
        -If we (write enable) is high, wdata is written to address waddr
        -rdata is set to the value stored at address raddr

    Reading on the clock edge, instead of with combinational logic, lets
    the FPGA put the memory in its block RAM. If the same address is
    written and read on the same clock edge, rdata gets the old value.

    Declare the memory as an array:
        reg [3:0] mem [0:255];
    */
    //Do not modify above this line



endmodule
