// `include "fulladder.v"
module Subtractor_64( 
    input [63:0] A,
    input [63:0] B,
    output [63:0] S,
    output cout
);

wire [64:0]Di,notB ;
assign Di[0]=1'b1;

genvar i;
generate
    for(i=0;i<64;i=i+1)
    begin
        not Not(notB[i],B[i]);
        fulladder FA(A[i],notB[i],Di[i],S[i],Di[i+1]);
    end
endgenerate

assign cout = Di[64]; 

endmodule

// time =0 ,
// a   = 0000000000000000000000000000000000000000000000000000000000110110 ,
// b   = 0000000000000000000000000000000000000000000000000000000000101110 ,
// S   = 0000000000000000000000000000000000000000000000000000000000001000 ,
// Cout = 1
// time =5 ,
// a   = 1111111111111111111111111111111111111111111111111111111111111111 ,
// b   = 0000000000000000000000000000000000000000000000000000000000001010 ,
// S   = 1111111111111111111111111111111111111111111111111111111111110101 ,
// Cout = 1
// time =10 ,
// a   = 0000000000000000000000000000000000000000000000000000001111101000 ,
// b   = 1111111111111111111111111111111111111111111111111111111111110001 ,
// S   = 0000000000000000000000000000000000000000000000000000001111110111 ,
// Cout = 0
// time =15 ,
// a   = 1111111111111111111111111111111111111111111111111111111000111001 ,
// b   = 1111111111111111111111111111111111111111111111111111111111010011 ,
// S   = 1111111111111111111111111111111111111111111111111111111001100110 ,
// Cout = 0
// time =20 ,
// a   = 1000000000000000000000000000000000000000000000000000000000000000 ,
// b   = 0100000000000000000000000000000000000000000000000000000000000000 ,
// S   = 0100000000000000000000000000000000000000000000000000000000000000 ,
// Cout = 1
// time =25 ,
// a   = 0100000000000000000000000000000000000000000000000000000000000000 ,
// b   = 1100000000000000000000000000000000000000000000000000000000000000 ,
// S   = 1000000000000000000000000000000000000000000000000000000000000000 ,
// Cout = 0