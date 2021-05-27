// `include "ctrl_encode_def.v"

module ctrl(
    input  [6:0] Op,       // opcode
    input  [6:0] f7,       // funct7
    input  [2:0] f3,       // funct3
    input        zero,     // alu cmp
    input        lt,

    output       RegWrite, // control signal for register write
    output [1:0] MemWrite,
    output [2:0] MemRead,
    output [1:0] MemtoReg,
    output [4:0] EXTOp,    // control signal to signed extension
    output [3:0] ALUOp,    // ALU opertion
    output [1:0] NPCOp,    // next pc operation
    output [1:0] ALUSrc    // ALU source for B
);

/************ decode ************/

    // funct7/3 
    wire f7_0000000 = ~f7[6]&~f7[5]&~f7[4]&~f7[3]&~f7[2]&~f7[1]&~f7[0];
    wire f7_0100000 = ~f7[6]& f7[5]&~f7[4]&~f7[3]&~f7[2]&~f7[1]&~f7[0];

    wire f3_000 = ~f3[2]&~f3[1]&~f3[0];
    wire f3_001 = ~f3[2]&~f3[1]& f3[0];
    wire f3_010 = ~f3[2]& f3[1]&~f3[0];
    wire f3_011 = ~f3[2]& f3[1]& f3[0];
    wire f3_100 =  f3[2]&~f3[1]&~f3[0];
    wire f3_101 =  f3[2]&~f3[1]& f3[0];
    wire f3_110 =  f3[2]& f3[1]&~f3[0];
    wire f3_111 =  f3[2]& f3[1]& f3[0];
    
    // r format 
    wire rtype  = ~Op[6]& Op[5]& Op[4]&~Op[3]&~Op[2]& Op[1]& Op[0]; 
    wire i_add  = rtype& f7_0000000&  f3_000; 
    wire i_sub  = rtype& f7_0100000&  f3_000; 
    wire i_sll  = rtype& f7_0000000&  f3_001;
    wire i_slt  = rtype& f7_0000000&  f3_010;
    wire i_sltu = rtype& f7_0000000&  f3_011;
    wire i_xor  = rtype& f7_0000000&  f3_100;
    wire i_srl  = rtype& f7_0000000&  f3_101;
    wire i_sra  = rtype& f7_0100000&  f3_101;
    wire i_or   = rtype& f7_0000000&  f3_110; 
    wire i_and  = rtype& f7_0000000&  f3_111; 

    // i format load
    wire ltype  = ~Op[6]&~Op[5]&~Op[4]&~Op[3]&~Op[2]&Op[1]&Op[0]; 
    wire i_lb   = ltype& f3_000;
    wire i_lh   = ltype& f3_001;
    wire i_lw   = ltype& f3_010; 
    wire i_lbu  = ltype& f3_100;
    wire i_lhu  = ltype& f3_101;

    // i format arith & logic
    wire itype  = ~Op[6]&~Op[5]&Op[4]&~Op[3]&~Op[2]&Op[1]&Op[0]; 
    wire i_addi = itype& f3_000;
    wire i_slti = itype& f3_010;
    wire i_sltiu= itype& f3_011;
    wire i_xori = itype& f3_100;
    wire i_ori  = itype& f3_110; 
    wire i_andi = itype& f3_111; 
    wire i_slli = itype& f3_001;
    wire i_srli = itype& f3_101& f7_0000000;
    wire i_srai = itype& f3_101& f7_0100000;
    wire shtype = i_slli | i_srli | i_srai;

    // s format
    wire stype  = ~Op[6]&Op[5]&~Op[4]&~Op[3]&~Op[2]&Op[1]&Op[0];
    wire i_sb   = stype& f3_000;
    wire i_sh   = stype& f3_001;
    wire i_sw   = stype& f3_010; 

    // sb format
    wire sbtype =  Op[6]& Op[5]&~Op[4]&~Op[3]&~Op[2]& Op[1]& Op[0];
    wire i_beq  = sbtype& f3_000; 
    wire i_bne  = sbtype& f3_001;
    wire i_blt  = sbtype& f3_100;
    wire i_bge  = sbtype& f3_101;
    wire i_bltu = sbtype& f3_110;
    wire i_bgeu = sbtype& f3_111; 

    // others
    wire i_jal  =  Op[6]& Op[5]&~Op[4]& Op[3]& Op[2]& Op[1]& Op[0];  
    wire i_jalr =  Op[6]& Op[5]&~Op[4]&~Op[3]& Op[2]& Op[1]& Op[0];
    wire i_lui  = ~Op[6]& Op[5]& Op[4]&~Op[3]& Op[2]& Op[1]& Op[0];  
    wire i_auipc= ~Op[6]&~Op[5]& Op[4]&~Op[3]& Op[2]& Op[1]& Op[0]; 

/************ control ************/

    assign RegWrite   = rtype | ltype |  itype | i_lui | i_auipc | i_jal | i_jalr ;
    // register writeback enable

    assign MemtoReg[0]= ltype ;
    assign MemtoReg[1]= i_jal | i_jalr;
    // register writeback;
    // 01 from D-Mem, 00 from ALUout, 10 from PC (jump-and-link)
    
    assign ALUSrc[0] = ltype | stype | itype | i_lui | i_auipc;  
    assign ALUSrc[1] = 1'b0;
    // 01 from instruction immediate

    assign NPCOp[0] = i_jalr| (i_beq & zero) | (i_bne &~zero) | ((i_blt|i_bltu) & lt) | ((i_bge|i_bgeu) &~lt);
    assign NPCOp[1] = i_jal | i_jalr;
    // branch (NPC);
    // 00 (PC + 4), 01 beq (PC + IMM), 10 jal (IMM), 11 jalr (IMM(rs1))
    
    assign MemWrite[0] = i_sw | i_sb ;
    assign MemWrite[1] = i_sh | i_sb ;
    // D-Mem Write
    // MEM_SW 2'b01
    // MEM_SH 2'b10
    // MEM_SB 2'b11  
    
    assign MemRead[0] = i_lw | i_lhu | i_lbu ;
    assign MemRead[1] = i_lh | i_lhu ;
    assign MemRead[2] = i_lb | i_lbu ;   
    // D-Mem Read   
    // MEM_LW  3'b001
    // MEM_LH  3'b010
    // MEM_LHU 3'b011
    // MEM_LB  3'b100
    // MEM_LBU 3'b101

/************ signed extention ************/

    // EXT_CTRL_ITYPE	5'b10000
    // EXT_CTRL_STYPE	5'b01000
    // EXT_CTRL_BTYPE	5'b00100
    // EXT_CTRL_UTYPE	5'b00010
    // EXT_CTRL_JTYPE	5'b00001
    // EXT_CTRL_SHAMT   5'b10001
    assign EXTOp[4]    = itype | ltype | i_jalr;  
    assign EXTOp[3]    = stype; 
    assign EXTOp[2]    = sbtype; 
    assign EXTOp[1]    = i_lui | i_auipc;   
    assign EXTOp[0]    = i_jal | shtype;         

/************ alu control ************/

    // `define ALU_NOP     4'b0000
    // `define ALU_ADD     4'b0001  
    wire _add = i_add | i_addi | i_lui | i_jalr | ltype | stype;
    // `define ALU_SUB     4'b0010 
    wire _sub = i_sub ;
    // `define ALU_AND     4'b0011
    wire _and = i_and | i_andi;
    // `define ALU_OR      4'b0100
    wire _or  = i_or | i_ori;
    // `define ALU_XOR     4'b0101
    wire _xor = i_xor | i_xori;
    // `define ALU_SLL     4'b0110
    wire _sll = i_sll | i_slli;
    // `define ALU_SRL     4'b0111
    wire _srl = i_srl | i_srli; 
    // `define ALU_SRA     4'b1000
    wire _sra = i_sra | i_srai;
    // `define ALU_SLT     4'b1001
    wire _slt = i_slt | i_slti | i_beq | i_bne | i_bge | i_blt;
    // `define ALU_SLTU    4'b1010
    wire _sltu= i_sltu | i_sltiu | i_bgeu | i_bltu;
    // `define ALU_LUI     4'b1011
    wire _lui = i_lui;
    // `define ALU_AUIPC   4'b1100
    wire _auipc = i_auipc;

    assign ALUOp[0] = _add | _and | _xor | _srl | _slt | _lui;
    assign ALUOp[1] = _sub | _and | _sll | _srl | _sltu| _lui;
    assign ALUOp[2] = _or  | _xor | _sll | _srl | _auipc;
    assign ALUOp[3] = _sra | _slt | _sltu| _lui | _auipc;

endmodule
