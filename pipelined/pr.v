
module pr #(parameter WIDTH)(
    input clk, rst, write, clear,
    input [0:WIDTH-1]       in,
    output reg [0:WIDTH-1]  out
);
    always@ (posedge clk) begin
        if(write) begin
            out = clear ? 0 : in;
        end
    end

    always@ (posedge rst) begin
        out = 0;
    end

endmodule