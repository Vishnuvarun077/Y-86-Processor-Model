module tb_fetch();
    reg clk;
    reg [63:0] PC;
    wire [3:0] icode;
    wire [3:0] ifun;
    wire [3:0] rA;
    wire [3:0] rB;
    wire [63:0] valC;
    wire [63:0] valP;
    wire instruction_valid;
    wire imem_error;
    wire halt;

    fetch tb_fetch(clk, PC, icode, ifun, rA, rB, valC, valP, instruction_valid, imem_error, halt);
  
    initial begin
        $dumpfile("fetch.vcd");
        $dumpvars(0, tb_fetch);
        $monitor("time = %0t , icode = %b , ifun = %b , rA = %b , rB = %b , valC = %d , valP = %d, imem_error = %b, instruction_valid = %b, halt = %b", $time, icode, ifun, rA, rB, valC, valP, imem_error, instruction_valid, halt);

        clk = 0;
        PC = 64'd0;

        for (integer i = 0; i < 57; i = i + 1) begin
            #5 clk = ~clk; 
            #5 PC = valP; 
        end
        $finish;
    end
endmodule
