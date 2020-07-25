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
`include "adder.v"
`include "equality.v"
`include "increment.v"
`include "alu.v"
`include "memory.v"
`include "register.v"
`include "regfile.v"
`include "mux2.v"
`include "mux4.v"
`include "mux8.v"
`include "signex6.v"
`include "signex9.v"
`include "zeropad.v"

module risc(clk, reset);
input clk, reset;
reg [`statesize-1:0] cstate;
wire [`statesize-1:0] nstate;
wire [`opcodesize-1:0] instruction;
wire [1:0] cond;

assign nstate = (reset) ? `rst : {`statesize{1'bz}};
assign nstate = (~reset & cstate == `rst) ? `of : {`statesize{1'bz}};
assign nstate = (~reset & cstate == `of) ? `od : {`statesize{1'bz}};
assign nstate = (~reset & cstate == `od) ? `rr : {`statesize{1'bz}};
assign nstate = (~reset & cstate == `rr) ? `ex : {`statesize{1'bz}};
assign nstate = (~reset & cstate == `ex) ? `mem : {`statesize{1'bz}};
assign nstate = (~reset & cstate == `mem & instruction == `sm & o_counter != 3'b111) ? `od : {`statesize{1'bz}};
assign nstate = (~reset & cstate == `mem & instruction == `sm & o_counter == 3'b111) ? `wb : {`statesize{1'bz}};
assign nstate = (~reset & cstate == `mem & instruction != `sm) ? `wb : {`statesize{1'bz}};
assign nstate = (~reset & cstate == `wb & instruction == `lm & o_counter != 3'b000) ? `ex : {`statesize{1'bz}};
assign nstate = (~reset & cstate == `wb & instruction == `lm & o_counter == 3'b000) ? `of : {`statesize{1'bz}};
assign nstate = (~reset & cstate == `wb & instruction != `lm) ? `of : {`statesize{1'bz}};

always @(posedge clk or posedge reset) begin
	if(reset)
		cstate = `rst;
	else
		cstate = nstate;
end


always @(negedge clk) begin
	case(cstate)
		`rst: begin
			regfilewraddr = 3'b000;
			regfilewrdata = 3'b000;
			regfilewr = 0;
			irwr = 1;
			memaddrsel = 2'b00;
			regfilerdsel1 = 0;
			regfilerdsel2 = 0;
		end
		`of: begin
			irwr = 0;
			if(o_equal & instruction == `beq)
				regfilewr = 0;
			else
				regfilewr = 1;
			if(instruction == `jal || instruction == `jlr) begin
				regfilewraddr = 3'b011;
				regfilewrdata = 3'b000;
			end
			else begin
				regfilewraddr = 3'b000;
				regfilewrdata = 3'b000;
			end
			equalitywr = 1;
		end
		`od: begin
			regfilewr = 0;
			regfilewraddr = 3'b000;
			regfilewrdata = 3'b000;
			readregwr1 = 1;
			readregwr2 = 1;
			if(instruction == `add || instruction == `adi || instruction == `lw || instruction == `sw || instruction == `beq || instruction == `jal || instruction == `jlr)
				aluop = 1;
			else
				aluop = 0;
			counterwr = 0;
			if(instruction == `sm) begin
				regfilerdsel1 = 0;
				regfilerdsel2 = 1;
				
			end
			else if(instruction == `beq || instruction == `jal || instruction == `jlr) begin
				regfilerdsel1 = 1;
				regfilerdsel2 = 0;
			end
			else begin
				regfilerdsel1 = 0;
				regfilerdsel2 = 0;
			end
			equalitywr = 0;
		end
		`rr: begin
			readregwr1 = 0;
			readregwr2 = 0;
			if(instruction == `add || instruction == `ndu) begin
				aluinp1sel = 0;
				aluinp2sel = 2'b00;
				
			end
			else if(instruction == `lw || instruction == `sw)begin
				aluinp1sel = 1;
				aluinp2sel = 2'b01;
			end
			else if(instruction == `jal || instruction == `jlr) begin
				aluinp1sel = 0;
				aluinp2sel = 2'b10;
			end
			else begin
				aluinp1sel = 0;
				aluinp2sel = 2'b01;
			end
		end
		`ex: begin
			//readaluwr = 0;
			if(instruction == `lm || instruction == `sm)
				memaddrsel = 2'b10;
			else if(instruction == `lw || instruction == `sw)
				memaddrsel = 2'b01;
			else
				memaddrsel = 2'b00;
			if(instruction == `sw || (instruction == `sm && o_irdata[o_counter] == 1))
				memwr = 1;
			else
				memwr = 0;
			if(instruction == `sm)
				memwrdatasel = 1;
			else
				memwrdatasel = 0;
		end
		`mem: begin
			if(instruction == `add || instruction == `ndu)
				regfilewraddr = 3'b001;
			else if(instruction == `adi)
				regfilewraddr = 3'b010;
			else if(instruction == `lm)
				regfilewraddr = 3'b100;
			else if(instruction == `beq || instruction == `jal || instruction == `jlr)
				regfilewraddr = 3'b000;
			else
				regfilewraddr = 3'b011;
			
			if(instruction == `adi || instruction == `lhi || instruction == `lw ||  instruction == `mov || instruction == `mvi)
				regfilewr = 1;
			else if((instruction == `add && cond == 2'b0) || (instruction == `add && cond[0] && o_flagdata[0]) ||
			 (instruction == `add && cond[1] && o_flagdata[1]))
				regfilewr = 1;
			else if((instruction == `ndu && cond == 2'b0) || (instruction == `ndu && cond[0] && o_flagdata[0]) ||
			 (instruction == `ndu && cond[1] && o_flagdata[1]))
				regfilewr = 1;
			else if(instruction == `lm && o_irdata[o_counter] == 1)
				regfilewr = 1;
			else if(o_equal & instruction == `beq || instruction == `jal || instruction == `jlr)
				regfilewr = 1;
			else if(instruction == `mvi || instruction == `mov)
				regfilewr = 1;
			else
				regfilewr = 0;
				
			if(instruction == `add || instruction == `adi || instruction == `ndu | instruction == `beq || instruction == `jal)	
				regfilewrdata = 3'b001;
			else if(instruction == `lhi)
				regfilewrdata = 3'b110;
			else if(instruction == `jlr)
				regfilewrdata = 3'b101;
			else if(instruction == `mvi)
				regfilewrdata = 3'b110;
			else if(instruction == `mov)
				regfilewrdata = 3'b101;
			else
				regfilewrdata = 3'b011;
			
			if(instruction == `add || instruction == `adi || instruction == `ndu)	
				flagwr = 1;
			else
				flagwr = 0;
			if(instruction == `lm || instruction == `sm)
				counterwr = 1;
			else
				counterwr = 0;
			memwr = 0;
		end
		`wb: begin
			regfilewraddr = 3'b000;
			regfilewrdata = 2'b00;
			regfilewr = 0;
			flagwr = 0;
			if((instruction == `lm || instruction == `sm) && (o_counter != 3'b000)) begin
				memaddrsel = 2'b10;
				irwr = 0;
			end
			else begin
				memaddrsel = 2'b00;
				irwr = 1;
			end
			counterwr = 0;
			regfilerdsel1 = 0;
			regfilerdsel2 = 0;
		end
	endcase
end
//-----------ALU-------------------
wire [`datasize-1:0] alua, alub, aluz;
wire cout, zout;
reg aluop;
alu aluuut(alua, alub, aluz, aluop, cout, zout);//1-add 0-nand




//-----------MEM-------------------
wire [`datasize-1:0] i_memdata, o_memdata;
wire [`memaddrsize-1:0] memaddr;
reg memwr;
memory memoryuut(clk, reset, memwr, i_memdata, o_memdata, memaddr);




//------------IR-------------------
wire [`datasize-1:0] i_irdata, o_irdata;
reg irwr;
register iruut(clk, reset, irwr, i_irdata, o_irdata);




//-----------FLAG------------------
wire [`flagregsize-1:0] i_flagdata, o_flagdata;
reg flagwr;
register #(2) flaguut(clk, reset, flagwr, i_flagdata, o_flagdata);




//---------REGFILE-----------------
wire [`regfileaddrsize-1:0] o_regfileaddr1, o_regfileaddr2, i_regfileaddr;
wire [`datasize-1:0] o_regfiledata1, o_regfiledata2, i_regfiledata, o_pc;
reg regfilewr;
regfile regfileuut(clk, reset, regfilewr, o_regfileaddr1, o_regfileaddr2, i_regfileaddr, o_regfiledata1, o_regfiledata2, i_regfiledata, o_pc);




//----------READ REG 1-------------
wire [`datasize-1:0] i_readregdata1, o_readregdata1;
reg readregwr1;
register readreg1uut(clk, reset, readregwr1, i_readregdata1, o_readregdata1);




//----------READ REG 2-------------
wire [`datasize-1:0] i_readregdata2, o_readregdata2;
reg readregwr2;
register readreg2uut(clk, reset, readregwr2, i_readregdata2, o_readregdata2);




//----------PC INC------------------
wire [`datasize-1:0] i_oldpc, o_newpc;
increment incrementuut(i_oldpc, o_newpc);




//------SIGN EXTEND 6--------------
wire [`extend6size-1:0] i_signex6;
wire [`datasize-1:0] o_signex6;
signex6 signex6uut(i_signex6, o_signex6);




//------SIGN EXTEND 9--------------
wire [`extend9size-1:0] i_signex9;
wire [`datasize-1:0] o_signex9;
signex9 signex9uut(i_signex9, o_signex9);




//-----------ZERO PAD--------------
wire [`extend9size-1:0] i_zeropad;
wire [`datasize-1:0] o_zeropad;
zeropad zeropaduut(i_zeropad, o_zeropad);




//------------COUNTER REG----------
reg counterwr;
wire [`countersize-1:0] i_counter, o_counter;
register #(3) counterreg(clk, reset, counterwr, i_counter, o_counter);




//--------REGFILE WRITE ADDRESS----
reg [2:0] regfilewraddr;
mux8 #(3) mux8wraddruut(3'd7, o_irdata[5:3], o_irdata[8:6], o_irdata[11:9], o_counter, 3'bz, 3'bz, 3'bz, regfilewraddr, i_regfileaddr);




//--------REGFILE WRITE DATA-------
reg [2:0] regfilewrdata;

//----------MUX 2------------------
mux8 mux8wrdatauut(o_newpc, aluz, o_zeropad, o_memdata, o_readregdata1, o_readregdata2, o_signex9, 16'bz, regfilewrdata, i_regfiledata);




//------------ALU INP-------------

reg aluinp1sel;
reg [1:0] aluinp2sel;
mux2 mux2aluinp1data(o_readregdata1, o_readregdata2, aluinp1sel, alua);
mux4 mux2aluinp2data(o_readregdata2, o_signex6, o_signex9, 16'bz, aluinp2sel, alub);




//----EFFECTIVE ADDR (LM SM)------
wire [`memaddrsize-1:0] effaddr;
adder calcaddr(o_readregdata1, {13'b0, o_counter}, effaddr);




//---------MEM ADDRESS SEL---------
reg [1:0] memaddrsel;
mux4 mux4memaddrsel(o_pc, aluz, effaddr, {`memaddrsize{1'bz}}, memaddrsel, memaddr);




//-----------COUNTER INC-----------
increment #(3) inccounter(o_counter, i_counter);




//------REGFILE READ ADDR SEL1-----
reg regfilerdsel1;
mux2 #(3) regfilereadaddrsel1(o_irdata[11:9], 3'b111, regfilerdsel1, o_regfileaddr1);




//------REGFILE READ ADDR SEL2-----
reg regfilerdsel2;
mux2 #(3) regfilereadaddrsel2(o_irdata[8:6], o_counter, regfilerdsel2, o_regfileaddr2);




//-----MEM WR DATA SEL-------------
reg memwrdatasel;
mux2 memwrdatamux(o_readregdata1, o_readregdata2, memwrdatasel, i_memdata);




//-----------EQUALITY--------------
wire equal;
equality chkequ(o_regfiledata1, o_regfiledata2, equal);




//--------EQUALITY REG STORE-------
reg equalitywr;
wire o_equal;
register #(1) equalityreg(clk, reset, equalitywr, equal, o_equal);




assign i_irdata = o_memdata;
assign i_readregdata1 = o_regfiledata1;
assign i_readregdata2 = o_regfiledata2;
assign i_oldpc = o_pc;
assign i_flagdata = {cout, zout};
assign instruction = o_irdata[15:12];
assign cond = o_irdata[1:0];
assign i_signex6 = o_irdata[5:0];
assign i_signex9 = o_irdata[8:0];
assign i_zeropad = o_irdata[8:0];

endmodule
