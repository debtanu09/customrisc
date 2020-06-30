module mux2(in0, in1, sel, out);
parameter size = 16;
input [size-1:0] in0, in1;
input  sel;
output [size-1:0] out;

assign out = (sel) ? in1 : in0;

endmodule
