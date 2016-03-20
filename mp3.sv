import lc3b_types::*;

module mp3
(
	input clk,
	input lc3b_word imem_rdata,
	input lc3b_word dmem_rdata,
	input imem_resp,
	input dmem_resp,
	
	output lc3b_word imem_address,
	output logic imem_read,
	output logic dmem_read,
	output logic dmem_write
);

cpu_datapath cpu_datapath(.*);
 
 endmodule: mp3