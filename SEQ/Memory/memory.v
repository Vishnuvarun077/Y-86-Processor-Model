module Memory(icode,valA,valB,valE,valP,valM,datamem);



input [3:0] icode;
  input [63:0] valA;
  input [63:0] valB;
  input [63:0] valE;
  input [63:0] valP;
  
  output reg [63:0] valM;
  output reg [63:0] datamem;

  reg [63:0] data_mem[0:1023];

  // initial begin
  //   data_mem[4]=64'b1;
  // end


always @(*) begin
    
    valM = 0;
    datamem = 0;
    
case(icode)
  // RMMOVQ instruction
  4'b0100: begin
    data_mem[valE] = valA; // Store valA in data memory at address valE
  end
  
  // CALL instruction
  4'b1000: begin
    data_mem[valE] = valP; // Store valP in data memory at address valE
  end
  
  // PUSHQ instruction
  4'b1010: begin
    data_mem[valE] = valA; // Store valA in data memory at address valE
  end
  
  // Other instructions
  default: begin
    // No action
  end
endcase

// Using case statements for better readability

case(icode)
  // MRMQOVQ instruction
  4'b0101: begin
    valM = data_mem[valE]; // Load value from data memory at address valE into valM
  end
  
  // RET instruction
  4'b1001: begin
    valM = data_mem[valA]; // Load value from data memory at address valA into valM
  end
  
  // POPQ instruction
  4'b1011: begin
    valM = data_mem[valE]; // Load value from data memory at address valE into valM
  end
  
  // Other instructions
  default: begin
    // No action
  end
endcase
datamem=data_mem[valE];
end

endmodule
