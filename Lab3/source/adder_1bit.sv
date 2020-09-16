// $Id: $
// File name:   adder_1bit.sv
// Created:     9/6/2020
// Author:      Victor Le
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: 1 Bit Full Adder Module

module adder_1bit(
  input wire a,
  input wire b,
  input wire carry_in,
  output wire sum,
  output wire carry_out
);

wire ab;

XOR2X1 A1(.A(a), .B(b), .Y(ab));
XOR2X1 A2(.A(ab), .B(carry_in), .Y(sum));

wire xc_in; //not cin
wire abc;
wire or_ab;
wire x_a;
wire abc2;

INVX1 U1(.A(carry_in), .Y(xc_in));
AND2X1 U2(.A(xc_in), .B(a), .Y(x_a));
AND2X1 U3(.A(x_a), .B(b), .Y(abc));
OR2X1 U4(.A(a), .B(b), .Y(or_ab));
AND2X1 U5(.A(or_ab), .B(carry_in), .Y(abc2));
OR2X1 U6(.A(abc), .B(abc2), .Y(carry_out));

always @ (a, b, carry_in)
begin
   assert((a == 1'b0) || (a == 1'b1) && (b == 1'b0) || (b == 1'b1) && (carry_in == 1'b0) || (carry_in == 1'b1))
   else $error("Inputs 'a' & 'b' & 'carry_in' are not a digital logic Value");
end

endmodule
