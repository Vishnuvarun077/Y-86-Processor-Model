module pc_update(updated_pc, icode, cnd, valC, valM, valP, clk);

input [3:0] icode;
input cnd;
input signed [63:0] valC,valM,valP;
input clk;
output reg [63:0]updated_pc;



always @(*) begin
    case (icode)
        4'b0111: // jxx
            begin
                if (cnd)
                    updated_pc = valC;
                else
                    updated_pc = valP;
            end
        4'b1000: // call
            updated_pc = valC;
        4'b1001: // ret
            updated_pc = valM;
        default: // all other cases
            updated_pc = valP;
    endcase
end


endmodule