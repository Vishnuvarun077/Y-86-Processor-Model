

module Execute_tb;

    parameter CLK_PERIOD = 10; 

    reg clk;
    reg [3:0] icode;
    reg [3:0] ifun;
    reg [63:0] valA;
    reg [63:0] valB;
    reg [63:0] valC;
    wire [63:0] valE;
    wire cnd;
    wire zf;
    wire sf;
    wire of;


     Execute execute_tb (
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
    
    always #((CLK_PERIOD / 2)) clk = ~clk;
    

    initial begin
        clk = 0;
        $monitor("time =%0t ,valE = %d, cnd = %b, zf = %b, sf = %b, of = %b",$time, valE, cnd, zf, sf, of);
        // Test Case 1: CMOVXX
        icode = 4'b0010; // CMOVXX
        ifun = 4'b0000; // RRMovq
        valA = 64'd100;
        valB = 64'd50;
        valC = 64'd25;
        
        #20; 
        
        // Test Case 2: IRMOVQ
        icode = 4'b0011; 
        ifun = 4'b0000; 
        valA = 64'd0;
        valB = 64'd0;
        valC = 64'd1234;
        
        #20; 
        
        // Test Case 3: RMMOVQ
        icode = 4'b0100; 
        ifun = 4'b0000; 
        valA = 64'd100;
        valB = 64'd50;
        valC = 64'd25;
        
        #20; 
        
        // Test Case 4: MRMOVQ
        icode = 4'b0101;
        ifun = 4'b0000; 
        valA = 64'd100;
        valB = 64'd50;
        valC = 64'd25;
        
        #20; 
        
        // Test Case 5: OPQ - Addition
        icode = 4'b0110; 
        ifun = 4'b0000; // Addition
        valA = 64'd100;
        valB = 64'd50;
        valC = 64'd0;
        
        #20; 
        
        // Test Case 6: OPQ - Subtraction
        icode = 4'b0110; 
        ifun = 4'b0001; // Subtraction
        valA = 64'd100;
        valB = 64'd50;
        valC = 64'd0;
        
        #20; 
        
        // Test Case 7: OPQ -AND
        icode = 4'b0110;
        ifun = 4'b0010; // AND
        valA = 64'd100;
        valB = 64'd50;
        valC = 64'd0;
        
        #20; 
        
        // Test Case 8: OPQ -XOR
        icode = 4'b0110; 
        ifun = 4'b0011; // XOR
        valA = 64'd100;
        valB = 64'd50;
        valC = 64'd0;
        
        #20; 
        
        // Test Case 9: Conditional Jump - JLE
        icode = 4'b0111; // JXX
        ifun = 4'b0001; // JLE
        valA = 64'd100;
        valB = 64'd50;
        valC = 64'd0;
        
        #20; 
        
        // Test Case 10: Unconditional Jump - JMP
        icode = 4'b0111; // JXX
        ifun = 4'b0000; // JMP
        valA = 64'd100;
        valB = 64'd50;
        valC = 64'd0;
        
        #20; 
        
        // Test Case 11: CALL
        icode = 4'b1000; // CALL
        ifun = 4'b0000; 
        valA = 64'd0;
        valB = 64'd50;
        valC = 64'd0;
        
        #20; 
        
        // Test Case 12: RET
        icode = 4'b1001; // RET
        ifun = 4'b0000; 
        valA = 64'd0;
        valB = 64'd50;
        valC = 64'd0;
        
        #20; 
        
        // Test Case 13: PUSHQ
        icode = 4'b1010; // PUSHQ
        ifun = 4'b0000; 
        valA = 64'd0;
        valB = 64'd50;
        valC = 64'd0;
        
        #20; 
        
        // Test Case 14: POPQ
        icode = 4'b1011; // POPQ
        ifun = 4'b0000; 
        valA = 64'd0;
        valB = 64'd50;
        valC = 64'd0;
        
        #20; 
        
        // Finish simulation
        $finish;
    end
    
    // Display outputs
    always @(posedge clk) begin
        
    end
    
endmodule

