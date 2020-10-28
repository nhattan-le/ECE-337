// $Id: $
// File name:   magnitude.sv
// Created:     10/12/2020
// Author:      Victor Le
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: magnitude

module magnitude
(
input wire [16:0] in,
output wire [15:0] out
);
assign out = in[16]? ~in[15:0] + 16'd1: in[15:0];

endmodule