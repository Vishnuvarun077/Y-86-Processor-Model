`include "alu_64.v"

module Execute(
    input clk,
    input [3:0] icode,
    input [3:0] ifun,
    input [63:0] valA,
    input [63:0] valB,
    input [63:0] valC,
    output reg [63:0] valE,
    output reg cnd,
    output reg zf,
    output reg sf,
    output reg of
);

// Internal signals for ALU operation
reg signed [63:0] A_val, B_val;
reg [1:0] alu_control;
wire signed [63:0] alu_valE;
 reg notin1,notin2,orin1,orin2,andin1,andin2, xorin1,xorin2;
  wire xorout,orout,andout,notout1,notout2;
 
  not notgate1(notout1,notin1);
  not notgate2(notout2,notin2);
  or orgate(orout,orin1,orin2);
  and andgate(andout,andin1,andin2);
  xor xorgate(xorout,xorin1,xorin2);


// ALU instantiation
 initial
  begin
    alu_control<=2'b00;
		A_val <= 64'b0;
		B_val <= 64'b0;
  end
  
alu_64 alu_inst(
    .alu_fun(alu_control),
    .A(A_val),
    .B(B_val),
    .valE(alu_valE)
);

  always@(*)
  begin
    if(icode==4'b0110 && clk==1)
    begin
      zf<=(alu_valE==1'b0);
      sf<=(alu_valE<1'b0);
      of<=(A_val<1'b0==B_val<1'b0)&&(alu_valE<1'b0!=A_val<1'b0);
    end
    else begin
      zf<=1'b0;
      sf<=1'b0;
      of<=1'b0;
    end 
  end
// Assign input values based on icode
always @(*) begin
    if(clk) begin
        cnd = 0;
        case (icode)
            4'b0010: begin // CMOVXX
                case (ifun)
                    4'b0000: begin // RRMovq
                        cnd = 1;
                    end
                    4'b0001: begin // CMOVLE
                    // // (sf^of)||zf
                    xorin1<=sf;
                    xorin2<=of;
                    orin1<=xorout;
                    orin2<=zf;
                    cnd<=orout;
                    end
                    4'b0010: begin // CMOVL
                        // sf^of
                        xorin1<=sf;
                        xorin2<=of;
                        cnd<=xorout;
                    end
                    4'b0011: begin // CMOVE
                        cnd <= zf;
                    end
                    4'b0100: begin // CMOVNE
                    notin1<=zf;   
                    cnd<=notout1;
                    end
                    4'b0101: begin // CMOVGE
                        // !(sf^of)
                        xorin1<=sf;
                        xorin2<=of;
                        notin1<=xorout;
                        cnd<=notout1;
                    end
                    4'b0110: begin // CMOVG
                        // !(sf^of)&&!(zf)
                        xorin1<=sf;
                        xorin2<=of;
                        notin1<=xorout;
                        andin1<=notout1;
                        notin2<=zf;
                        andin2<=notout2;
                        cnd<=andout;
                    end
            
            endcase
            valE <= valA;
        end
        4'b0011: begin // IRMOVQ
            valE <= valC;
        end
        4'b0100: begin // RMMOVQ
            valE <= valB + valC;
        end
        4'b0101: begin // MRMOVQ
            valE <= valB + valC;
        end
        4'b0110: begin // OPQ
            case (ifun)
                4'b0000: begin //add
                    A_val <= valA;
                    B_val <= valB;
                    alu_control <= 2'b00;  
                end
                4'b0001: begin // sub
                    A_val <= valB;
                    B_val <= valA;
                    alu_control <= 2'b01;
                end
                4'b0010: begin // and
                    A_val <= valA;
                    B_val <= valB;
                    alu_control <= 2'b10;
                end
                4'b0011: begin // xor
                    A_val <= valA;
                    B_val <= valB;
                    alu_control <= 2'b11;
                end
            endcase
            valE<=alu_valE;
        end
        4'b0111: begin // JXX
             case (ifun)
                4'b0000: begin // JMP
                    cnd = 1;
                end
                4'b0001: begin // JLE
                   // // (sf^of)||zf
                   xorin1=sf;
                   xorin2=of;
                   orin1=xorout;
                   orin2=zf;
                   cnd=orout;
                end
                4'b0010: begin // JL
                    // sf^of
                    xorin1=sf;
                    xorin2=of;
                    cnd=xorout;
                end
                4'b0011: begin // JE
                    cnd = zf;
                end
                4'b0100: begin // JNE
                   notin1=zf;   
                   cnd=notout1;
                end
                4'b0101: begin // JGE
                    // !(sf^of)
                    xorin1=sf;
                    xorin2=of;
                    notin1=xorout;
                    cnd=notout1;
                end
                4'b0110: begin // JG
                    // !(sf^of)&&!(zf)
                     xorin1=sf;
                    xorin2=of;
                    notin1=xorout;
                    andin1=notout1;
                    notin2=zf;
                    andin2=notout2;
                    cnd=andout;
                end
            endcase
            valE = valA;
        end
        4'b1000: begin // CALL
            valE = valB - 64'd8  ;
        end
        4'b1001: begin // RET
            valE = 64'd8 + valB;
        end
        4'b1010: begin // PUSHQ
            valE = -64'd8 + valB;
        end
        4'b1011: begin
            valE=64'd8 + valB; // POPQ
        end
    endcase
    end
end

endmodule
