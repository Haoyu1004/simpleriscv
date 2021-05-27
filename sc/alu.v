
`include "ctrl_encode_def.v"

module alu(A, B, ALUOp, PC, C, zero, lt, ltu);
           
    input  signed [31:0] A, B;
    // input         [4:0]  shamt;
    input         [3:0]  ALUOp;
    input         [31:0] PC;
    output signed [31:0] C;
    output               zero;
    output               lt;
    output               ltu;

    reg [31:0] C;
    integer    i;
        
    always @( * ) begin
        case ( ALUOp )
            `ALU_NOP  : C = A; 
            `ALU_ADD  : C = A + B; 
            `ALU_SUB  : C = A - B; 
            `ALU_AND  : C = A & B;
            `ALU_OR   : C = A | B;
            `ALU_XOR  : C = A ^ B;
            `ALU_SLL  : C = A << B;
            `ALU_SRL  : C = A >> B; 
            `ALU_SRA  : C = A >>>B;
            `ALU_SLT  : C = (A < B) ? 1 : 0;
            `ALU_SLTU : C = ($unsigned(A) < $unsigned(B)) ? 1 : 0;
            `ALU_LUI  : C = B;
            `ALU_AUIPC: C = B + PC; 
            default:    C = A; 
        endcase
    end // end always

    assign zero = (C == 32'b0);
    assign lt = C[0];  // use slt, sltu to compare, not sub

endmodule
    
