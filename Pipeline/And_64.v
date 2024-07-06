module And_64(A,B,AND);
input [63:0] A,B;
output [63:0] AND;

genvar i;

generate
    for(i = 0; i < 64; i=i+1) begin
        and andgate1(AND[i],A[i],B[i]);
    end
endgenerate

endmodule