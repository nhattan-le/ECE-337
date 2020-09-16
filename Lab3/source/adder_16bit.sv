// $Id: $
// File name:   adder_16bit.sv
// Created:     9/15/2020
// Author:      Victor Le
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: 16 bit adder

module adder_16bit
(
	input wire [15:0] a,
	input wire [15:0] b,
	input wire carry_in,
	output wire [15:0] sum,
	output wire overflow
);

	

adder_nbit #(16) ADD16(.a(a), .b(b), .carry_in(carry_in), .sum(sum), .overflow(overflow));


genvar i;

generate 
for(i = 0; i <= 15; i = i + 1) 
begin
   always @ (a[i], b[i]) begin
      assert((a[i] == 1'b0) || (a[i] == 1'b1) && (b[i] == 1'b0) || (b[i] == 1'b1))
      else $error("Inputs 'a' & 'b' are not a digital logic Value");
   end
end
endgenerate

always @ (carry_in)
begin
   assert((carry_in == 1'b0) || (carry_in == 1'b1))
   else $error("Input carry_in is not a digital logic Value");
end


endmodule
