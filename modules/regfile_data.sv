import lc3b_types::*;

module regfile_data # (parameter data_width = 16, parameter tag_width = 3)
(
    input clk,
    input load,
    input [data_width - 1:0] in,
    input [tag_width - 1:0] sr1, sr2, dest,
    output logic [data_width - 1:0] reg_a, reg_b, dest_out
);

logic [data_width - 1:0] data [7:0] /* synthesis ramstyle = "logic" */;

/* Altera device registers are 0 at power on. Specify this
 * so that Modelsim works as expected.
 */
initial
begin
    for (int i = 0; i < $size(data); i++)
    begin
        data[i] = 0;
    end
end

always_ff @(posedge clk)
begin
    if (load == 1)
    begin
        data[dest] <= in;
    end
end

always_comb
begin
    reg_a = data[sr1];
    reg_b = data[sr2];
	 dest_out = data[dest];
end

endmodule : regfile_data
