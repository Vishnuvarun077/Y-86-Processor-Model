module controllogic(
    input [3:0] decode_icode,
    input [3:0] decode_srcA, decode_srcB,
    input [3:0] Execute_icode, Execute_dstM,
    input execute_cnd,
    input [3:0] Memory_icode,
    input [3:0] memory_stat,
    input [3:0] Write_stat,
    output reg E_bubble,
    output reg D_bubble, D_stall,
    output reg F_stall
);

always @(*) begin
    F_stall = (decode_icode == 4'b1001 || Execute_icode == 4'b1001 || Memory_icode == 4'b1001) ? 1'b1 : // ret
              ((Execute_icode == 4'b0101 || Execute_icode == 4'b1011) && (Execute_dstM == decode_srcA || Execute_dstM == decode_srcB)) ? 1'b1 : // load-use hazard
              1'b0; // Default case

    D_bubble = (decode_icode == 4'b1001 || Execute_icode == 4'b1001 || Memory_icode == 4'b1001) && (!((Execute_icode == 4'b0101 || Execute_icode == 4'b1011) && (Execute_dstM == decode_srcA || Execute_dstM == decode_srcB)))? 1'b1 : // ret && !Load Use Hazard
                (Execute_icode == 4'b0111 && !execute_cnd) ? 1'b1 :  // Jump misprediction
                 1'b0;

    D_stall = ((Execute_icode == 4'b0101 || Execute_icode == 4'b1011) && (Execute_dstM == decode_srcA || Execute_dstM == decode_srcB)) ? 1'b1 :  // load-use hazard
               1'b0;

    E_bubble = ((Execute_icode == 4'b0101 || Execute_icode == 4'b1011) && (Execute_dstM == decode_srcA || Execute_dstM == decode_srcB)) ? 1'b1 :  // load-use hazard
               (Execute_icode == 4'b0111 && !execute_cnd) ? 1'b1 : //Jump misprediction
               1'b0;
end


endmodule