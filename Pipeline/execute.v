`include "alu_64.v"

module Execute (

    input clk,
    input [3:0] Execute_icode, Execute_ifun, Execute_dstE, Execute_dstM, Execute_srcA, Execute_srcB,   
    input [63:0] Execute_valC, Execute_valA, Execute_valB,        
    input [0:3] Execute_stat,

    input [0:3] Write_stat,memory_stat,

    output reg [3:0] execute_dstE,
    output reg [63:0] execute_valE,


    output reg [3:0] Memory_icode, Memory_dstE, Memory_dstM,
    output reg [63:0] Memory_valE, Memory_valA,
    output reg [0:3] Memory_stat,
    output reg Memory_cnd,execute_cnd


);

reg signed [63:0] A_val, B_val;
reg zf,of,sf;
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
    if(Execute_icode==4'b0110 && clk==1)
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
// Assign input values based on Execute_icode
always @(*) begin
    
        execute_cnd = 0;
        case (Execute_icode)
            4'b0010: begin // CMOVXX
                case (Execute_ifun)
                    4'b0000: begin // RRMovq
                        execute_cnd = 1;
                    end
                    4'b0001: begin // CMOVLE
                    // // (sf^of)||zf
                    xorin1<=sf;
                    xorin2<=of;
                    orin1<=xorout;
                    orin2<=zf;
                    execute_cnd<=orout;
                    end
                    4'b0010: begin // CMOVL
                        // sf^of
                        xorin1<=sf;
                        xorin2<=of;
                        execute_cnd<=xorout;
                    end
                    4'b0011: begin // CMOVE
                        execute_cnd <= zf;
                    end
                    4'b0100: begin // CMOVNE
                    notin1<=zf;   
                    execute_cnd<=notout1;
                    end
                    4'b0101: begin // CMOVGE
                        // !(sf^of)
                        xorin1<=sf;
                        xorin2<=of;
                        notin1<=xorout;
                        execute_cnd<=notout1;
                    end
                    4'b0110: begin // CMOVG
                        // !(sf^of)&&!(zf)
                        xorin1<=sf;
                        xorin2<=of;
                        notin1<=xorout;
                        andin1<=notout1;
                        notin2<=zf;
                        andin2<=notout2;
                        execute_cnd<=andout;
                    end
            
            endcase
            execute_valE <= Execute_valA;
        end
        4'b0011: begin // IRMOVQ
            execute_valE <= Execute_valC;
        end
        4'b0100: begin // RMMOVQ
            execute_valE <= Execute_valB + Execute_valC;
        end
        4'b0101: begin // MRMOVQ
            execute_valE <= Execute_valB + Execute_valC;
        end
        4'b0110: begin // OPQ
            case (Execute_ifun)
                4'b0000: begin //add
                    A_val <= Execute_valA;
                    B_val <= Execute_valB;
                    alu_control <= 2'b00;  
                end
                4'b0001: begin // sub
                    A_val = Execute_valB;
                    B_val = Execute_valA;
                    alu_control <= 2'b01;
                end
                4'b0010: begin // and
                    A_val = Execute_valA;
                    B_val = Execute_valB;
                    alu_control <= 2'b10;
                end
                4'b0011: begin // xor
                    A_val <= Execute_valA;
                    B_val <= Execute_valB;
                    alu_control <= 2'b11;
                end
            endcase
            execute_valE<=alu_valE;
        end
        4'b0111: begin // JXX
             case (Execute_ifun)
                4'b0000: begin // JMP
                    execute_cnd = 1;
                end
                4'b0001: begin // JLE
                   // // (sf^of)||zf
                   xorin1=sf;
                   xorin2=of;
                   orin1=xorout;
                   orin2=zf;
                   execute_cnd=orout;
                end
                4'b0010: begin // JL
                    // sf^of
                    xorin1=sf;
                    xorin2=of;
                    execute_cnd=xorout;
                end
                4'b0011: begin // JE
                    execute_cnd = zf;
                end
                4'b0100: begin // JNE
                   notin1=zf;   
                   execute_cnd=notout1;
                end
                4'b0101: begin // JGE
                    // !(sf^of)
                    xorin1=sf;
                    xorin2=of;
                    notin1=xorout;
                    execute_cnd=notout1;
                end
                4'b0110: begin // JG
                    // !(sf^of)&&!(zf)
                     xorin1=sf;
                    xorin2=of;
                    notin1=xorout;
                    andin1=notout1;
                    notin2=zf;
                    andin2=notout2;
                    execute_cnd=andout;
                end
            endcase
            execute_valE = Execute_valA;
        end
        4'b1000: begin // CALL
            execute_valE = Execute_valB - 64'd8  ;
        end
        4'b1001: begin // RET
            execute_valE = 64'd8 + Execute_valB;
        end
        4'b1010: begin // PUSHQ
            execute_valE = -64'd8 + Execute_valB;
        end
        4'b1011: begin
            execute_valE=64'd8 + Execute_valB; // POPQ
        end
    endcase
    //checking for condition
      if(Execute_icode == 2 || Execute_icode == 7)
        begin
            execute_dstE = (execute_cnd == 1) ? Execute_dstE : 4'b1111;
        end
        else
        begin
            execute_dstE = Execute_dstE;
        end
end
    // writiing to pipeline registers;
    always @(posedge clk)
    begin
        Memory_stat <= Execute_stat;
        Memory_icode <= Execute_icode;
        Memory_cnd <= execute_cnd;
        Memory_valE <= execute_valE;
        Memory_valA <= Execute_valA;
        Memory_dstE <= execute_dstE;
        Memory_dstM <= Execute_dstM;
    end

endmodule









