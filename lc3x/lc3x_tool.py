#!/usr/bin/python
import sys
import re


instr_dict = {"XOR":5, "XNOR":5, "NAND":5, "OR":1, "SUB":1, "NOR":1, "MULT":8, "DIV":8}

bit_dict = {"SUB":1, "OR": 2, "NOR":3, "NAND":1, "XOR":2, "XNOR":3, "MULT":0, "DIV":4}


if(len(sys.argv) < 3):
    print "Usage: ./assembler.py <input-file> <output-file>"
    sys.exit();
#Open the files
fin = open(sys.argv[1], "r");
fout = open(sys.argv[2], "w");

for line in fin:
     newline = line.strip()
     splitLine = re.split('; |, | ', newline);
     newline = line
     if(len(splitLine) > 1):
        # Check the instruction
        instr = splitLine[0]
        regs = splitLine[1:];
	
	if(instr in instr_dict):
		dest = int(regs[0][1]);
		sr1 = int(regs[1][1]);
		sr2 = int(regs[2][1]);
		bitcode = (dest << 9) | (sr1 << 6) | (int(bit_dict[instr]) << 3) | sr2;
		newline = ('\t' + 'DATA2 4x' + (hex(instr_dict[instr]))[2:] + (hex(bitcode))[2:] + 
				 ' ;' + line)
		print newline

	
     fout.write(newline);
		
		

			
	


