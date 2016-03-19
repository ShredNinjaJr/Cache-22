ORIGIN 4x0000

;; Only does ADD/AND and NOT
SEGMENT CodeSegment:

	ADD R1, R0, R0 ;
	NOT R1, R2 ;
	AND R4, R5, R6 ;

HALT:
	BRnzp HALT

