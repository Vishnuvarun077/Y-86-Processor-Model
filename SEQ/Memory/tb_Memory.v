module tb_Memory();

reg imem_error,instr_valid;
reg [3:0]icode;
reg signed [63:0]valE,valA,valP;

wire signed [63:0]valM;
Memory tb_Memory(valM,icode,valE,valA,valP,instr_valid,imem_error);
initial
begin
    $dumpfile("Memory.vcd");
    $dumpvars(0,tb_Memory);
    $monitor("time =%0t ,\nvalE   = %d ,\nvalA   = %d ,\nvalP   = %d ,\nicode = %b ,\nvalM   = %d\n",$time,valE,valA,valP,icode,valM);

    #5 icode=4'h4;  valE=64'd100;   valA=64'd49;    valP=64'd87;    imem_error=1'b0;    instr_valid=1'b1;
    #5 icode=4'h5;  valE=64'd100;   
    #5 icode=4'h4;  valE=64'd200;   valA=64'd109;
    #5 icode=4'h5;  valE=64'd200;
    #5 icode=4'h4;  valE=64'd250;   valA=-64'd49;
    #5 icode=4'h5;  valE=64'd250;
    #5 icode=4'h4;  valE=64'd100;   valA=64'd99;
    #5 icode=4'h5;  valE=64'd100;
    #5 icode=4'h8;  valE=64'd82 ;   valA=64'd99;
    #5 icode=4'hb;  valE=64'd99 ;   valA=64'd82;
    #5 icode=4'h9;  valE=64'd82 ;   valA=64'd99;

    $finish;
end
endmodule
    
