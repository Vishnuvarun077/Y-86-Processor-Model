
module Memory (
    input clk,
    input [3:0] M_icode, M_dstE, M_dstM,
    input [63:0] M_valE, M_valA,
    input [0:3] M_stat,
    input M_cnd,

    output reg [3:0] W_icode, W_dstE, W_dstM,
    output reg [63:0] W_valE, W_valM,
    output reg [0:3] W_stat,

    output reg [63:0] m_valM,
    output reg [0:3] m_stat
);
    reg [63:0] memory [1023:0];
    // reg dmem_error;


    always @(*)begin
       if(M_valE > 1023 || M_valA > 1023) 
        m_stat =  4'h3 ;
        else
        m_stat =  M_stat;     
    end

    always @(*) begin
        if(M_icode == 4'b0101) begin
            m_valM = memory [M_valE]; 
        end
        else if(M_icode == 4'b1001) begin
            m_valM = memory [M_valA];
        end  
        else if(M_icode == 4'b1011) begin
            m_valM = memory [M_valA];
        end
    end

    always@(posedge clk)
    begin
        if (M_icode == 4'b0100 ) begin
            memory[M_valE] = M_valA;
        end 
        if (M_icode == 4'b1000 ) begin
            memory[M_valE] = M_valA;
        end 
        if (M_icode == 4'b1010 ) begin
            memory[M_valE] = M_valA;
        end 
        
    end

    // writing to pipeline registers;
    always @(posedge clk)
    begin
        W_icode <= M_icode;
        W_stat <= m_stat;
        W_valE <= M_valE;
        W_valM <= m_valM;
        W_dstM <= M_dstM;
        W_dstE <= M_dstE;
    end
endmodule