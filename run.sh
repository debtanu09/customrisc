#!/bin/bash

python3 assembler.py
iverilog adder.v
iverilog alu.v
iverilog chkeq.v
iverilog dmem.v
iverilog imem.v
iverilog leftshift.v
iverilog mem.v
iverilog mux2.v
iverilog mux4.v
iverilog mux8.v
iverilog regfile.v
iverilog register.v
iverilog signex6.v
iverilog signex9.v
iverilog risc.v
iverilog top.v
vvp a.out 
gtkwave wave.vcd
