
module ppcpu(
    input           clk, rst, 
    input  [31:0]   instr, 
    
    input  [31:0]   ReadData, 
    output [2:0]    MemRead,        // D-Mem read type 
    output [1:0]    MemWrite,       // D-Mem write type
    output [31:0]   WriteData,      
    output [31:0]   aluout,         // D-Mem R/W address

    input           reg_sel, 
    input  [31:0]   reg_data        // (for dubug watch)
);

/*
        Signals with prefix 'AB' are pipeline registers control signals.

        Signals without suffix are generated in the current cycle.

        Signals with suffix 'AB' are stored in 'AB' pipeline registers, and 
    is read, used and deleted in the B cycle.

*/


/******** IF ********/
    PC      pp_PC(clk, rst, NPC, PC);
    nextPC  pp_nextPC(PC, Branch, zero, lt, RD1, IMM, NPC);


    assign Funct7= instr[31:25];    
    assign rs2   = instr[24:20];
    assign rs1   = instr[19:15];
    assign Funct3= instr[14:12];  
    assign rd    = instr[11:7];
    assign Op    = instr[6:0];  

    wire    IFID_write;
    wire    IFID_clr;

    pr #(32)    IFID(clk, rst, IFID_write, IFID_clr,
        {Funct7,      rs2,      rs1,      Funct3,      rd,      op     },
        {Funct7_IFID, rs2_IFID, rs1_IFID, Funct3_IFID, rd_IFID, op_IFID}
    );

/******** ID ********/
    ctrl    pp_ctrl(op_IFID, Funct7_IFID, Funct3_IFID, 
        EXTOp, ALUOp, ALUSrc, MemWrite, MemRead, Branch, RegWrite, MemtoReg
    );
    rf      pp_rf(clk, rst, 
        RegWrite_MEMWB, rs1_IFID, rs2_IFID, rd_IFID, 
        WD, RD1, RD2, reg_sel, reg_data
    );

    immgen  pp_imm(
        .iimm( {instr[31:20]} ),   
        .simm( {instr[31:25], instr[11:7]} ),   
        .bimm( {instr[31], instr[7], instr[30:25], instr[11:8]} ),
        .uimm( {instr[31:12]} ),
        .jimm( {instr[31], instr[19:12], instr[20], instr[30:21]} ),
        .shamt( {rs2} ), 
        // reconsider it !!!
        .EXTOp(EXTOp),  .immout(IMM)
    );

    pr #() IDME(clk, rst, IDME_write, IDME_clr,
        {   rs1_IFID, rs2_IFID, rd_IFID, 
            ALUOp, ALUSrc,              // used in EX
            MemWrite, MemRead, Branch   // used in MEM
            RegWrite, MemtoReg          // used in WB
        },
        {   rs1_IDME, rs2_IDME, rd_IDME, 
            ALUOp_IDME, ALUSrc_IDME, 
            MemWrite_IDME, MemRead_IDME, Branch_IDME
            RegWrite_IDME, MemtoReg_IDME
        }
    );
    

/******** EX ********/ 
    alu     pp_alu();
    
/******** MEM ********/


/******** WB ********/
    



endmodule