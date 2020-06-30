# customrisc

    This is the verilog implementation of multi-cycle non pipelined custom RISC ISA
    
    All the instructions are 16 bit long and contains four different kind of instructions
    
    It contains 15 instructions

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
    1) MVI RB, IMM9 (mov the data in IMM6 which is appended by 0 on the MSB to make ut 16 bit into RB)
    2) MOV RB, RA (cpoy the data in RA to RB)



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

# Architecture info
    It contains a register file of 8 register 16 bit each
    It has an ALU with ADD and NAND capabilities
    It has a single memory for instruction and data
    Rest it has muxes, shifters, signextenders, registers, equality checker.
    
# How to use this
    download iverilog and gtkwave
    Clone the project
    write the code in code.asm
    run the script run.sh
    using 
