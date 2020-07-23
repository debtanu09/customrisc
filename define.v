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

`define datasize 16
`define memsize 1024
`define memaddrsize 16
`define regfileaddrsize 3
`define regfilesize 8
`define pcaddr 7
`define statesize 6
`define countersize 3
`define extend6size 6
`define extend9size 9
`define flagregsize 2
`define opcodesize 4

//states

`define rst 6'h0
`define of 6'h1
`define od 6'h2
`define rr 6'h4
`define ex 6'h8
`define mem 6'h10
`define wb 6'h20

//instructions

`define add 4'h0
`define adi 4'h1
`define ndu 4'h2
`define lhi 4'h3
`define lw 4'h4
`define sw 4'h5
`define lm 4'h6
`define sm 4'h7
`define jal 4'h8
`define jlr 4'h9
`define mvi 4'ha
`define mov 4'hb
`define beq 4'hc

