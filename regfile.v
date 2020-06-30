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

module regfile(clk, rst, regen, outaddr1, outaddr2, out1, out2, inaddr, in, pcout);
	
	input clk, rst, regen;
	input [2:0] outaddr1, outaddr2, inaddr;
	input [15:0] in;
	output [15:0] out1, out2, pcout;
	
	reg [15:0] memory [0:7];
	
	always @(posedge clk) begin
		if(rst) begin
			memory[0] <= 0;
			memory[1] <= 0;
			memory[2] <= 0;
			memory[3] <= 0;
			memory[4] <= 0;
			memory[5] <= 0;
			memory[6] <= 0;
			memory[7] <= 0;
		end
		else begin
			if(regen)
			memory[inaddr] <= in;
		end 
	end
	
	assign out1 = memory[outaddr1];
	assign out2 = memory[outaddr2];
	assign pcout = memory[7];
endmodule
