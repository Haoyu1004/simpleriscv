
module sccpu( clk, rst, instr, readdata, PC, MemWrite, MemRead, 
                aluout, writedata, reg_sel, reg_data
            );
/*********** Interface to Mem (L1 Cache) ****************************/         
    input           clk;       // clock
    input           rst;       // reset
    input [31:0]    instr;     // instruction
    output [31:0]   PC;        // PC address

    output [1:0]    MemWrite;  // D-mem write enable
    output [2:0]    MemRead;   // D-mem read enable
    output [31:0]   writedata; // data to D-mem
    input  [31:0]   readdata;  // data from D-mem

    output [31:0]   aluout;    // ALU output

    input  [4:0]    reg_sel;   // register selection (for debug use)
    output [31:0]   reg_data;  // selected register data (for debug use)

/* IF */
    wire [6:0]      Op;          // instruction decode
    wire [6:0]      Funct7;      
    wire [2:0]      Funct3;      
    wire [4:0]      rs1, rs2, rd;
    wire [31:0]     NPC;    
    wire [31:0]     PCPLUS4;        // for jal/jalr save 
/* ctrl */  
    wire            RegWrite;    // control signal 
    wire [1:0]      MemtoReg;
    wire [4:0]      EXTOp;       
    wire [3:0]      ALUOp;       
    wire [1:0]      NPCOp;       
    wire [1:0]      ALUSrc;      
/* RF */
    wire [31:0]     WD, RD1, RD2;// register write data
/* alu */
    wire [31:0]     A, B;        // operator for ALU B
    wire            zero;        // ALU compare result
    wire            lt; 
/* EXT */
    wire [31:0]     Imm32;       // sign extend result
 
/************ Instruction Fetch ************/

    PC sc_PC(
        .clk(clk),  .rst(rst),  .NPC(NPC),  .PC(PC)
    );
    NPC sc_NPC(
        .PC(PC), .NPCOp(NPCOp), .IMM(Imm32), .RD1(RD1), .NPC(NPC)  
    );

/************ Instruction Decode ************/

    assign Op = instr[6:0];          // instruction
    assign Funct7 = instr[31:25];    // funct7
    assign Funct3 = instr[14:12];    // funct3

    ctrl sc_ctrl(
        .Op(Op),        .f7(Funct7),    .f3(Funct3),     
        .ALUSrc(ALUSrc),.zero(zero),    .lt(lt),
        .RegWrite(RegWrite),            .MemtoReg(MemtoReg),    
        .MemWrite(MemWrite),            .MemRead(MemRead),
        .EXTOp(EXTOp),  .ALUOp(ALUOp),  .NPCOp(NPCOp)
    );

    assign rs1 = instr[19:15];
    assign rs2 = instr[24:20];
    assign rd  = instr[11:7];

    RF U_RF(
        .clk(clk),  .rst(rst),  .RFWr(RegWrite),
        .A1(rs1),   .A2(rs2),   .A3(rd),
        .RD1(RD1),  .RD2(RD2),  .WD(WD),
        .reg_sel(reg_sel),      .reg_data(reg_data)
    );

    EXT sc_ext(
        .iimm( {instr[31:20]} ),   
        .simm( {instr[31:25], instr[11:7]} ),   
        .bimm( {instr[31], instr[7], instr[30:25], instr[11:8]} ),
        .uimm( {instr[31:12]} ),
        .jimm( {instr[31], instr[19:12], instr[20], instr[30:21]} ),
        .shamt( {rs2} ),
        .EXTOp(EXTOp),  .immout(Imm32)
    );
    
/************ Execute ************/

    assign A = RD1;

    mux3 #(32) sc_aluBsrc(
        .d0(RD2), .d1(Imm32),  .d2(rs2),
        .s(ALUSrc), .y(B)
    );

    alu sc_alu(
        .A(A),  .B(B),  .ALUOp(ALUOp),  .PC(PC),    //.shamt(rs2),
        .C(aluout),     .zero(zero),    .lt(lt)
    );

/************ Memory Access ************/

    assign writedata = RD2;

/************ Writeback  ************/
    
    assign PCPLUS4 = PC + 4;
    mux3 #(32) sc_mem2reg(
        .d0(aluout), .d1(readdata), .d2(PCPLUS4),
        .s(MemtoReg), .y(WD)
    );


endmodule