
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
    
    assign Funct7= instr[31:25];    
    assign rs2   = instr[24:20];
    assign rs1   = instr[19:15];
    assign Funct3= instr[14:12];  
    assign rd    = instr[11:7];
    assign Op    = instr[6:0];  

    wire    IFID_write, IFID_clr;
    // assign  IFID_write = 1'b1;
    assign  IFID_clr = 1'b0;

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

    wire [31:0] IMM;
    immgen  pp_imm(
        .iimm( {Funct7_IFID, rs2_IFID} ),   
        .simm( {Funct7_IFID, rd_IFID} ),   
        .bimm( {Funct7_IFID[6], rd_IFID[0], Funct7_IFID[5:0], rd_IFID[3:0]} ),
        .uimm( {Funct7_IFID, rs2_IFID, rs1_IFID, Funct3_IFID} ),
        .jimm( {Funct7_IFID[6], rs1_IFID, Funct3_IFID, rs2_IFID[0], Funct7_IFID[5:0], rs2_IFID[4:1]} ),
        .shamt( {rs2_IFID} ), 
        // instr does not exist, reconsider it !!!
        .EXTOp(EXTOp),  .immout(IMM)
    );

    wire IDEX_write, IDEX_clr;
    assign IDEX_write = 1'b1;
    // assign IDEX_clr = 1'b0;

    wire load_hazard;
    hazard pp_hazard(MemRead_IDEX, rd_IDEX, rs1_IFID, rs2_IFID, load_hazard);

    assign IDEX_clr = load_hazard;
    assign IFID_write = ~load_hazard;

    pr #(200) IDEX(clk, rst, IDEX_write, IDEX_clr,
        {   rs1_IFID, rs2_IFID, rd_IFID, 
            ALUOp, ALUSrc, RD1, RD2             // used in EX
            MemWrite, MemRead, Branch   // used in MEM
            RegWrite, MemtoReg          // used in WB
        },
        {   rs1_IDEX, rs2_IDEX, rd_IDEX, 
            ALUOp_IDEX, ALUSrc_IDEX, RD1_IDEX, RD2_IDEX
            MemWrite_IDEX, MemRead_IDEX, Branch_IDEX
            RegWrite_IDEX, MemtoReg_IDEX
        }
    );
    

/******** EX ********/ 

    forward pp_forward(rs1_IDEX, rs2_IDEX, rd_EXME, rd_MEWB, 
        RegWrite_EXME, fwdA, fwdB
    );

    wire [1:0]  Bsrc;
    assign      Bsrc = fwdB ? fwdB : ALUSrc;

    wire [31:0]    A, B, C;
    mux3 #(32) ALUSrcA(.d0(RD1_IDEX), .d1(/*mewb*/), .d2(),           .s(fwdA), .y(A));
    mux4 #(32) ALUSrcB(.d0(RD2_IDEX), .d1(), .d2(/*exme*/), .d3(IMM), .s(fwdB), .y(B))

    wire    zero, lt;
    alu     pp_alu(A, B, ALUOp_IDEX, PC/*for auipc, IDEX*/, C, zero, lt);
    assign  aluout = C;

    nextPC  pp_nextPC(PC, Branch, zero, lt, RD1, IMM, NPC);
    
/******** MEM ********/


/******** WB ********/
    



endmodule