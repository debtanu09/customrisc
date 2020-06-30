module alu(op, ina, inb, o, z, c);
	input op;
	input [15:0] ina, inb;
	output [15:0] o;
	output z, c;
	assign {c, o} = (op) ? ina + inb : {1'b0, ~(ina&inb)};
	assign z = ~|o;
endmodule
