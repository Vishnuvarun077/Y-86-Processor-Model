`include "fetch.v"
`include "execute.v"
`include "memory.v"
`include "decode_wb.v"
`include "controllogic.v"




module processor;

reg clk;

reg [63:0] Fetch_predPC;
wire [63:0] f_predPC;
reg [0:3] stat = 4'h0;



wire [3:0] D_icode, D_ifun, D_rA, D_rB;
wire signed [63:0] D_valC, D_valP;
wire [0:3] D_stat;

wire [3:0] d_srcA,d_srcB;




wire [3:0] E_icode, E_ifun;
wire signed [63:0] E_valA, E_valB, E_valC;
wire [3:0] E_srcA, E_srcB, E_dstE, E_dstM;
wire [0:3] E_stat;

wire [3:0] e_dstE;
wire signed [63:0] e_valE;
wire e_cnd;




wire [3:0] M_icode, M_dstE, M_dstM;
wire signed [63:0] M_valA, M_valE;
wire [0:3] M_stat;
wire M_cnd;


wire signed [63:0] m_valM;
wire [0:3] m_stat;




wire [0:3] W_stat; 
wire [3:0] W_icode, W_dstE, W_dstM;
wire signed [63:0] W_valE, W_valM;



//registers
wire signed [63:0] rax,rbx,rcx,rdx,rsp,rbp,rsi,rbi,r8,r9,r10,r11,r12,r13,r14;


//control
wire F_stall, D_stall, D_bubble, E_bubble, M_bubble, W_stall, set_cc;


always #5 clk = ~clk;


Fetch fetch(clk,F_stall,D_stall,D_bubble,M_cnd,M_icode,W_icode,M_valA,W_valM,Fetch_predPC,f_predPC,D_icode, D_ifun, D_rA, D_rB,D_valC, D_valP,D_stat  );

Decode decode(clk,D_icode,D_ifun,D_rA,D_rB,D_valC,D_valP,D_stat,e_dstE,M_dstE,M_dstM,W_dstE,W_dstM,e_valE,m_valM,M_valE,W_valM,W_valE,E_bubble,W_icode,rax,rbx,rcx,rdx,rsp,rbp,rsi,rbi,r8,r9,r10,r11,r12,r13,r14,E_icode, E_ifun, E_dstE, E_dstM, E_srcA, E_srcB,E_valC, E_valA, E_valB, E_stat ,d_srcA,d_srcB);

Execute execute(clk,E_icode, E_ifun, E_dstE, E_dstM, E_srcA, E_srcB,E_valC, E_valA, E_valB,E_stat,W_stat,m_stat,e_dstE,e_valE,M_icode, M_dstE, M_dstM,M_valE, M_valA,M_stat,M_cnd ,e_cnd);


Memor memory(clk,M_icode, M_dstE, M_dstM,M_valE, M_valA,M_stat,M_cnd,W_icode, W_dstE, W_dstM,W_valE, W_valM,W_stat,m_valM,m_stat);

controllogic  control(D_icode, d_srcA, d_srcB,E_icode, E_dstM,e_cnd,M_icode,m_stat,W_stat, E_bubble, D_stall, D_bubble,F_stall);


always @(stat)
begin
    case (stat)
        4'h2:
        begin
            $display("Invalid Instruction ");
            $finish;
        end
        4'h3:
        begin
            $display("Invalid Memory Address ");
            $finish;
        end
        4'h4:
        begin
            $display(" Halt");
            $finish;
        end
        4'h1:
        begin
          
        end
    endcase    
end

always @(W_stat)
begin
    stat = W_stat;
end

always @(posedge clk )
begin
    Fetch_predPC = f_predPC;    
end

initial begin

    $dumpfile("processor.vcd");
    $dumpvars(0,processor);
    Fetch_predPC = 64'd0;
    clk = 0; 
   
    $monitor("Time = %0t \t\t\t clk = %b \n\n Fetch\nF_predPC = %0d, \t\t F_stall = %0d, \t\t D_bubble = %0d, \t\tD_stall = %0d, \t\t f_predPC = %0d,\n\nDecode\nD_icode =%0d, D_ifun =%0d, D_rA =%0d, D_rB =%0d, D_valC =%0d, D_valP =%0d, D_stat %0d, d_srcA=%0d, d_srcB=%0d,\n\nExecute-\nE_icode=%0d, E_ifun=%0d, E_dstE=%0d, E_dstM=%0d, E_srcA=%0d, E_srcB=%0d,E_valC=%0d, E_valA=%0d, E_valB=%0d, E_stat =%0d,\n\nMemory\nM_icode =%0d, M_dstE =%0d, M_dstM =%0d,M_valE =%0d, M_valA =%0d,M_stat =%0d,M_cnd =%0d,\n\n-Write Back\nW_icode = %0d, W_dstE = %0d, W_dstM = %0d,W_valE = %0d, W_valM = %0d,W_stat = %0d,\n\nrax = %0d\t\t||\t\trbx= %0d\t\t||\t\trcx= %0d\t\t||\t\trdx= %0d\t\t||\t\trsp= %0d\t\t||\t\trbp= %0d\n\nrsi= %0d\t\t||\t\trbi= %0d\t\t||\t\tr8= %0d\t\t||\t\tr9= %0d\n\nr10= %0d\t\t||\t\tr11= %0d\t\t||\t\tr12= %0d\t\t||\t\tr13= %0d\t\t||\t\tr14= %0h\n\n\n\n ",$time,clk,Fetch_predPC,F_stall,D_bubble,D_stall,f_predPC,D_icode,D_ifun,D_rA,D_rB,D_valC,D_valP,D_stat,d_srcA,d_srcB,E_icode, E_ifun, E_dstE, E_dstM, E_srcA, E_srcB,E_valC, E_valA, E_valB, E_stat ,M_icode, M_dstE, M_dstM,M_valE, M_valA,M_stat,M_cnd,W_icode, W_dstE, W_dstM,W_valE, W_valM,W_stat,rax,rbx,rcx,rdx,rsp,rbp,rsi,rbi,r8,r9,r10,r11,r12,r13,r14);
end

endmodule