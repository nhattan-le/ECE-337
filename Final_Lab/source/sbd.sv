// $Id: $
// File name:   sbd.sv
// Created:     11/30/2020
// Author:      Victor Le
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: stuff bit detector


module sbd
(
  input wire clk,
  input wire nrst,
  input wire id_orig,
  input wire shift_enable,
  output reg d_stuff
);

reg [3:0] count;

flex_counter shift_cnt(.clk(clk), .n_rst(nrst), .clear(id_orig), .count_enable(shift_enable), .rollover_val(4'd6), .count_out(count), .rollover_flag());

assign d_stuff = (count == 6) ? 1'b1 : 1'b0;

endmodule