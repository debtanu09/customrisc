module mux8(in0, in1, in2, in3, in4, in5, in6, in7, sel, out);
parameter size = 16;

input [size-1:0] in0, in1, in2, in3, in4, in5, in6, in7;
input [2:0] sel;
output [size-1:0] out;

assign out = (sel == 3'b000) ? in0 : 16'bz;
assign out = (sel == 3'b001) ? in1 : 16'bz;
assign out = (sel == 3'b010) ? in2 : 16'bz;
assign out = (sel == 3'b011) ? in3 : 16'bz;
assign out = (sel == 3'b100) ? in4 : 16'bz;
assign out = (sel == 3'b101) ? in5 : 16'bz;
assign out = (sel == 3'b110) ? in6 : 16'bz;
assign out = (sel == 3'b111) ? in7 : 16'bz;

endmodule
