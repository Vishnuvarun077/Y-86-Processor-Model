`timescale 1ns / 1ps

module decode_writeback_tb;

  reg clk, cnd;
  reg [3:0] icode, rA, rB;
  reg [63:0] valE, valM;
  wire [63:0] valA, valB, rax, rcx, rdx, rbx, rsp, rbp, rsi, rdi, r8, r9, r10, r11, r12, r13, r14;

  decode_writeback tb_decode_writeback (
    .clk(clk),
    .cnd(cnd),
    .icode(icode),
    .rA(rA),
    .rB(rB),
    .valE(valE),
    .valM(valM),
    .valA(valA),
    .valB(valB),
    .rax(rax),
    .rcx(rcx),
    .rdx(rdx),
    .rbx(rbx),
    .rsp(rsp),
    .rbp(rbp),
    .rsi(rsi),
    .rdi(rdi),
    .r8(r8),
    .r9(r9),
    .r10(r10),
    .r11(r11),
    .r12(r12),
    .r13(r13),
    .r14(r14)
  );

  initial begin

    $dumpfile("decode_writeback.vcd");
    $dumpvars(0,tb_decode_writeback);
    // $monitor("time=%t, valA=%d, valB=%d, rax=%d, rcx=%d, rdx=%d, \nrbx=%d, rsp=%d, rbp=%d, rsi=%d, rdi=%d, r8=%d, \nr9=%d, r10=%d, r11=%d, r12=%d, r13=%d, r14=%d", $time, valA, valB, rax, rcx, rdx, rbx, rsp, rbp, rsi, rdi, r8, r9, r10, r11, r12, r13, r14);
    // $monitor("\n\n");
    #5
    #5 clk = 0;

    #10 icode = 4'b0000; cnd = 1; rA = 4'b0000; rB = 4'b0000; valE = 64'd0; valM = 64'd0;
    #10 icode = 4'b0010; cnd = 1; rA = 4'b0001; rB = 4'b0010; valE = 64'd123; valM = 64'd0;
    #10 icode = 4'b0110; cnd = 1; rA = 4'b0101; rB = 4'b0110; valE = 64'd456; valM = 64'd0;
    #10 icode = 4'b1011; cnd = 1; rA = 4'b0111; rB = 4'b0100; valE = 64'd789; valM = 64'd987;
    #10 icode = 4'b1000; cnd = 1; rA = 4'b1000; rB = 4'b1001; valE = 64'd0; valM = 64'd0;
    #10 icode = 4'b1001; cnd = 1; rA = 4'b1001; rB = 4'b1010; valE = 64'd0; valM = 64'd0;
    #10 icode = 4'b1010; cnd = 1; rA = 4'b1010; rB = 4'b1011; valE = 64'd0; valM = 64'd0;
    #10 icode = 4'b1011; cnd = 1; rA = 4'b1011; rB = 4'b1100; valE = 64'd0; valM = 64'd0;

    #10 $finish;
  end

  always #5 clk = ~clk;


  always @(*) begin
    $display("time=%t, valA=%d, valB=%d, rax=%d, rcx=%d, rdx=%d, \nrbx=%d, rsp=%d, rbp=%d, rsi=%d, rdi=%d, r8=%d, \nr9=%d, r10=%d, r11=%d, r12=%d, r13=%d, r14=%d", $time, valA, valB, rax, rcx, rdx, rbx, rsp, rbp, rsi, rdi, r8, r9, r10, r11, r12, r13, r14);
    $display("\n\n");
  end

endmodule
