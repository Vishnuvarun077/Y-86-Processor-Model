

`include "fetch.v"
`include "execute.v"
`include "decode_writeback.v"
`include "memory.v"
`include "pc_update.v"

module processor;
  reg clk;
  
  reg [63:0] PC;

  reg stat[0:2]; // |AOK|INS|halt|

  wire [3:0] icode;
  wire [3:0] ifun;
  wire [3:0] rA;
  wire [3:0] rB; 
  wire [63:0] valC;
  wire [63:0] valP;
  wire instruction_valid;
  wire imem_error;
  wire [63:0] valA;
  wire [63:0] valB;
  wire [63:0] valE;
  wire [63:0] valM;
  wire cnd;
  wire halt;
  wire [63:0] updated_pc;

  wire [63:0] rax;
  wire [63:0] rcx;
  wire [63:0] rdx;
  wire [63:0] rbx;
  wire [63:0] rsp;
  wire [63:0] rbp;
  wire [63:0] rsi;
  wire [63:0] rdi;
  wire [63:0] r8;
  wire [63:0] r9;
  wire [63:0] r10;
  wire [63:0] r11;
  wire [63:0] r12;
  wire [63:0] r13;
  wire [63:0] r14;

  wire [63:0] datamem;

  wire sf;
  wire zf;
  wire of;

  fetch fetch(
    .clk(clk),
    .PC(PC),
    .icode(icode),
    .ifun(ifun),
    .rA(rA),
    .rB(rB),
    .valC(valC),
    .valP(valP),
    .instruction_valid(instruction_valid),
    .imem_error(imem_error),
    .halt(halt)
  );

  Execute Execute(
    .clk(clk),
    .icode(icode),
    .ifun(ifun),
    .valA(valA),
    .valB(valB),
    .valC(valC),
    .valE(valE),
    .cnd(cnd),
    .zf(zf),
    .sf(sf),
    .of(of)
  );

  decode_writeback decode_writeback(
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

  Memory mem(
 
    .icode(icode),
    .valA(valA),
    .valB(valB),
    .valE(valE),
    .valP(valP),
    .valM(valM),
    .datamem(datamem)
  );

  pc_update pcup(
    .updated_pc(updated_pc),
    .icode(icode),
    .cnd(cnd),
    .valC(valC),
    .valM(valM),
    .valP(valP),
     .clk(clk)
  ); 

  always #5 clk=~clk;
  always@(*)
  begin
    if(stat[2]==1'b1)
    begin
      $finish;
    end
  end
  initial begin
    $dumpfile("processor.vcd");
    $dumpvars(0,processor);
    stat[0]<=1;
    stat[1]<=0;
    stat[2]<=0;
    clk<=0;
    PC<=64'd34;
    $monitor("time=%0t, clk=%b, icode=%b, ifun=%b, \nrA=%b, rB=%b, \nvalA=%d, valB=%d, valC=%d, valE=%d, valM=%d, \nvalP=%d, instructionvalid=%b, imem_err=%b, cnd=%b, halt=%b, PC=%d\n,rbx=%d, rdx=%d, rax=%d\n", $time, clk, icode, ifun, rA, rB, valA, valB, valC, valE, valM, valP,  instruction_valid, imem_error, cnd, halt,PC,(rbx),(rdx),rax);
//  $monitor("time=%0t, clk=%b, rax=%d, rcx=%d, rdx=%d, rbx=%d, rsp=%h, rbp=%d, rsi=%d, rdi=%d, r8=%d, r9=%d, r10=%d, r11=%d, r12=%d, r13=%d, r14=%d", $time, clk, rax, rcx, rdx, rbx, rsp, rbp, rsi, rdi, r8, r9, r10, r11, r12, r13, r14);


  end 

  always@(*)
  begin
    PC=updated_pc;
  end



  always@(*)
  begin
    stat[2]=1'b0;
    stat[1]=1'b0;
    stat[0]=1'b0;
    if(halt)
    begin
      stat[2]=1'b1;
      // $finish;
    end
    else if(instruction_valid)
    begin
      stat[1]=1'b1;
    end
    else
    begin
      stat[0]=1'b1;
    end
  end
  
 

  // initial
  // begin 
  // $display("time=%0t, clk =%b, icode=%b, ifun=%b, \nrA=%b, rB=%b, \nvalA=%d, valB=%d, valC=%d, valE=%d, valM=%d, \ninstructionvalid=%b, imem_err=%b, cnd=%b, halt=%b, PC = %d\n\n", $time, clk, icode, ifun, rA, rB, valA, valB, valC, valE, valM, instruction_valid, imem_error, cnd, halt,PC);
  // $display("\n\n");
  // end


endmodule