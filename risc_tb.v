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

`include "risc.v"

module risc_tb;

reg clk, rst;

initial clk = 0;
initial rst = 1;

initial repeat(800) #5 clk = ~clk;

initial #17 rst = 0;

risc uut(clk, rst);

initial begin
	$dumpfile("wave.vcd");
	$dumpvars(0, risc_tb);
end

initial begin $display("R0   R1   R2   R3   R4   R5   R6   R7   M0   M1   M2   M3   M4   M5   M6   M7");
 $monitor("%4h %4h %4h %4h %4h %4h %4h %4h %4h %4h %4h %4h %4h %4h %4h %4h", uut.regfileuut.rfile[0], uut.regfileuut.rfile[1], uut.regfileuut.rfile[2], uut.regfileuut.rfile[3], uut.regfileuut.rfile[4], uut.regfileuut.rfile[5], uut.regfileuut.rfile[6], uut.regfileuut.rfile[7], uut.memoryuut.mem[0], uut.memoryuut.mem[1], uut.memoryuut.mem[2], uut.memoryuut.mem[3], uut.memoryuut.mem[4], uut.memoryuut.mem[5], uut.memoryuut.mem[6], uut.memoryuut.mem[7]);
end

endmodule
