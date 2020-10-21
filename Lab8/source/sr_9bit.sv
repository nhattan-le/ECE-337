// $Id: $
// File name:   sr_9bit.sv
// Created:     10/3/2020
// Author:      Victor Le
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: 9 bit shift register that will shift serial data received

module sr_9bit
(
  input wire clk,
  input wire n_rst,
  input wire shift_strobe,
  input wire serial_in,
  input wire [3:0] data_size,
  output wire [7:0] packet_data,
  output wire stop_bit
);

wire [8:0] parallel_out;

assign packet_data = (data_size == 4'd7 )? {1'b0, parallel_out[7:1]} : (data_size == 4'd5 )? {3'b0, parallel_out[7:3]} : parallel_out[7:0];

assign stop_bit = parallel_out[8];
flex_stp_sr #(9, 0) ninebit_sr(.clk(clk), .n_rst(n_rst), 
                    .serial_in(serial_in), 
                    .shift_enable(shift_strobe), 
                    .parallel_out(parallel_out));

endmodule