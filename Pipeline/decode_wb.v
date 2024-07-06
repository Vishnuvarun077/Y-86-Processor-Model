module Decode (
    input clk,
    input [3:0] D_icode,D_ifun,D_rA,D_rB,
    input [63:0] D_valC,D_valP,
    input [0:3] D_stat,
    input [3:0] e_dstE,M_dstE,M_dstM,W_dstE,W_dstM,
    input [63:0] e_valE,m_valM,M_valE,W_valM,W_valE,
    input E_bubble,
    input [3:0] W_icode,
    
    output reg [63:0] rax,rbx,rcx,rdx,rsp,rbp,rsi,rbi,r8,r9,r10,r11,r12,r13,r14,
    // for next stage pipe line registers
    output reg [3:0] E_icode, E_ifun, E_dstE, E_dstM, E_srcA, E_srcB,   
    output reg [63:0] E_valC, E_valA, E_valB,        
    output reg [0:3] E_stat,
    output reg [3:0] d_srcA,d_srcB  
);
    reg [3:0] d_dstE, d_dstM;
    reg [63:0] d_valA, d_valB;                                      
    reg [63:0] d_rvalA, d_rvalB;                                    
    reg [63:0] reg_file[0:14];                                      

// assigning values to the reg_files initially
    initial begin
        reg_file[0] = 64'd0;        //rax
        reg_file[1] = 64'd0;        //rcx
        reg_file[2] = 64'd0;       //rdx
        reg_file[3] = 64'd0;       //rbx
        reg_file[4] = 64'd256;       //rsp
        reg_file[5] = 64'd64;        //rbp
        reg_file[6] = 64'd0;      //rsi
        reg_file[7] = 64'd0;     //rdi
        reg_file[8] = 64'd0;    //r8
        reg_file[9] = 64'd0;    //r9
        reg_file[10] = 64'd0;    //r10
        reg_file[11] = 64'd0;    //r11
        reg_file[12] = 64'd0;        //r12
        reg_file[13] = 64'd0;     //r13
        reg_file[14] = 64'd0;     //r14
    end


      //Decode
    always @(*) begin
        if (D_icode == 4'b0000) begin // halt
    // No action needed
    end else if (D_icode == 4'b0001) begin // nop
        // No action needed
    end else if (D_icode == 4'b0010) begin // cmovXX
        d_srcA = D_rA;
        d_dstE = D_rB;
        d_rvalA = reg_file[d_srcA];
        d_rvalB = 64'd0;
    end else if (D_icode == 4'b0011) begin // irmov
        d_dstE = D_rB;
    end else if (D_icode == 4'b0100) begin // rmmovq
        d_srcA = D_rA;
        d_srcB = D_rB;
        d_rvalA = reg_file[d_srcA];
        d_rvalB = reg_file[d_srcB];
    end else if (D_icode == 4'b0101) begin // mrmovq
        d_srcB = D_rB;
        d_dstM = D_rA;
        d_rvalB = reg_file[d_srcB];
    end else if (D_icode == 4'b0110) begin // opq
        d_srcA = D_rA;
        d_srcB = D_rB;
        d_dstE = D_rB;
        d_rvalA = reg_file[d_srcA];
        d_rvalB = reg_file[d_srcB];
    end else if (D_icode == 4'b0111) begin // jxx
        // No action needed
    end else if (D_icode == 4'b1000) begin // call
        d_srcB = 4;
        d_dstE = 4;
        d_rvalB = reg_file[4];
    end else if (D_icode == 4'b1001) begin // ret
        d_srcA = 4;
        d_srcB = 4;
        d_dstE = 4;
        d_rvalA = reg_file[4];
        d_rvalB = reg_file[4];
    end else if (D_icode == 4'b1010) begin // pushq
        d_srcA = D_rA;
        d_srcB = 4;
        d_dstE = 4;
        d_rvalA = reg_file[d_srcA];
        d_rvalB = reg_file[4];
    end else if (D_icode == 4'b1011) begin // popq
        d_srcA = 4;
        d_srcB = 4;
        d_dstE = 4;
        d_dstM = D_rA;
        d_rvalA = reg_file[4];
        d_rvalB = reg_file[4];
    end else begin
        d_srcA = 4'hF;
        d_srcB = 4'hF;
        d_dstE = 4'hF;
        d_dstM = 4'hF;
    end

    end

    //Data Forwarding
    always @(*) begin

        // for A;
    case(D_icode)
    4'b1000, 4'b0111: d_valA = D_valP;
    default: begin
        case(d_srcA)
            e_dstE: d_valA = e_valE;
            M_dstM: d_valA = m_valM;
            M_dstE: d_valA = M_valE;
            W_dstM: d_valA = W_valM;
            W_dstE: d_valA = W_valE;
            default: d_valA = d_rvalA;
        endcase
    end
endcase

case(d_srcB)
    e_dstE: d_valB = e_valE;
    M_dstM: d_valB = m_valM;
    M_dstE: d_valB = M_valE;
    W_dstM: d_valB = W_valM;
    W_dstE: d_valB = W_valE;
    default: d_valB = d_rvalB;
endcase

    end


    //Write Back
    always @(*) begin
        if (W_icode == 4'b0000) begin // halt 
    // No action needed
end else if (W_icode == 4'b0001) begin // nop
    // No action needed
end else if (W_icode == 4'b0010) begin // cmovXX
    reg_file[W_dstE] = W_valE;
end else if (W_icode == 4'b0011) begin // irmov
    reg_file[W_dstE] = W_valE;
end else if (W_icode == 4'b0100) begin // rmmovq
    // No action needed
end else if (W_icode == 4'b0101) begin // mrmovq
    reg_file[W_dstM] = W_valM;
end else if (W_icode == 4'b0110) begin // opq
    reg_file[W_dstE] = W_valE;
end else if (W_icode == 4'b0111) begin // jxx 
    reg_file[W_dstE] = W_valE;
end else if (W_icode == 4'b1000) begin // call
    reg_file[W_dstE] = W_valE;
end else if (W_icode == 4'b1001) begin // ret
    reg_file[W_dstE] = W_valE;
end else if (W_icode == 4'b1010) begin // pushq
    reg_file[W_dstE] = W_valE;
end else if (W_icode == 4'b1011) begin // popq
    reg_file[W_dstE] = W_valE;
    reg_file[W_dstM] = W_valM;
end


    end
    always @(*) begin
        rax <= reg_file[0];    
        rcx <= reg_file[1];    
        rdx <= reg_file[2];    
        rbx <= reg_file[3];    
        rsp <= reg_file[4];    
        rbp <= reg_file[5];    
        rsi <= reg_file[6];    
        rbi <= reg_file[7];    
        r8  <= reg_file[8];    
        r9  <= reg_file[9];    
        r10 <= reg_file[10];
        r11 <= reg_file[11];
        r12 <= reg_file[12];
        r13 <= reg_file[13];
        r14 <= reg_file[14];
    end

    // writing to pipeline registers;
    always @(posedge clk ) begin
        if (E_bubble == 1'b1) begin
            E_icode <= 4'h1;
            E_ifun <= 4'h0;
            E_valC <= 4'h0;
            E_valA <= 4'h0;
            E_valB <= 4'h0;
            E_dstE <= 4'hF;
            E_dstM <= 4'hF;
            E_srcA <= 4'hF;
            E_srcB <= 4'hF;
            E_stat <= 4'h1;
        end    
        else   begin
            E_icode <= D_icode;
            E_ifun <= D_ifun;
            E_srcA <= d_srcA;
            E_srcB <= d_srcB;
            E_dstE <= d_dstE;
            E_dstM <= d_dstM;
            E_valA <= d_valA;
            E_valB <= d_valB;
            E_valC <= D_valC;
            E_stat <= D_stat;
        end
    end
endmodule