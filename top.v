`include "risc.v"
module top;
	reg clk, rst;
	initial begin
		clk <= 0;
		rst <= 1;
	end
	
	
risc __risc(.clk(clk), .rst(rst));

	initial repeat(1700) #5 clk <= ~clk;
	
	initial #17 rst <= 0;
	
	initial begin
		$dumpfile("wave.vcd");
		$dumpvars(0, top);
	end
endmodule
