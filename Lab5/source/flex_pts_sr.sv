// $Id: $
// File name:   flex_pts_sr.sv
// Created:     9/27/2020
// Author:      Victor Le
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: Flexile Parallel to Serial Shift Register Design


module flex_pts_sr
#(
  parameter NUM_BITS = 4,
  parameter SHIFT_MSB = 1 
)
(
  input wire clk,
  input wire n_rst,
  input wire shift_enable,
  input wire load_enable,
  input wire [NUM_BITS-1:0] parallel_in,
  output reg serial_out 
);

reg [NUM_BITS - 1:0] shift_reg;
wire [NUM_BITS - 1:0] next_shift_reg;
genvar i;
genvar j;

wire [NUM_BITS-1:0] parallel_int;



always_ff @ (posedge clk, negedge n_rst) begin
  if (n_rst == 1'b0) begin
     shift_reg <= {NUM_BITS{1'b1}};
  end
  else begin
     shift_reg <= next_shift_reg;
  end
end
generate 

for(i = 0; i < NUM_BITS; i = i + 1) begin
    assign next_shift_reg[i] = load_enable == 1'b1 ? parallel_int[i] : (shift_enable == 1'b1 ?  (i == 0 ? 1'b1: shift_reg[i-1]) : shift_reg[i]); 
end
endgenerate
generate
for(j = 0; j < NUM_BITS; j = j + 1) begin
   if (SHIFT_MSB) begin
      assign parallel_int[j] = parallel_in[j];
   end
   else begin
      assign parallel_int[j] = parallel_in[(NUM_BITS - 1) - j];
   end
end
endgenerate

assign serial_out = shift_reg[NUM_BITS-1];


endmodule