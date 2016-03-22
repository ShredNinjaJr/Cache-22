import lc3b_types::*;

/* This tests load_buffer */
module load_buffer_testbench;

timeunit 1ns; 
timeprecision 1ns;

logic clk;

/* From Issue Control */
logic WE, flush;
lc3b_reg Q_in;
logic [16 - 1:0] V;
logic [16 - 1:0] offset_in;
lc3b_rob_addr dest_in;
	
/* CDB */
CDB CDB_in;
	
/* From Write Results Control */
logic RE;
	
/* To Write Results Control To Start  Mem Read */
logic valid_out;
	
/* To Dcache */
lc3b_word dmem_addr;
	
/* To Issue Control */
logic empty;
logic full;

load_buffer LB(.*);

always #1 clk = ~clk;

initial begin: CLOCK_INITIALIZATION
	clk = 0;
end

initial begin: TEST_VECTORS

WE = 0;
flush = 0;
Q_in = 0;
V = 0;
offset_in = 0;
dest_in = 0;
	
CDB_in.valid = 0;
CDB_in.data = 0;
CDB_in.tag = 0;
	
RE = 0;

#2

Q_in = 3'b001;
offset_in = 14;
dest_in = 3'b111;
WE = 1;

#2
WE = 0;

#2

Q_in = 3'b011;
offset_in = 9;
dest_in = 3'b111;
WE = 1;

#2
WE = 0;

#2

Q_in = 3'b001;
offset_in = 8;
dest_in = 3'b111;
WE = 1;

#2
WE = 0;

#2

Q_in = 3'b101;
offset_in = 1;
dest_in = 3'b100;
WE = 1;

#2
WE = 0;



#2

Q_in = 3'b101;
offset_in = 20;
dest_in = 3'b110;
WE = 1;

#2
WE = 0;

#2 RE = 1;

#2 RE = 0;


#2 RE = 1;

#2 RE = 0;

#2 
CDB_in.valid = 1;
CDB_in.tag = 5;
CDB_in.data = 32;

#2 
CDB_in.valid = 0;
CDB_in.tag = 0;
CDB_in.data = 0;

#2 RE = 1;

#2 RE = 0;







end

endmodule: load_buffer_testbench