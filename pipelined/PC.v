module PC( clk, rst, NPC, PC );

    input              clk;
    input              rst;
    input       [31:0] NPC;
    output reg  [31:0] PC;

    always @(posedge clk, posedge rst)
    if (rst) 
        PC <= 32'h00000000;
    else
        PC <= NPC;
      
endmodule

