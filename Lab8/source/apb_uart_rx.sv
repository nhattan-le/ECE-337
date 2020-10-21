// $Id: $
// File name:   apb_uart_rx.sv
// Created:     10/19/2020
// Author:      Victor Le
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: apb uart rx

module apb_uart_rx
(
   input wire clk,
   input wire n_rst,
   input wire psel,
   input wire [2:0] paddr,
   input wire penable,
   input wire pwrite,
   input wire [7:0] pwdata,
   input wire serial_in,
   output reg [7:0] prdata,
   output reg pslverr
);
wire [7:0] rx_data;
wire data_ready;
wire overrun_error;
wire data_read;
wire framing_error;
wire [3:0] data_size;
wire [13:0] bit_period;


apb_slave APB1(.clk(clk), .n_rst(n_rst), .rx_data(rx_data), .data_ready(data_ready), .overrun_error(overrun_error), .framing_error(framing_error), .data_read(data_read), .psel(psel), .paddr(paddr), .penable(penable), .pwrite(pwrite), .pwdata(pwdata), .prdata(prdata), .pslverr(pslverr), .data_size(data_size), .bit_period(bit_period));
rcv_block UART1(.clk(clk), .n_rst(n_rst), .serial_in(serial_in), .data_read(data_read), .rx_data(rx_data), .data_ready(data_ready), .overrun_error(overrun_error), .framing_error(framing_error), .data_size(data_size), .bit_period(bit_period));

endmodule