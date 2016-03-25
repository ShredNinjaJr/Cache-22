module mp3_tb;

timeunit 1ns;
timeprecision 1ns;
/*
logic clk;
logic pmem_resp;
logic pmem_read;
logic pmem_write;
logic [15:0] pmem_address;
logic [127:0] pmem_rdata;
logic [127:0] pmem_wdata;
*/
logic clk;

/* Clock generator */
initial clk = 0;
always #5 clk = ~clk;

/*
mp3 dut
(
    .clk,
    .pmem_resp,
    .pmem_rdata,
    .pmem_read,
    .pmem_write,
    .pmem_address,
    .pmem_wdata
);

physical_memory memory
(
    .clk,
    .read(pmem_read),
    .write(pmem_write),
    .address(pmem_address),
    .wdata(pmem_wdata),
    .resp(pmem_resp),
    .rdata(pmem_rdata)
);
*/
logic imem_resp;
logic imem_read;
logic [15:0] imem_address;
logic [15:0] imem_rdata;

logic [15:0] dmem_address;
logic [15:0] dmem_rdata;
logic [15:0] dmem_wdata;
logic dmem_resp;
logic dmem_read;
logic dmem_write;
logic [1:0] dmem_byte_enable;

cpu_datapath dut
(
	.*
);

magic_memory_dp memory
(
	.clk,
	.read_a(imem_read),
	.write_a(1'b0),
	.address_a(imem_address),
	.resp_a(imem_resp),
	.rdata_a(imem_rdata),
	.wdata_a(2'bX),
	.wmask_a(2'bXX),
	
	.read_b(dmem_read),
	.write_b(dmem_write),
	.address_b(dmem_address),
	.wdata_b(dmem_wdata),
	.resp_b(dmem_resp),
	.rdata_b(dmem_rdata),
	.wmask_b(dmem_byte_enable)
	
);

endmodule : mp3_tb
