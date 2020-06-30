`include "alu.v"
`include "mem.v"
`include "regfile.v"
`include "register.v"
`include "mux2.v"
`include "signex6.v"
`include "mux4.v"
`include "leftshift.v"
`include "chkeq.v"
`include "signex9.v"
`include "mux8.v"
module risc(clk, rst);
input clk, rst;

reg memen, regen, aluouten, d1en, d2en, iren, fen;
reg aluopsel, memaddrsel, regfilerd2sel, regfilerd1sel;
reg [1:0] regfilewrsel, aluinp1sel;
reg [2:0] aluinp2sel, regfilewrdatasel;
wire [15:0] d1out, d2out, aluout, pcout, memin, memout, irout, out1, out2, aluoutout, aluin1, aluin2, extended6, leftshifted, regfilewrdata, memaddr, extended9, rightshifted;
wire carryout, zeroout, op, equality;
wire [1:0] fout;
wire [2:0] regfilewraddr, regfilerdaddr2, regfilerdaddr1;
wire [3:0] opcode;
wire conditionc, conditionz;
reg [15:0] memwrdata;

alu ALUUUT(op, aluin1, aluin2, aluout, zeroout, carryout);
mem MEMUUT(clk, rst, memen, memaddr, memin, memout);
regfile REGFILEUUT(clk, rst, regen, regfilerdaddr1, regfilerdaddr2, out1, out2, regfilewraddr, regfilewrdata, pcout);
register IR(clk, rst, iren, memout, irout);
register ALUOUT(clk, rst, aluouten, aluout, aluoutout);
register D1(clk, rst, d1en, out1, d1out);
register D2(clk, rst, d2en, out2, d2out);
register #(2) FLAG(clk, rst, fen, {carryout, zeroout}, fout);


mux2 #(1) ALUOP(1'b0, 1'b1, aluopsel, op);
mux4 ALUINP1(d1out, pcout, d2out, 16'bx, aluinp1sel, aluin1);
mux8 ALUINP2(d2out, 16'h0001, extended6, leftshifted, extended9, 16'bx, 16'bx, 16'bx, aluinp2sel, aluin2);
mux4 #(3) REGFILEWRADDR(irout[5:3], irout[8:6], 3'b111, irout[11:9], regfilewrsel, regfilewraddr);
mux8 REGFILEWRDATA(aluoutout, leftshifted, memout, d2out, extended9, 16'bx, 16'bx, 16'bx, regfilewrdatasel, regfilewrdata);
mux2 MEMRDADDR(pcout, aluoutout, memaddrsel, memaddr);
mux2 #(3) REGFILERD2(irout[8:6], 3'b111, regfilerd2sel, regfilerdaddr2);
mux2 #(3) REGFILERD1(irout[11:9], 3'b111, regfilerd1sel, regfilerdaddr1);

signex6 EXTEND6(irout[5:0], extended6);
leftshift LHIEXTEND(irout[8:0], leftshifted);
chkeq BRANCH(out1, out2, equality);
signex9 EXTEND9(irout[8:0], extended9);

parameter ADD = 4'h0;
parameter ADI = 4'h1;
parameter NAND = 4'h2;
parameter LHI = 4'h3;
parameter LW = 4'h4;
parameter SW = 4'h5;
parameter JAL = 4'h8;
parameter JLR = 4'h9;
parameter MVI = 4'ha;
parameter MOV = 4'hb;
parameter BEQ = 4'hc;

parameter RST = 6'b000000;
parameter IF  = 6'b000001;
parameter ID  = 6'b000010;
parameter RR  = 6'b000100;
parameter EX  = 6'b001000;
parameter MEM = 6'b010000;
parameter WB  = 6'b100000;


reg [5:0] cs;
wire [5:0] ns;

always @(posedge clk or posedge rst) begin
	if(rst) begin
		cs <= RST;
	end
	else begin
		cs <= ns;
	end	
end


assign ns = (cs == RST) ? IF : 6'bz;
assign ns = (cs == IF) ? ID : 6'bz;
assign ns = (cs == ID) ? RR : 6'bz;
assign ns = (cs == RR) ? EX : 6'bz;
assign ns = (cs == EX) ? MEM : 6'bz;
assign ns = (cs == MEM) ? WB : 6'bz;
assign ns = (cs == WB) ? IF : 6'bz;


always @ (negedge clk) begin
	if(~rst) begin
		case(cs)
			RST: begin
				iren <= 1;
				aluopsel <= 1;
				aluinp1sel <= 2'b01;
				aluinp2sel <= 3'b001;
				aluouten <= 0;
				regen <= 0;
				regfilewrsel <= 2'b00;
				fen <= 0;
				d1en <= 0;
				d2en <= 0;
				regfilewrdatasel <= 3'b000;
				memaddrsel <= 0;
				memen <= 0;
				regfilerd2sel <= 0;
				regfilerd1sel <= 0;
			end
			IF: begin
				iren <= 0;
				aluinp1sel <= 2'b01;
				if(opcode == BEQ & equality)
					aluinp2sel <= 3'b010;
				else if(opcode == JAL)
					aluinp2sel <= 3'b100;
				else
					aluinp2sel <= 3'b001;
				aluouten <= 1;
				fen <= 0;
				memaddrsel <= 0;
				if(opcode == JAL | opcode == JLR)
					regfilerd2sel <= 1;
				else
					regfilerd2sel <= 0;
				regfilerd1sel <= 0;
			end
			ID: begin
				aluinp1sel <= 2'b01;
				if(opcode == BEQ & equality)
					aluinp2sel <= 3'b010;
				else if(opcode == JAL)
					aluinp2sel <= 3'b100;
				else
					aluinp2sel <= 3'b001;
				aluouten <= 0;
				regen <= 1;
				if(opcode == JLR)
					regfilewrsel <= 2'b11;
				else
					regfilewrsel <= 2'b10;
				fen <= 0;
				d1en <= 1;
				d2en <= 1;
				memaddrsel <= 0;
				if(opcode == JAL) begin
					regfilerd1sel <= 1;
					regfilerd2sel <= 1;
				end
				else begin
					regfilerd1sel <= 0;
					regfilerd2sel <= 0;
				end
			end
			RR: begin
				if(opcode == NAND)
					aluopsel <= 0;
				else
					aluopsel <= 1;
				if(opcode == LW | opcode == SW)
					aluinp1sel <= 2'b10;
				else
					aluinp1sel <= 2'b00;
				if(opcode == ADI)
					aluinp2sel <= 3'b010;
				else if(opcode == LW | opcode == SW)
					aluinp2sel <= 3'b010;
				else if(opcode == JAL)
					aluinp2sel <= 3'b001;
				else
					aluinp2sel <= 3'b000;
				aluouten <= 1;
				regen <= 0;
				regfilewrsel <= 2'b00;
				fen <= 0;
				d1en <= 0;
				d2en <= 0;
				memaddrsel <= 0;
				if(opcode == JAL)
					regfilerd2sel <= 1;
				else
					regfilerd2sel <= 0;
				regfilerd1sel <= 0;
			end
			EX: begin
				aluopsel <= 1;
				if(opcode == LW | opcode == SW)
					aluinp1sel <= 2'b10;
				else
					aluinp1sel <= 2'b00;
				if(opcode == ADI)
					aluinp2sel <= 3'b010;
				else if(opcode == LW | opcode == SW)
					aluinp2sel <= 3'b010;
				else
					aluinp2sel <= 3'b000;
				aluouten <= 0;
				fen <= 0;
				if(opcode == LW | opcode == SW)
					memaddrsel <= 1;
				else
					memaddrsel <= 0;
				if(opcode == SW) begin
					memen <= 1;
					memwrdata <= d1out;
				end
				else
					memen <= 0;
				if(opcode == JAL)
					regfilerd2sel <= 1;
				else
					regfilerd2sel <= 0;
				regfilerd1sel <= 0;
			end
			MEM: begin
				if(opcode == LW)
					aluinp1sel <= 2'b10;
				else
					aluinp1sel <= 2'b00;
				if(opcode == ADI)
					aluinp2sel <= 3'b010;
				else if(opcode == LW)
					aluinp2sel <= 3'b010;
				else
					aluinp2sel <= 3'b000;
				aluouten <= 0;
				if((opcode == ADD | opcode == NAND) & conditionc)
				begin
					regen <= fout[1];
				end
				else if((opcode == ADD | opcode == NAND) & conditionz)
				begin
					regen <= fout[0];
				end
				else if(opcode != SW & opcode != BEQ)
				begin
					regen <= 1;
				end
				else
					regen <= 0;
				if(opcode == ADI)
					regfilewrsel <= 2'b01;
				else if(opcode == LHI | opcode == LW | opcode == JAL | opcode == MVI | opcode == MOV)
					regfilewrsel <= 2'b11;
				else if(opcode == JLR)
					regfilewrsel <= 2'b10;
				else
					regfilewrsel <= 2'b00;
				if(opcode == BEQ)	
					fen <= 0;
				else
					fen <= 1;
				if(opcode == LHI)
					regfilewrdatasel <= 3'b001;
				else if(opcode == LW)
					regfilewrdatasel <= 3'b010;
				else if(opcode == JLR | opcode == MOV)
					regfilewrdatasel <= 3'b011;
				else if(opcode == MVI)
					regfilewrdatasel <= 3'b100;
				else
					regfilewrdatasel <= 3'b000;
				if(opcode == LW)
					memaddrsel <= 1;
				else
					memaddrsel <= 0;
				memen <= 0;
				if(opcode == JAL)
					regfilerd2sel <= 1;
				else
					regfilerd2sel <= 0;
				regfilerd1sel <= 0;
			end
			WB: begin
				iren <= 1;
				aluinp1sel <= 2'b01;
				aluinp2sel <= 3'b001;
				aluouten <= 0;
				regen <= 0;
				regfilewrsel <= 3'b000;
				fen <= 0;
				regfilewrdatasel <= 0;
				memaddrsel <= 0;
				if(opcode == JAL)
					regfilerd2sel <= 1;
				else
					regfilerd2sel <= 0;
				regfilerd1sel <= 0;
			end
		endcase
	end
end

assign opcode = irout[15:12];
assign conditionc = irout[1];
assign conditionz = irout[0];
assign memin = memwrdata;


endmodule
