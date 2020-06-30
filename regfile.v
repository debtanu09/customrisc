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
	
	initial begin
	//$display("REG 0 REG 1 REG 2 REG 3 REG 4 REG 5 REG 6 REG 7");
	//$monitor("%4h %4h %4h %4h %4h %4h %4h %4h %0t",memory[0],memory[1],memory[2],memory[3],memory[4],memory[5],memory[6],memory[7], $time);
	//$monitor("%0d %0d %d",memory[0], memory[1], memory[2]);
	$monitor("%0d",memory[2]);
	end
endmodule
