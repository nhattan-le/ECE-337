// $Id: $
// File name:   usb_rcv_block.sv
// Created:     11/30/2020
// Author:      Victor Le
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: usb reciever wrapper

module usb_rcv_block
(
  input wire clk,
  input wire nrst,
  input wire d_plus,
  input wire d_minus,
  output reg [7:0] r_data,
  output reg full,
  output reg empty,
  input wire r_enable,
  output reg rcving,
  output reg r_error,
  output reg [3:0] pid
);

reg d_plus_sync;
reg d_minus_sync;
reg d_edge;
reg shift_enable;
reg shift_enable2;
reg d_stuff;
reg d_orig;
reg eop;
reg idle;
reg byte_received;
reg [7:0] rcv_data;
reg w_enable;
reg crc_init;
reg crc5_error;
reg crc16_error;


sync_low sl1(.clk(clk), .n_rst(nrst), .d_minus(d_minus), .d_minus_sync(d_minus_sync));
sync_high sh1(.clk(clk), .n_rst(nrst), .d_plus(d_plus), .d_plus_sync(d_plus_sync));

edge_detect ed1(.clk(clk), .n_rst(nrst), .d_plus_sync(d_plus_sync), .d_edge(d_edge));
eop_detect eop1(.clk(clk), .n_rst(nrst), .d_plus_sync(d_plus_sync), .d_minus_sync(d_minus_sync), .eop(eop));

timer TM1(.clk(clk), .n_rst(nrst), .d_edge(d_edge), .d_stuff(d_stuff), .idle(idle), .shift_enable(shift_enable), .shift_enable2(shift_enable2), .byte_received(byte_received));
decoder DC1(.clk(clk), .nrst(nrst), .d_plus_sync(d_plus_sync), .shift_enable(shift_enable), .d_orig(d_orig));

crc5_checker CR5(.clk(clk), .nrst(nrst), .d_orig(d_orig), .shift_enable(shift_enable2), .crc_init(crc_init), .crc5_error(crc5_error));
crc16_checker CR16(.clk(clk), .nrst(nrst), .d_orig(d_orig), .shift_enable(shift_enable2), .crc_init(crc_init), .crc16_error(crc16_error));

sbd BSD(.clk(clk), .nrst(nrst), .id_orig(!d_orig), .shift_enable(shift_enable), .d_stuff(d_stuff));
sr_16bit SR16(.clk(clk), .n_rst(nrst), .shift_strobe(shift_enable2), .serial_in(d_orig), .packet_data(rcv_data), .old_packet_data());

rcu RCU(.clk(clk), .n_rst(nrst), .shift_enable(shift_enable), .byte_received(byte_received), .crc5_error(crc5_error), .crc16_error(crc16_error), .d_edge(d_edge), .eop(eop), .idle(idle),.rcv_data(rcv_data), .crc_init(crc_init), .w_enable(w_enable), .rcving(rcving), .r_error(r_error), .pid(pid));
tx_fifo FIF(.clk(clk), .n_rst(nrst), .write_data(rcv_data), .write_enable(w_enable), .read_enable(r_enable), .read_data(r_data), .fifo_empty(empty), .fifo_full(full));



endmodule