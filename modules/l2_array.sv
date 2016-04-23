
module l2_array #(parameter width, parameter index_width)
(
    input clk,
    input write,
    input [index_width - 1: 0] index,
    input [width-1:0] datain,
    output logic [width-1:0] dataout
);

logic [width-1:0] data [(2**(index_width) - 1):0];
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
        data[index] <= datain;
    end

		dataout <= data[index];
end

endmodule : l2_array