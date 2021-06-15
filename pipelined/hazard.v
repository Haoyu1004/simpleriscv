
module hazard(
    // check in ID stage after decode 
    input [2:0] MemRead_IDEX,
    input       rd_IDEX,
    input       rs1_IFID, rs2_IFID,
    output      load_hazard
);

    assign load_hazard = 
        (MemRead_IDEX) && (rd_IDEX==rs1_IFID || rd_IDEX==rs2_IFID);

endmodule