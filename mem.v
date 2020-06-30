module mem(clk, rst, en, addr, in, out);
	input rst, clk, en;
	input [15:0] in, addr;
	output [15:0] out;
	
	reg [15:0] memory [0:11];
	initial $readmemh("mem.txt", memory);
	always @(posedge rst or posedge clk) begin
		if(rst)
			$readmemh("mem.txt", memory);
		else if(en)
			memory[addr] <= in;
	end
	assign out = memory[addr];
	
	//initial $monitor("%4h %0t",memory[0], $time);
endmodule
