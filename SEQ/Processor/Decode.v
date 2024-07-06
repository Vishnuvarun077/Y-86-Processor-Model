module Decode(valA, valB, rA, rB, icode);

input [3:0] rA, rB, icode;
output wire [63:0] valA, valB;

reg [63:0] rax, rcx, rdx, rbx, rsp, rbp, rsi, rdi, r8, r9, r10, r11, r12, r13, r14;

initial begin
    rax = 64'b0000;
    rcx = 64'b0001;
    rdx = 64'b0010;
    rbx = 64'b0011;
    rsp = 64'b0100;
    rbp = 64'b0101;
    rsi = 64'b0110;
    rdi = 64'b0111;
    r8  = 64'b1000;
    r9  = 64'b1001;
    r10 = 64'b1010;
    r11 = 64'b1011;
    r12 = 64'b1100;
    r13 = 64'b1101;
    r14 = 64'b1110;
end

assign srcA = (icode == 4'b0010 || icode == 4'b0100 || icode == 4'b0110 || icode == 4'b1010) ? rA :
              (icode == 4'b1001 || icode == 4'b1011) ? 4'b0100 : 4'b1111;

assign srcB = (icode == 4'b0100 || icode == 4'b0101 || icode == 4'b0110) ? rB :
              (icode == 4'b0010) ? 4'b0000 :
              (icode == 4'b1000 || icode == 4'b1001 || icode == 4'b1010 || icode == 4'b1011) ? 4'b0100 : 4'b1111;

assign valA = (srcA == 4'b0000) ? rax :
              (srcA == 4'b0001) ? rcx :
              (srcA == 4'b0010) ? rdx :
              (srcA == 4'b0011) ? rbx :
              (srcA == 4'b0100) ? rsp :
              (srcA == 4'b0101) ? rbp :
              (srcA == 4'b0110) ? rsi :
              (srcA == 4'b0111) ? rdi :
              (srcA == 4'b1000) ? r8 :
              (srcA == 4'b1001) ? r9 :
              (srcA == 4'b1010) ? r10 :
              (srcA == 4'b1011) ? r11 :
              (srcA == 4'b1100) ? r12 :
              (srcA == 4'b1101) ? r13 :
              (srcA == 4'b1110) ? r14 : 64'b0;

assign valB = (srcB == 4'b0000) ? rax :
              (srcB == 4'b0001) ? rcx :
              (srcB == 4'b0010) ? rdx :
              (srcB == 4'b0011) ? rbx :
              (srcB == 4'b0100) ? rsp :
              (srcB == 4'b0101) ? rbp :
              (srcB == 4'b0110) ? rsi :
              (srcB == 4'b0111) ? rdi :
              (srcB == 4'b1000) ? r8 :
              (srcB == 4'b1001) ? r9 :
              (srcB == 4'b1010) ? r10 :
              (srcB == 4'b1011) ? r11 :
              (srcB == 4'b1100) ? r12 :
              (srcB == 4'b1101) ? r13 :
              (srcB == 4'b1110) ? r14 : 64'b0;

endmodule
