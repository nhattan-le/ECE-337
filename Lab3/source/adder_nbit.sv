// $Id: $
// File name:   adder_nbit.sv
// Created:     9/8/2020
// Author:      Victor Le
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: n bit ripple adder

module adder_nbit
#(
  parameter BIT_WIDTH = 4
)
(
  input wire [(BIT_WIDTH - 1):0] a,
  input wire [(BIT_WIDTH - 1):0] b,
  input wire carry_in,
  output wire [(BIT_WIDTH - 1):0] sum,
  output wire overflow
);


wire [BIT_WIDTH:0] carrys;
genvar i;

assign carrys[0] = carry_in;
generate
for(i = 0; i <= BIT_WIDTH - 1; i = i + 1)
  begin
    adder_1bit  IX (.a(a[i]), .b(b[i]), .carry_in(carrys[i]), .sum(sum[i]), .carry_out(carrys[i + 1]));
  end
endgenerate
assign overflow = carrys[BIT_WIDTH];

endmodule