// $Id: $
// File name:   fir_filter.sv
// Created:     10/12/2020
// Author:      Victor Le
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: Fir filter 

module fir_filter
(
input wire clk,
input wire n_reset,
input wire [15:0] sample_data,
input wire [15:0] fir_coefficient,
input wire load_coeff,
input wire data_ready,
output reg one_k_samples,
output reg modwait,
output reg [15:0] fir_out,
output reg err
);

//synchronizers
wire dr, lc;
//counter
wire cnt_up, clear;
//datapath
wire [2:0] op;
wire [3:0] src1;
wire [3:0] src2;
wire [3:0] dest;
wire overflow;
reg [16:0] outreg_data;

//synchronizers
sync_low LC (.clk(clk), .n_rst(n_reset), .async_in(load_coeff),.sync_out(lc));
sync_low DR (.clk(clk), .n_rst(n_reset), .async_in(data_ready),.sync_out(dr));
//controller
controller CRTL (.clk(clk), .n_rst(n_reset), .dr(dr), .lc(lc), .overflow(overflow), .cnt_up(cnt_up), .clear(clear), .op(op), .src1(src1), .src2(src2), .dest(dest), .err(err), .modwait(modwait));
//datapath
datapath DP (.clk(clk), .n_reset(n_reset), .op(op), .src1(src1), .src2(src2), .dest(dest), .ext_data1(sample_data), .ext_data2(fir_coefficient), .outreg_data(outreg_data), .overflow(overflow));
//counter
counter ONE_K (.clk(clk), .n_rst(n_reset), .clear(clear), .cnt_up(cnt_up), .one_k_samples(one_k_samples));
magnitude MAG (.in(outreg_data), .out(fir_out));

endmodule