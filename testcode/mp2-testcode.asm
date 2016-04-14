ORIGIN 0
SEGMENT 0 CODE:
	LDR R1, R0, l1p
	LDR R2, R0, l2p
	LDR R3, R0, l3p
	LDR R4, R1, 0 ; cache miss, loads line1
	LDR R5, R2, 0 ; cache miss, loads line2
	;LDR R6, R1, 0 ; cache hit,  sets line2 as LRU
	LDR R7, R3, 0 ; cache miss, evicts line2, loads line3
	
	LDR R4, R2, 0 ; Evicts Line 3, loads Line 2
	
	STR R4, R1, 0 ;	 Cache miss, Writes 1111 to line 1, Dirty set
		         ;line 2 is lru, line1 = 2222
	
	LDR R6, R3, 0 ; Cache miss, evicts line2, loads line3. Line1 lru
	LDR R6, R2, 0 ; Cache miss, evicts line1, writeback, loads line2.
			; line3 lru
	LDR R6, R1, 0 ; Cache miss, evicts line3, loads line1. Line2 lru
	STR R6, R3, 1 ; Cache miss, evicts line2, loads line3, sets dirty
		      ; Line1 lru, Line3 == 2222
	STB R7, R1, 0 ; Cache hit, dirty bit, line3 lru
	STR R6, R2, 1 ; Cache miss, evicts line3, writeback, loads line2, sets dirty
		
	
inf:
	BRnzp inf

l1p:	DATA2 line1
l2p:	DATA2 line2
l3p:	DATA2 line3

SEGMENT 64 line1:
X:	DATA2 4x1111
NOP
NOP
NOP
NOP
NOP
NOP
NOP


SEGMENT 128 line2:
Y:	DATA2 4x2222
NOP
NOP
NOP
NOP
NOP
NOP
NOP

SEGMENT 128 line3:
Z:	DATA2 4x3333
NOP
NOP
NOP
NOP
NOP
NOP
NOP
