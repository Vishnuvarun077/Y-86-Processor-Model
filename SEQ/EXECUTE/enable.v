module enable(
    input E,
    input [63:0] A,
    input [63:0] B,
    output reg [63:0] C,
    output reg [63:0] D
);

wire [63:0] C_wire, D_wire;

generate
    genvar i;
    for (i = 0; i < 64; i = i + 1) begin : AND_LOOP
        and andgate1(C_wire[i], E, A[i]);
        and andgate2(D_wire[i], E, B[i]);
    end
endgenerate

always @* begin
    C = C_wire;
    D = D_wire;
end

endmodule
