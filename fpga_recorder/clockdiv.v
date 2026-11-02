module clockdiv(
    input clk,
    input [31:0] count_to,
    output reg out
);
    initial begin
        out = 0;
    end
    reg [31:0] count = 0;

    always @(posedge clk) begin
        if (count == count_to) begin
            out <= ~out;
            count <= 0;
        end else begin
            count <= count + 1;
        end
    end

endmodule