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
    always @ (a[i], b[i], carrys[i]) begin
      assert((a[i] == 1'b0) || (a[i] == 1'b1) && (b[i] == 1'b0) || (b[i] == 1'b1))
      else $error("Inputs 'a' & 'b' are not a digital logic Value");
      assert(((a[i] + b[i] + carrys[i]) % 2) == sum[i])
      else $error("Output s of bit i is not correct");
      assert(((a[i] + b[i] + carrys[i]) / 2) == carrys[i+1])
      else $error("Output c_out of bit i is not correct");   
    end
  end
endgenerate
assign overflow = carrys[BIT_WIDTH];


always @ (carry_in)
begin
   assert((carry_in == 1'b0) || (carry_in == 1'b1))
   else $error("Input carry_in is not a digital logic Value");
end

endmodule