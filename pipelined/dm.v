
`include "ctrl_encode_def.v"

module dm(clk, MemWrite, MemRead, addr, din, dout);
    input           clk;
    input  [1:0]    MemWrite;
    input  [2:0]    MemRead;

    input  [31:0]   addr;
    input  [31:0]   din;
    output reg [31:0]   dout;
        
    reg [7:0]       dmem[1023:0]; /* 1KB D-Mem */

    always @( * ) begin
//  MEM_LW  3'b001
//  MEM_LH  3'b010
//  MEM_LHU 3'b011
//  MEM_LB  3'b100
//  MEM_LBU 3'b101
        case(MemRead) 
            `MEM_LW:     assign dout = {dmem[addr+3], dmem[addr+2], dmem[addr+1], dmem[addr]};
            `MEM_LH:     assign dout = {{ {32-16}{dmem[addr+1][7]} }, dmem[addr+1], dmem[addr]};
            `MEM_LHU:    assign dout = {16'b0, dmem[addr+1], dmem[addr]};
            `MEM_LB:     assign dout = {{{32-8}{dmem[addr][7]}}, dmem[addr]};
            `MEM_LBU:    assign dout = {24'b0, dmem[addr]};
            default:     assign dout = 32'hxxxxxxxx;
        endcase
    end

    always @(negedge clk) begin
//  MEM_SW 2'b01
//  MEM_SH 2'b10
//  MEM_SB 2'b11
        case(MemWrite)
            `MEM_SW:
                begin
                    dmem[addr] <= din[7:0];      
                    dmem[addr+1] <= din[15:8]; 
                    dmem[addr+2] <= din[23:16];  
                    dmem[addr+3] <= din[31:24];
                end
            `MEM_SH: 
                begin
                    dmem[addr] <= din[7:0];      
                    dmem[addr+1] <= din[15:8]; 
                end
            `MEM_SB:
                dmem[addr] <= din[7:0];
            default:
                begin
                end
        endcase
    end

endmodule    
