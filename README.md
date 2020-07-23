# customrisc

    This is the verilog implementation of multi-cycle non pipelined custom RISC ISA
    
    All the instructions are 16 bit long and contains four different kind of instructions
    
    It contains 17 instructions

# Instructions format


    R TYPE INSTRUCTION
    Opcode        Register A (RA)         Register B (RB)         Register C (RC)         Unused        Condition (CZ)
    (4 bit)       (3 bit)                 (3-bit)                 (3-bit)                 (1 bit)       (2 bit)
    
    I TYPE INSTRUCTION
    Opcode        Register A (RA)        Register C (RC)          Immediate
    (4 bit)       (3 bit)                (3-bit)                  (6 bits signed)

    J TYPE INSTRUCTION
    Opcode        Register A (RA)         Immediate
    (4 bit)       (3 bit)                 (9 bits signed)

# Instructions and their assembly language syntax
    R TYPE INSTRUCTION
    1) ADD RC, RA, RB (add contents of RA and RB and store the result in RC)
    2) ADC RC, RA, RB (add contents of RA and RB and store the result in RC if the carry flag is set)
    3) ADZ RC, RA, RB (add contents of RA and RB and store the result in RC if the zero flag is set)
    4) NDU RC, RA, RB (nand contents of RA and RB and store the result in RC)
    5) NDC RC, RA, RB (nand contents of RA and RB and store the result in RC if the carry flag is set)
    6) NDZ RC, RA, RB (nand contents of RA and RB and store the result in RC if the zero flag is set)
    
    
    I TYPE INSTRUCTION --- IMM6 means 6 bit immediate data and all are sign extended to 16 bits
    1) ADI RB, RA, IMM6 (add contents of RA with IMM6 (signextended) and store result in RB)
    2) LW RA, RB, IMM6 (load value from memory into RA, Memory address is formed by adding IMM6 bits with content of RB)
    3) SW RA, RB, IMM6 (store value to memory from RA, Memory address is formed by adding IMM6 bits with content of RB)
    4) BEQ RA, RB, IMM6 (if content of RA and RB are the same,branch to PC+IMM6, where PC is the address of beq instruction)
    5) JLR RA, RB, 000000 (branch to the address in RB, store PC+1 into RA, where PC is the address of the jlr instruction)
    
    J TYPE INSTRUCTION --- IMM9 means 9 bit immediate data and all are sign extended to 16 bits
    1) LHI RA, IMM9 (place IMM9 into most significant 9 bits of RA and lower 7 bits are assigned to zero)
    2) JAL RA, IMM9 (branch to the address PC+IMM9, store PC+1 into RA, where PC is the address of the jal instruction)
    
    CUSTOM INSTRUCTION FOR EASE OF ASSEMBLY CODING
    1) MVI RB, IMM9 (mov the data in IMM9 which is appended by 0 on the MSB to make ut 16 bit into RB)
    2) MOV RB, RA (copy the data in RA to RB)
    
    CUSTOM INSTRUCTIONS FOR MULTIPLE DATA LOAD AND STORE AT A TIME
    1) LM RA, IMM9 (Load multiple registers whose address is given in the immediate field (one bit per register, R7 to R0) in order from right to left, i.e, registers from R0 to R7 if corresponding bit is set. Memory address is given in reg A. Registers are loaded from consecutive addresses)
    2) SM RA, IMM9 (Store multiple registers whose address is given in the immediate field (one bit per register, R7 to R0) in order from right to left, i.e, registers from R0 to R7 if corresponding bit is set. Memory address is given in reg A. Registers are stored in consecutive addresses)



# Instruction encoding
    ADD : 0000  RA RB RC 0 00
    ADC : 0000  RA RB RC 0 10
    ADZ : 0000  RA RB RC 0 01
    NDU : 0010  RA RB RC 0 00
    NDC : 0010  RA RB RC 0 10
    NDZ : 0010  RA RB RC 0 01
    
    ADI : 0001 RA RB IMM6
    LW  : 0100 RA RB IMM6
    SW  : 0101 RA RB IMM6
    BEQ : 1100 RA RB IMM6
    JLR : 1001 RA RB 000000
    
    LHI : 0011 RA IMM9
    JAL : 1000 RA IMM9
    
    MVI : 1010 RA IMM9
    MOV : 1011 RB RA 000000
    
    LM  : 0110 RA 0-------- (dashes can be anything from 8'h0 to 8'hff) (if the bit is set the corresponding register is loaded else not loaded)
    Ex - 0110 011 001010101 - starting address is the data in R3 and data in that mem address is loaded in R0, R1 is skipped, [address + 2] data is loaded in R2, R3 is skipped...... so on
    SM  : 0111 RA 0-------- (dashes can be anything from 8'h0 to 8'hff) (if the bit is set the corresponding register is stored in memory else not stored)
    Ex - 0111 011 001010101 - starting address is the data in R3 and data in R0 is stored at [address] loacation, [address + 1] location is skipped, [address + 2] location is written by data in R2, [address + 3] is skipped....... so on

# Architecture info
    It contains a register file of 8 register 16 bit each where R7 is the PC
    It has an ALU with ADD and NAND capabilities
    It has a single memory for instruction and data
    Rest it has muxes, shifters, signextenders, registers like IR and FLAG, equality checker.
    
# How to use this
    download iverilog and gtkwave
    Clone the project
    write the code in code.asm
    run the script run.sh
    
    A program for fibonacci numbers is already uploaded in the project for testing purposes
