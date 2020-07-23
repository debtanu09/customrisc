/*
MIT License

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
SOFTWARE.
*/

`include "define.v"
module mux8(inp0, inp1, inp2, inp3, inp4, inp5, inp6, inp7, sel, outp);
	parameter muxsize = `datasize;
	input [muxsize-1:0] inp0, inp1, inp2, inp3, inp4, inp5, inp6, inp7;
	input [2:0] sel;
	output [muxsize-1:0] outp;
	
	assign outp = (sel == 3'b000) ? inp0 : {muxsize{1'bz}};
	assign outp = (sel == 3'b001) ? inp1 : {muxsize{1'bz}};
	assign outp = (sel == 3'b010) ? inp2 : {muxsize{1'bz}};
	assign outp = (sel == 3'b011) ? inp3 : {muxsize{1'bz}};
	assign outp = (sel == 3'b100) ? inp4 : {muxsize{1'bz}};
	assign outp = (sel == 3'b101) ? inp5 : {muxsize{1'bz}};
	assign outp = (sel == 3'b110) ? inp6 : {muxsize{1'bz}};
	assign outp = (sel == 3'b111) ? inp7 : {muxsize{1'bz}};
endmodule
