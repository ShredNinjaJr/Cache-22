
module array_sepwrite #(parameter width, parameter index_width, parameter data_size)
(
    input clk,
    input write,
    input [index_width - 1: 0] index,
	 input [index_width - 1: 0] index2,
    input [data_size -1:0] datain,
    output logic [data_size -1:0] dataout
);
logic [data_size-1:0] data [width- 1:0];

/* Initialize array */
initial
begin
	 for (int i = 0; i < $size(data); i++)
	 begin
		  data[i] = 1'b0;
	 end
end

always_ff @(posedge clk)
begin
	 if (write == 1)
	 begin
		  data[index2] <= datain;
	 end
end

assign dataout = data[index];

endmodule : array_sepwrite