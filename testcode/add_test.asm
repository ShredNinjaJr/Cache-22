ORIGIN 4x0000

;; Only does ADD/AND and NOT
SEGMENT CodeSegment:

	ADD R1, R0, R0 ;
	NOT R1, R1 ;
	NOT R1, R1 ;
	AND R4, R5, R6 ;
	ADD R5, R6, R7;
	ADD R5, R5, R5 ;

HALT:
	BRnzp HALT

