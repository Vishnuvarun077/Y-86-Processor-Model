module fetch (
    input clk,
    input [63:0] PC,
    output reg [3:0] icode,
    output reg [3:0] ifun,
    output reg [3:0] rA,
    output reg [3:0] rB,
    output reg [63:0] valC,
    output reg [63:0] valP,
    output reg instruction_valid,
    output reg imem_error,
    output reg halt
);


reg [7:0] instruction_memory[0:1023]; // 1kb instruction_memory
reg [0:79] instr; 

always @(posedge clk) begin
    //Reading first 10 bytes from PC 
    instr[0:7] = instruction_memory[PC];
    instr[8:15] = instruction_memory[PC+1];
    instr[16:23] = instruction_memory[PC+2];
    instr[24:31] = instruction_memory[PC+3];
    instr[32:39] = instruction_memory[PC+4];
    instr[40:47] = instruction_memory[PC+5];
    instr[48:55] = instruction_memory[PC+6];
    instr[56:63] = instruction_memory[PC+7];
    instr[64:71] = instruction_memory[PC+8];
    instr[72:79]  = instruction_memory[PC+9];
      
    // Imem_error
    imem_error = 0;
    if (PC > 1023) begin 
        imem_error = 1;
    end

    // Split
    icode = instr[0:3];
    ifun = instr[4:7];
    halt = 1'h0;
    // Align
    if (icode == 4'h0) begin
        rA <= 4'b1111;
        rB <= 4'b1111;
        valC <= 64'b0;
        instruction_valid <= 1'h1; 
        valP<=PC+64'h1;
        halt <= 1'h1;

    end
    else if (icode == 4'h1) begin
        // rA = 4'b1111;
        // rB = 4'b1111;
        valC = 64'b0;
        instruction_valid = 1'b1;
        valP=PC+64'h1;
    end
    else if (icode == 4'h2) begin
        if (ifun >= 4'h0 && ifun < 4'h7) begin
            rA = instr[8:11];
            rB = instr[12:15];
            valC = 64'b0;
            instruction_valid = 1'b1;
            valP=PC+64'h2;
        end
        else begin
            instruction_valid = 1'b0;
            valP=PC+64'h2;
        end
    end
    else if (icode == 4'h3 || icode == 4'h4 || icode == 4'h5) begin
        rA = instr[8:11];
        rB = instr[12:15];
        valC = instr[16:79];
        instruction_valid = 1'b1;
        valP=PC+64'd10;
    end
    else if (icode == 4'h6) begin
        if (ifun >= 4'h0 && ifun < 4'h4) begin
            rA = instr[8:11];
            rB = instr[12:15];
            valC = 64'b0;
            instruction_valid = 1'b1;
            valP=PC+64'h2;
        end
        else begin
            instruction_valid = 1'b0;
            valP=PC+64'h2;
        end
    end
    else if (icode == 4'h7) begin
        if (ifun >= 4'h0 && ifun < 4'h7) begin
            rA = 4'b1111;
            rB = 4'b1111;
            valC = instr[16:79];
            instruction_valid = 1'b1;
            valP=PC+64'h9;
        end
        else begin
            instruction_valid = 1'b1;
            valP=PC+64'h9;
        end
    end
    else if (icode == 4'h8) begin
        rA = 4'b1111;
        rB = 4'b1111;
        valC = instr[16:79];
        instruction_valid = 1'b1;
        valP=PC+64'h9;
    end
    else if (icode == 4'h9) begin
        rA = 4'b1111;
        rB = 4'b1111;
        valC = 64'b0;
        instruction_valid = 1'b1; 
        valP=PC+64'h1;
    end
    else if (icode == 4'ha || icode == 4'hb) begin
        rA = instr[8:11];
        rB = instr[12:15];
        valC = 64'b0;
        instruction_valid = 1'b1;
        valP=PC+64'h2;
    end
    else begin
        instruction_valid = 1'b0;
    end


end

initial begin
//cmovxx
instruction_memory[0]=8'h20; //2 fn (Conditional Move instruction)
instruction_memory[1]=8'h13; //rA rB

//irmovq
instruction_memory[2]=8'h30; //3 0 (Immediate Load instruction)
instruction_memory[3]=8'h02; //F rB
instruction_memory[4]=8'h00; //V
instruction_memory[5]=8'h00; //V
instruction_memory[6]=8'h00; //V
instruction_memory[7]=8'h00; //V
instruction_memory[8]=8'h00; //V
instruction_memory[9]=8'h00; //V
instruction_memory[10]=8'h00; //V
instruction_memory[11]=8'h10; //V=16

//rmmovq
instruction_memory[12]=8'h40; //4 0 (Register to Memory Move instruction)
instruction_memory[13]=8'h52; //rA rB
instruction_memory[14]=8'h00; //D
instruction_memory[15]=8'h00; //D
instruction_memory[16]=8'h00; //D
instruction_memory[17]=8'h00; //D
instruction_memory[18]=8'h00; //D
instruction_memory[19]=8'h00; //D
instruction_memory[20]=8'h00; //D
instruction_memory[21]=8'h01; //D

//mrmovq
instruction_memory[22]=8'h50; //5 0 (Memory to Register Move instruction)
instruction_memory[23]=8'h72; //rA rB
instruction_memory[24]=8'h00; //D
instruction_memory[25]=8'h00; //D
instruction_memory[26]=8'h00; //D
instruction_memory[27]=8'h00; //D
instruction_memory[28]=8'h00; //D
instruction_memory[29]=8'h00; //D
instruction_memory[30]=8'h00; //D
instruction_memory[31]=8'h01; //D

//halt
instruction_memory[32]=8'h00; // 0 0 (Halt instruction)

//addq
instruction_memory[33]=8'h60; //6 fn (Add instruction)
instruction_memory[34]=8'h23; //rA rB

//subq
instruction_memory[35]=8'h61; //6 fn (Subtract instruction)
instruction_memory[36]=8'h23; //rA rB

//xorq
instruction_memory[37]=8'h63; //6 fn (XOR instruction)
instruction_memory[38]=8'h23; //rA rB

//andq
instruction_memory[39]=8'h62; //6 fn (AND instruction)
instruction_memory[40]=8'h23; //rA rB

//cmovxx
instruction_memory[41]=8'h20; //2 fn (Conditional Move instruction)
instruction_memory[42]=8'h04; //rA rB

instruction_memory[43]=8'h10; // 1 0
instruction_memory[44]=8'h10; // 1 0
instruction_memory[45]=8'h10; // 1 0
instruction_memory[46]=8'h10; // 1 0
instruction_memory[47]=8'h10; // 1 0
instruction_memory[48]=8'h10; // 1 0

//halt
instruction_memory[49]=8'h00; // 0 0

instruction_memory[50]=8'h10; // 1 0

//halt
instruction_memory[51]=8'h00; // 0 0

//cmovxx
instruction_memory[52]=8'h25; //2 fn (Conditional Move instruction)
instruction_memory[53]=8'h04; //rA rB

//jxx
instruction_memory[54]=8'h70; //7 fn (Jump instruction)
instruction_memory[55]=8'h00; //Dest
instruction_memory[56]=8'h00; //Dest
instruction_memory[57]=8'h00; //Dest
instruction_memory[58]=8'h00; //Dest
instruction_memory[59]=8'h00; //Dest
instruction_memory[60]=8'h00; //Dest
instruction_memory[61]=8'h00; //Dest
instruction_memory[62]=8'h20; //Dest

instruction_memory[63]=8'h10; //1 0

//call
instruction_memory[64]=8'h80; //8 0 (Call subroutine instruction)
instruction_memory[65]=8'h00; //Dest
instruction_memory[66]=8'h00; //Dest
instruction_memory[67]=8'h00; //Dest
instruction_memory[68]=8'h00; //Dest
instruction_memory[69]=8'h00; //Dest
instruction_memory[70]=8'h00; //Dest
instruction_memory[71]=8'h00; //Dest
instruction_memory[72]=8'h01; //Dest

//ret
instruction_memory[73]=8'h90; // 9 0 (Return from subroutine instruction)

//halt
instruction_memory[74]=8'h00; // 0 0

//pushq
instruction_memory[75]=8'hA0; //A 0 (Push instruction)
instruction_memory[76]=8'h00; //rA F

//popq
instruction_memory[77]=8'hB0; //B 0 (Pop instruction)
instruction_memory[78]=8'h00; //rA F

//nop
instruction_memory[79]=8'h10; //1 0 (No operation instruction)

//halt 
instruction_memory[80]=8'h00; // 0 0


// //irmovq $0x100, %rbx
//     instruction_memory[0] = 8'b00110000;
//     instruction_memory[1] = 8'b00000011;
//     instruction_memory[2] = 8'b00000000;
//     instruction_memory[3] = 8'b00000001;
//     instruction_memory[4] = 8'b00000000;
//     instruction_memory[5] = 8'b00000000;
//     instruction_memory[6] = 8'b00000000;
//     instruction_memory[7] = 8'b00000000;
//     instruction_memory[8] = 8'b00000000;
//     instruction_memory[9] = 8'b11110011;
    
//     // irmovq $0x200, %rdx
//     instruction_memory[10] = 8'b00110000;
//     instruction_memory[11] = 8'b00000010;
//     instruction_memory[12] = 8'b00000000;
//     instruction_memory[13] = 8'b00000010;
//     instruction_memory[14] = 8'b00000000;
//     instruction_memory[15] = 8'b00000000;
//     instruction_memory[16] = 8'b00000000;
//     instruction_memory[17] = 8'b00000000;
//     instruction_memory[18] = 8'b00000000;
//     instruction_memory[19] = 8'b11110010;
    
//     // addq %rdx, %rbx
//     instruction_memory[20] = 8'b01100000;
//     instruction_memory[21] = 8'b00100011;
//     instruction_memory[22] = 8'b00000000;
//     instruction_memory[23] = 8'b00000000;
//     instruction_memory[24] = 8'b00000000;
//     instruction_memory[25] = 8'b00000000;
//     instruction_memory[26] = 8'b00000000;
//     instruction_memory[27] = 8'b00000000;
//     instruction_memory[28] = 8'b00000000;
//     instruction_memory[29] = 8'b00000000;
// instruction_memory[30]=8'h00; // 0 0
end


endmodule
