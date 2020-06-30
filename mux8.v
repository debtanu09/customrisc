/*MIT License

Copyright (c) 2020 Debtanu Mukherjee

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.*/

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
