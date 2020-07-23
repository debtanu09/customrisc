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

module regfile(clk, rst, wr, o_addr1, o_addr2, i_addr, o_data1, o_data2, i_data, pc);

input clk, rst, wr;
input [`regfileaddrsize-1:0] o_addr1, o_addr2, i_addr;
input [`datasize-1:0] i_data;
output [`datasize-1:0] o_data1, o_data2, pc;

reg [`datasize-1:0] rfile [`regfilesize-1:0];


integer i;

always @(posedge clk or rst) begin
	if(rst) begin
		for(i=0;i<`regfilesize;i=i+1)
			rfile[i] = 0;	
	end
	else if(wr)
		rfile[i_addr] = i_data;
		
end

assign o_data1 = rfile[o_addr1];
assign o_data2 = rfile[o_addr2];

assign pc = rfile[`pcaddr];

endmodule
