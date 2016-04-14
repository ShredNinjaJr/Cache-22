ORIGIN 4x0000

SEGMENT CodeSegment:

;Register table
;R0: ZERO
;R1; input n
;R2: output
;R3: temp
;R4: temp2
;R5: -1
 


; C CODE: for computing factorial
; while(n > 0)
; {
;	temp = n;
;	temp2 = n;
;	while( temp > 0)
;	    output = output + temp2;
;	    temp = temp - 1;
;	n = n - 1
; }
; All the comments below model the C code above
	LDR R1, R0, N	; R1 <= N
	LDR R5, R0, N_ONE; R5 = -1;
	ADD R1, R1, R5;	  n--;
	LDR R2, R0, ONE; output = 1;
	

OUTER:			;outer loop
	ADD R3, R1, R0;    temp = n
	ADD R4, R2, R0;    temp2 = output
INNER:			; Inner loop for multiplication
	ADD R2, R2, R4;	  output += temp2
	ADD R3, R3, R5;   temp = temp + (-1)
	BRp INNER     ;	 while(temp > 0)
	
	ADD R1, R1, R5;	 n = n - 1;
	BRp OUTER     ;	 while ( n < 0)


HALT:
	BRnzp HALT

ZERO: DATA2 4x0000
ONE:  DATA2 4x0001
N:    DATA2 4x0005
N_ONE: DATA2 4xFFFF
