// // NPC control signal
// `define NPC_PLUS4   2'b00
// `define NPC_BRANCH  2'b01
// `define NPC_JUMP    2'b10
// `define NPC_JALR    2'b11


// Branch
`define BRANCH_PCPLUS4  4'b0000
`define BRANCH_EXCEPTION 4'b0001
`define BRANCH_STALL    4'b0010

`define BRANCH_BEQ      4'b1000
`define BRANCH_BNE      4'b1001
`define BRANCH_BLT      4'b1010
`define BRANCH_BLTU     4'b1011
`define BRANCH_BGE      4'b1100
`define BRANCH_BGEU     4'b1101
`define BRANCH_JAL      4'b1110
`define BRANCH_JALR     4'b1111

// ALU control signal
`define ALU_NOP     4'b0000 
`define ALU_ADD     4'b0001
`define ALU_SUB     4'b0010 
`define ALU_AND     4'b0011
`define ALU_OR      4'b0100
`define ALU_XOR     4'b0101
`define ALU_SLL     4'b0110
`define ALU_SRL     4'b0111 
`define ALU_SRA     4'b1000
`define ALU_SLT     4'b1001
`define ALU_SLTU    4'b1010
`define ALU_LUI     4'b1011
`define ALU_AUIPC   4'b1100


//EXT CTRL itype, stype, btype, utype, jtype
`define EXT_CTRL_ITYPE	5'b10000
`define EXT_CTRL_STYPE	5'b01000
`define EXT_CTRL_BTYPE	5'b00100
`define EXT_CTRL_UTYPE	5'b00010
`define EXT_CTRL_JTYPE	5'b00001
`define EXT_CTRL_SHAMT  5'b10001

// D-Mem L/S
`define MEM_LW      3'b001
`define MEM_LH      3'b010
`define MEM_LHU     3'b011
`define MEM_LB      3'b100
`define MEM_LBU     3'b101

`define MEM_SW      2'b01
`define MEM_SH      2'b10
`define MEM_SB      2'b11

