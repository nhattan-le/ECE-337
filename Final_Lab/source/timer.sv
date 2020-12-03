// $Id: $
// File name:   timer.sv
// Created:     10/3/2020
// Author:      Victor Le
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: Keeps track of the timing in Serial_in data

module timer 
(
  input wire clk,
  input wire n_rst,
  input wire d_stuff,
  input wire d_edge,
  input wire idle,
  output reg shift_enable,
  output reg shift_enable2,
  output reg byte_received
);
reg [3:0] shift_count;
reg enable_4;
reg first_stage_en;
reg shift_enable_int;
reg byte_received_int;
reg byte_received_ff;




flex_counter counter_8(.clk(clk), .n_rst(n_rst), .clear(d_edge), .count_enable(!idle), .rollover_val(4'd8), .count_out(shift_count), .rollover_flag());
assign shift_enable_int  = (shift_count == 4'd3);
assign shift_enable = ~idle & shift_enable_int;
assign shift_enable2 = ~idle & shift_enable_int & !d_stuff;
flex_counter counter_byte(.clk(clk), .n_rst(n_rst), .clear(d_edge&idle), .count_enable(shift_enable2), .rollover_val(4'd8), .count_out(), .rollover_flag(byte_received));


endmodule