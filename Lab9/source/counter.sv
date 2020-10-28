// $Id: $
// File name:   counter.sv
// Created:     10/12/2020
// Author:      Victor Le
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: counter

module counter
(
   input wire clk,
   input wire n_rst,
   input wire cnt_up,
   input wire clear,
   output reg one_k_samples
);
wire [9:0] count;

flex_counter #10 ONE_K (.clk(clk), .n_rst(n_rst), .count_enable(cnt_up & (count < 10'd1000)), .clear(clear), .count_out(count), .rollover_val(10'd1000), .rollover_flag());
assign one_k_samples = count == 10'd1000;
endmodule