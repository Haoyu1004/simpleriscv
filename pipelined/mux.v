
module mux2 #(parameter WIDTH = 8)
             (input  [WIDTH-1:0] d0, d1, 
              input              s, 
              output [WIDTH-1:0] y);
    assign y = s ? d1 : d0; 
endmodule

module mux3 #(parameter WIDTH = 8)
             (input  [WIDTH-1:0] d0, d1, d2,
              input  [1:0]       s, 
              output [WIDTH-1:0] y);
    assign  y = s[1] ? d2 : (s[0] ? d1 : d0); 
endmodule

module mux4 #(parameter WIDTH = 8)
             (input  [WIDTH-1:0] d0, d1, d2, d3,
              input  [1:0]       s, 
              output reg [WIDTH-1:0] y);
	always @( * )
	begin
        case(s)
            2'b00: y <= d0;
            2'b01: y <= d1;
            2'b10: y <= d2;
            2'b11: y <= d3;
        endcase
	end
endmodule

module mux5 #(parameter WIDTH = 8)
             (input		[WIDTH-1:0] d0, d1, d2, d3, d4,
              input		[2:0]       s, 
              output reg	[WIDTH-1:0] y);
	always @( * )
	begin
        case(s)
            3'b000: y <= d0;
            3'b001: y <= d1;
            3'b010: y <= d2;
            3'b011: y <= d3;
            3'b100: y <= d4;
        endcase
    end  
endmodule

module mux6 #(parameter WIDTH = 8)
           (input  [WIDTH-1:0] 	d0, d1, d2, d3, d4, d5,
            input  [2:0] 		s,
            output reg [WIDTH-1:0]	y);
    always@( * )
    begin
        case(s)
            3'b000: y <= d0;
            3'b001: y <= d1;
            3'b010: y <= d2;
            3'b011: y <= d3;
            3'b100: y <= d4;
            3'b101: y <= d5;
        endcase
    end
endmodule