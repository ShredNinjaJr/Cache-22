/* Priority encoder. 16bit input - 4 bit output */
module priority_encoder 
(
  output logic [2:0]  binary_out , //  3 bit binary output
  input [7:0] in , //  8-bit input 
  input enable,		/* If encoder is enabled */
  output logic V			/* Valid output */
);
 
/* If not enabled or all inputs 0, V is not valid */
  assign V = (!enable) ? 1'b0 : (in[0] | in[1] | in[2] | in[3] | in[4] | in[5] | in[6] | in[7]);
  assign  binary_out  = (!enable) ? 3'h0 :((in[7]) ? 3'h7 : 
      (in[6]) ? 3'h6 : 
      (in[5]) ? 3'h5 : 
      (in[4]) ? 3'h4 : 
      (in[3]) ? 3'h3 : 
      (in[2]) ? 3'h2 : 
      (in[1]) ? 3'h1 : 3'h0); 
 endmodule: priority_encoder