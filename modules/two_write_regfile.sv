import lc3b_types::*;

module two_write_regfile # (parameter data_width = 1, parameter tag_width = 3)
(
    input clk, flush,
    input load_a, load_b,
    input [data_width - 1:0] in_a, in_b,
    input [tag_width - 1:0] sr1, sr2, dest_a, dest_b,
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
	 if(flush)
	 begin
		for (int i = 0; i < $size(data); i++)
		 begin
					data[i] <= 0;
		 end
	 end
    else if (load_a == 1)
    begin
        data[dest_a] <= in_a;
    end
	 if(load_b == 1)
	 begin
		if((dest_a == dest_b) & load_a)
			data[dest_b] <= in_a;
		else
			data[dest_b] <= in_b;
	 end
end

always_comb
begin
    reg_a = data[sr1];
    reg_b = data[sr2];
	 dest_out = data[dest_a];
end

endmodule : two_write_regfile