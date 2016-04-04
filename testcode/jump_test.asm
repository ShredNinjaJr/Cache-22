ORIGIN 0
SEGMENT
CODE:
    LEA R0, DATA
    LDR R1, R0, LVAL1
    LDR R2, R0, LVAL2
    LDR R3, R0, LVAL3
    ADD R4, R1, R3
    ADD R3, R4, 4
    STR R3, R0, SVAL1
    ADD R4, R4, -10
    STR R4, R0, SVAL2
    AND R5, R2, -13
    STR R5, R0, SVAL3
    AND R6, R2, 12
    STR R6, R0, SVAL4
    LDR R1, R0, SVAL1
    LDR R2, R0, SVAL2
    LDR R3, R0, SVAL3
    LDR R4, R0, SVAL4

    LEA R5, THERE
    JMP R5
    JSR HERE
    LEA R5, HERE
    JSRR R5 
GOODEND:
    BRnzp GOODEND

THERE:
    LEA R7, GOODEND
    LDR R6, R0, GOOD
    RET
    LDR R6, R0, BADD
    BRnzp BADEND

HERE:
	AND R4, R0, 3
	RET

BADEND:
    BRnzp BADEND

SEGMENT
DATA:
LVAL1:  DATA2 4x0020
LVAL2:  DATA2 4x00D5
LVAL3:  DATA2 4x000F
SVAL1:  DATA2 ?
SVAL2:  DATA2 ?
SVAL3:  DATA2 ?
SVAL4:  DATA2 ?
GOOD:   DATA2 4x600D
BADD:   DATA2 4xBADD
BRO: 	DATA2 4x003E
