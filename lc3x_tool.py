#!/usr/bin/python
import sys
import re

if(len(sys.argv) < 3):
    print "Usage: ./assembler.py <input-file> <output-file>"
    sys.exit();
#Open the files
fin = open(sys.argv[1], "r");
fout = open(sys.argv[2], "w");

for line in fin:
     newline = line.strip();
     splitLine = newline.split();
     if(len(splitLine) > 0):
        # Check the instruction
        for phrase in splitLine:
            phrase.replace(" ","");
            phrase.replace(",","");
        newline.join(splitLine)
        instr = splitLine[0]
        
            
     fout.write(newline);
     fout.write("\n")


