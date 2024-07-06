module Xor_64(
    output [63:0] Out,
    input [63:0] A,
    input [63:0] B
);

  genvar i;

generate
    for(i = 0; i < 64; i=i+1) begin
        xor X1(Out[i],A[i],B[i]);
    end
endgenerate

endmodule
