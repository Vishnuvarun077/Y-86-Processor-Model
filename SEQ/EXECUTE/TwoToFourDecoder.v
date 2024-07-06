module TwoToFourDecoder (
    input A0,
    input A1,
    output D0,
    output D1,
    output D2,
    output D3
);

and andgate1(D0,~A0,~A1);
and andgate2(D1,A0,~A1);
and andgate3(D2,~A0,A1);
and andgate4(D3,A0,A1);

endmodule