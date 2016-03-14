module ir
(
    input clk,
    input load,
    input logic[15:0] in,
    output logic[2:0] dest, sr1, sr2,
    output logic [15:0] instr,
    output logic [2:0] nzp
);

logic[15:0] data;

always_ff @(posedge clk)
begin
    if (load == 1)
    begin
        data = in;
    end
end

always_comb
begin
//    opcode = (data[15:12]);

    dest = data[11:9];
    sr1 = data[8:6];
    sr2 = data[2:0];

 //   offset6 = data[5:0];
 //   offset9 = data[8:0];
	// offset11 = data[10:0];
	 
	// bit5 = data[5];
	// bit4 = data[4];
	// bit11 = data[11];
	 
	// imm5 = data[4:0];
	// imm4 = data[3:0];
	 
	 //trapvect8 = data[7:0];
	 nzp = data[11:9];
	 
end

endmodule : ir
