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
module mux4(inp0, inp1, inp2, inp3, sel, outp);
	parameter muxsize = `datasize;
	input [muxsize-1:0] inp0, inp1, inp2, inp3;
	input [1:0] sel;
	output [muxsize-1:0] outp;
	
	assign outp = (sel == 2'b00) ? inp0 : {muxsize{1'bz}};
	assign outp = (sel == 2'b01) ? inp1 : {muxsize{1'bz}};
	assign outp = (sel == 2'b10) ? inp2 : {muxsize{1'bz}};
	assign outp = (sel == 2'b11) ? inp3 : {muxsize{1'bz}};
endmodule
