module decode_writeback(
  input clk, 
  input cnd,
  input [3:0] icode,
  input [3:0] rA,
  input [3:0] rB,
  input [63:0] valE,
  input [63:0] valM,
  output reg [63:0] valA,
  output reg [63:0] valB,
  output reg [63:0] rax,
  output reg [63:0] rcx,
  output reg [63:0] rdx,
  output reg [63:0] rbx,
  output reg [63:0] rsp,
  output reg [63:0] rbp,
  output reg [63:0] rsi,
  output reg [63:0] rdi,
  output reg [63:0] r8,
  output reg [63:0] r9,
  output reg [63:0] r10,
  output reg [63:0] r11,
  output reg [63:0] r12,
  output reg [63:0] r13,
  output reg [63:0] r14
);

  reg [63:0] reg_mem[0:14];


initial begin
  reg_mem[0]=64'd0;
  reg_mem[1]=64'd1;
  reg_mem[2]=64'd2;
  reg_mem[3]=64'd3;
  reg_mem[4]=64'd4;
  reg_mem[5]=64'd5;
  reg_mem[6]=64'd6;
  reg_mem[7]=64'd7;
  reg_mem[8]=64'd8;
  reg_mem[9]=64'd9;
  reg_mem[10]=64'd10;
  reg_mem[11]=64'd11;
  reg_mem[12]=64'd12;
  reg_mem[13]=64'd13;
  reg_mem[14]=64'd14;
end


always@(*)

  begin
    valA = (icode == 4'b0010) ? reg_mem[rA] :
           (icode == 4'b0100 || icode == 4'b0110 || icode == 4'b1010) ? reg_mem[rA] :
           (icode == 4'b1001 || icode == 4'b1011) ? reg_mem[4] : 0; // Default value is 0
    
    valB = (icode == 4'b0100 || icode == 4'b0101 || icode == 4'b0110) ? reg_mem[rB] :
           (icode == 4'b1000 || icode == 4'b1010 || icode == 4'b1001 || icode == 4'b1011 ) ? reg_mem[4] : 0; // Default value is 0
    rax = reg_mem[0];
    rcx = reg_mem[1];
    rdx = reg_mem[2];
    rbx = reg_mem[3];
    rsp = reg_mem[4];
    rbp = reg_mem[5];
    rsi = reg_mem[6];
    rdi = reg_mem[7];
    r8 = reg_mem[8];
    r9 = reg_mem[9];
    r10 = reg_mem[10];
    r11 = reg_mem[11];
    r12 = reg_mem[12];
    r13 = reg_mem[13];
    r14 = reg_mem[14];
  end



always @(negedge clk) begin
    case (icode)
        4'b0010: begin // cmovxx
            if (cnd) begin
                reg_mem[rB] = valE;
            end
        end
        4'b0011: begin // irmovq
            reg_mem[rB] = valE;
        end
        4'b0101: begin // mrmovq
            reg_mem[rA] = valM;
        end
        4'b0110: begin // OPq
            reg_mem[rB] = valE;
        end
        4'b1000: begin // call
            reg_mem[4] = valE;
        end
        4'b1001: begin // ret
            reg_mem[4] = valE;
        end
        4'b1010: begin // pushq
            reg_mem[4] = valE;
        end
        4'b1011: begin // popq
            reg_mem[4] = valE;
            reg_mem[rA] = valM;
        end
        default: begin
            
        end
    endcase
    rax = reg_mem[0];
    rcx = reg_mem[1];
    rdx = reg_mem[2];
    rbx = reg_mem[3];
    rsp = reg_mem[4];
    rbp = reg_mem[5];
    rsi = reg_mem[6];
    rdi = reg_mem[7];
    r8 = reg_mem[8];
    r9 = reg_mem[9];
    r10 = reg_mem[10];
    r11 = reg_mem[11];
    r12 = reg_mem[12];
    r13 = reg_mem[13];
    r14 = reg_mem[14];
end



endmodule
