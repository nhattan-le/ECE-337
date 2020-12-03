// $Id: $
// File name:   sr_9bit.sv
// Created:     10/3/2020
// Author:      Victor Le
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: 16 bit shift register that will shift serial data received

module sr_16bit
(
  input wire clk,
  input wire n_rst,
  input wire shift_strobe,
  input wire serial_in,
  output wire [7:0] packet_data,
  output wire [7:0] old_packet_data
);



flex_stp_sr #(16, 0) ninebit_sr(.clk(clk), .n_rst(n_rst), 
                    .serial_in(serial_in), 
                    .shift_enable(shift_strobe), 
                    .parallel_out({packet_data[7:0], old_packet_data[7:0]}));

endmodule