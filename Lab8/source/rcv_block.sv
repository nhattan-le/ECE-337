// $Id: $
// File name:   rcv_block.sv
// Created:     10/4/2020
// Author:      Victor Le
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: Recieving Block Uart Design

module rcv_block
(
   input wire clk,
   input wire n_rst,
   input wire serial_in,
   input wire data_read,
   input [13:0] bit_period,
   input [3:0] data_size,
   output reg [7:0] rx_data,
   output reg data_ready,
   output reg overrun_error,
   output reg framing_error
);

wire load_buffer;
wire sbc_enable;
wire sbc_clear;
wire enable_timer;
wire packet_done;
wire start_bit_detected;

wire shift_strobe;

wire stop_bit;
wire [7:0] packet_data;

rx_data_buff BUF(.clk(clk), .n_rst(n_rst), .load_buffer(load_buffer), .packet_data(packet_data), .data_read(data_read), .rx_data(rx_data), .data_ready(data_ready), .overrun_error(overrun_error));

sr_9bit SR9(.clk(clk), .n_rst(n_rst), .shift_strobe(shift_strobe), .serial_in(serial_in), .data_size(data_size), .packet_data(packet_data), .stop_bit(stop_bit));

start_bit_det SBD(.clk(clk), .n_rst(n_rst), .serial_in(serial_in), .start_bit_detected(start_bit_detected));

stop_bit_chk SBC(.clk(clk), .n_rst(n_rst), .sbc_clear(sbc_clear), .sbc_enable(sbc_enable), .stop_bit(stop_bit), .framing_error(framing_error));

rcu RCU(.clk(clk), .n_rst(n_rst), .start_bit_detected(start_bit_detected), .packet_done(packet_done), .framing_error(framing_error), .sbc_clear(sbc_clear), .sbc_enable(sbc_enable), .load_buffer(load_buffer), .enable_timer(enable_timer));

timer TMR(.clk(clk), .n_rst(n_rst), .enable_timer(enable_timer), .shift_enable(shift_strobe), .packet_done(packet_done), .bit_period (bit_period), .data_size(data_size));

endmodule
