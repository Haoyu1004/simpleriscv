`include "ctrl_encode_def.v"

module NPC(  // next pc module
    
    input  [31:0]       PC,        // pc
    input  [1:0]        NPCOp,     // next pc operation
    input  [31:0]       RD1,       // (rs1)   
    input  [31:0]       IMM,       // immediate
    output reg [31:0]   NPC        // next pc
);

    always @(*) begin
        case (NPCOp)
            `NPC_PLUS4:  NPC = PC + 4;
            `NPC_BRANCH: NPC = PC + IMM;
            `NPC_JUMP:   NPC = PC + IMM;
            `NPC_JALR:   NPC = IMM + RD1;
            default:     NPC = PC + 4;
        endcase
    end // end always
    
endmodule
