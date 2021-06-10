
`include "ctrl_encode_def.v"

module nextPC(  // next pc module
    
    input  [31:0]       PC,        // pc
    input  [3:0]        Branch, 
    input               zero, lt

    input  [31:0]       RD1,       // (rs1)   
    input  [31:0]       IMM,       // immediate
    
    output reg [31:0]   NPC        // next pc
);

    always @(*) begin
        case (Branch)
            `BRANCH_PCPLUS4:    NPC = PC + 4;
            `BRANCH_BEQ:        NPC = (zero) ? PC + IMM : PC + 4;
            `BRANCH_BNE:        NPC = (~zero) ? PC + IMM : PC + 4;
            `BRANCH_BLT:        NPC = (lt) ? PC + IMM : PC + 4;
            `BRANCH_BLTU:       NPC = (lt) ? PC + IMM : PC + 4;
            `BRANCH_BGE:        NPC = (~lt) ? PC + IMM : PC + 4;
            `BRANCH_BGEU:       NPC = (~lt) ? PC + IMM : PC + 4;
            `BRANCH_JAL:        NPC = PC + IMM;
            `BRANCH_JALR:       NPC = IMM + RD1;
            default:            NPC = PC + 4;

        endcase
    end 

endmodule
