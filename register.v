module register(clk, rst, en, in, out);

	parameter size = 16;
	
	input clk, rst, en;
	input [size-1:0] in;
	output [size-1:0] out;
	
	reg [size-1:0] out;
	
	always @(posedge clk) begin
		if(rst)
			out <= 0;
		else if(en)
			out <= in;
	end
	
endmodule
