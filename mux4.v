module mux4(in0, in1, in2, in3, sel, out);
parameter size = 16;

input [size-1:0] in0, in1, in2, in3;
input [1:0] sel;
output [size-1:0] out;

assign out = (sel == 2'b00) ? in0 : 16'bz;
assign out = (sel == 2'b01) ? in1 : 16'bz;
assign out = (sel == 2'b10) ? in2 : 16'bz;
assign out = (sel == 2'b11) ? in3 : 16'bz;

endmodule
