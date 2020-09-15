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

always @ (a[0], b[0], carrys[0])
begin
   assert(((a[0] + b[0] + carrys[0]) % 2) == sum[0]) begin
     $info("index 0 sum is correct!");
   end
   else begin
     $error("Input 'b' is not a digital logic Value");
   end
end
always @ (a[0], b[0])
begin
   assert((a[0] == 1'b0) || (a[0] == 1'b1) && (b[0] == 1'b0) || (b[0] == 1'b1))
   else $error("Inputs 'a' & 'b' are not a digital logic Value");
end

endmodule