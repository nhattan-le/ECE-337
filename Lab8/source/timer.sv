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
  input wire enable_timer,
  input wire [13:0] bit_period,
  input wire [3:0]  data_size,
  output wire shift_enable,
  output wire packet_done
);
wire [13:0] shift_count;
wire [3:0] bit_count;
wire shift_en_int;
wire [3:0]shift_bits;

flex_counter #14 shift_cnt(.clk(clk), .n_rst(n_rst), .clear(!enable_timer), .count_enable(enable_timer), .rollover_val(bit_period), .count_out(shift_count), .rollover_flag());
assign shift_en_int = shift_count == ({1'b0, bit_period[13:1]} -14'd2);

assign shift_bits = (data_size == 4'd8) ? 4'd10 : (data_size == 4'd7 )? 4'd9 : 4'd7;

flex_counter packet_done_cnt(.clk(clk), .n_rst(n_rst), .clear(!enable_timer), .count_enable(shift_en_int), .rollover_val(shift_bits), .count_out(bit_count), .rollover_flag(packet_done));
assign shift_enable = bit_count != 4'b0000 ? shift_en_int : 1'b0;

endmodule