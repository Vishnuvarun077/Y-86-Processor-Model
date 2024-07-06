module fulladder(
    input A,
    input B,
    input Cin,
    output S,
    output Cout
);
wire D0, D1, D2, D3;
xor xorgate1(D0, A, B);
xor xorgate2(S, D0, Cin);
and andgate1(D1, A, B);
and andgate2(D2, D0, Cin);
or orgate1(Cout, D1, D2);  
endmodule
