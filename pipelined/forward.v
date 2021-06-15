
module forward( 
    // check in EX stage, output to ALU MUX

    input rs1_IDEX, rs2_IDEX,
    input rd_EXME, rd_MEWB,
    input RegWrite_EXME, RegWrite_MEWB,

    output [1:0] fwdA,
    output [1:0] fwdB   
    // 00 from ID, 10 from EX, 01 from MEM, 11 from ImmGen (B only)
);

    if(RegWrite_EXME && rd_EXME && rd_EXME==rs1_IDEX) begin 
        fwdA = 2'b10; // A-EX
    end else if (RegWrite_MEWB && rd_MEWB && rd_MEWB==rs1_IDEX) begin
        fwdA = 2'b01; // A-MEM
    end else begin
        fwdA = 2'b00;
    end

    if(RegWrite_EXME && rd_EXME && rd_EXME==rs2_IDEX) begin 
        fwdB = 2'b10; // B-EX
    end else if (RegWrite_MEWB && rd_MEWB && rd_MEWB==rs2_IDEX) begin
        fwdB = 2'b01; // B-MEM
    end else begin
        fwdB = 2'b00;
    end



endmodule