module chkeq(ina, inb, out);
	input [15:0] ina, inb;
	output out;
	
	assign out = (ina == inb);
endmodule
