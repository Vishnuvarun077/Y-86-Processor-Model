module tb_pc_update();

reg [3:0]icode;
reg cnd;
reg [63:0] valC,valM,valP;
reg clk;

wire [63:0]PC;

pc_update tb_pc_update(PC, icode, cnd, valC, valM, valP, clk);

initial
    begin
        $dumpfile("pc_update.vcd");
        $dumpvars(0,tb_pc_update);
        $monitor("time=%0t , PC=%d , icode=%d , ifun=%d , valC=%d , valM=%d , valP=%d", $time,PC,icode,cnd,valC,valM,valP);
        #5
        clk=0;       #5
        clk=~clk; icode=4'h8; cnd=0; valC=5; valM=6; valP=7;  #5
        clk=~clk;   #5
        clk=~clk; icode=4'h7; cnd=0;  #5
        clk=~clk;    #5
        clk=~clk; icode=4'h7; cnd=1;  #5
        clk=~clk;  #5
        clk=~clk; icode=4'h9; #5
        clk=~clk;  #5
        clk=~clk; icode=4'h8; cnd=0; valC=4; valM=6; valP=8;  #5
        clk=~clk;   #5
        clk=~clk; icode=4'h7; cnd=1;  #5
        clk=~clk;    #5
        clk=~clk; icode=4'h7; cnd=0;  #5
        clk=~clk;  #5
        clk=~clk; icode=4'h9; #5
        
        $finish;
    end
endmodule