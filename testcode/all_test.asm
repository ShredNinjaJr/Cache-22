ORIGIN 4x0000


SEGMENT CodeSegment:
	LEA R0, DataSegment
	ADD R1,R1,1
	BRp NEXT1
	LDR R6,R0,Bad1 ; Immediate ADD does not work
	XOR R6, R0, R1
	BRnzp HALT
NEXT1:
	ADD R2,R1,-2
	BRn NEXT2 
	LDR R6,R0,Bad2 ; Immediate ADD with a negative value does not work
	BRnzp HALT
NEXT2:
	AND R3,R2,0
	BRz NEXT3
	LDR R6,R0,Bad3 ; Immediate AND does not work
	BRnzp HALT
NEXT3:
	AND R4,R1,-1
	BRp NEXT4
	LDR R6,R0,Bad3 ; Immediate AND does not work
	BRnzp HALT
NEXT4:
	AND R4,R2,-7
	BRn LDB_TEST_1
	LDR R6,R0,Bad4 ; Immediate AND with a neg. value does not work
	BRnzp HALT
LDB_TEST_1:
	;Tests Left shift and LDB, and STB
	LDR R6, R0, Good
	NOT R6, R6
	ADD R6, R6, 1; 	;R6 is the value to compare with
	LDB R4, R0, LowByte;
	STB R4, R0, LowSByte;
	LDB R5, R0, HighByte;
	STB R5, R0, HighSByte;
	LSHF R5, R5, 8
	ADD R5, R5, R4 ; ; R5 should equal Good
	;Check if R5 is good
	ADD R2, R5, R6;
	BRz NEXT5
	LDR R6, R0, Bad5;
	BRnzp HALT
NEXT5:
	;Check if STB Worked
	LDR R5, R0, LowSByte
	ADD R2, R5, R6
	BRz NEXT6
	LDR R6, R0, Bad6
	BRnzp HALT

NEXT6: 
	; LDI test
	LDI R5, R0, MyPointer
	LDR R2, R0, Pass
	NOT R2, R2
	ADD R2, R2, 1
	ADD R2, R5, R2
	BRz NEXT7
	LDR R6, R0, Bad7
	BRnzp HALT
NEXT7: 	
	;STI test
	LDR R5, R0, Good
	STI R5, R0, MyPointer
	LDR R5, R0, Pass
	ADD R2, R6, R5
	BRz NEXT8
	LDR R6, R0, Bad8
	BRnzp HALT
NEXT8:
	;TRAP JSR and JSRR test
	LDR R6, R0, Bad9
	JSR SUBR
	LDR R6, R0, BadA
	LEA R3, SUBR
	JSRR R3
	LDR R6, R0, BadB
	TRAP delta
	BRnzp HALT
SUBR:
	LDR R6, R0, Good
	RET
HALT:
	BRnzp HALT

delta: DATA2 SUBR
SEGMENT DataSegment:
	Bad1: DATA2 4xBAD1 ; Immediate ADD does not work
	Bad2: DATA2 4xBAD2 ; Immediate ADD with a neg. value does not work
	Bad3: DATA2 4xBAD3 ; Immediate AND does not work
	Bad4: DATA2 4xBAD4 ; Immediate AND with a neg. value does not work
	Bad5: DATA2 4xBAD5 ; LDB/ SHFL failed
	Bad6: DATA2 4xBAD6 ; STB Failed
	Bad7: DATA2 4xBAD7 ; LDI Failed
	Bad8: DATA2 4xBAD8 ; STI Failed
	Bad9: DATA2 4xBAD9 ; JSR Failed 
	BadA: DATA2 4xBADA ; JSRR Failed 
	BadB: DATA2 4xBADB ; TRAP Failed
	Good: DATA2 4x600D ; 
	LowByte: DATA1 4x0D; 
	HighByte: DATA1 4x60;
	LowSByte: DATA1 ?  ;
	HighSByte: DATA1 ? ;
	Pass: DATA2 4x1234 ;
	MyPointer: DATA2 Pass
	
