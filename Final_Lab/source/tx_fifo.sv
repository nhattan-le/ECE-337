// $Id: $
// File name:   tx_fifo.sv
// Created:     11/30/2020
// Author:      Victor Le
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: fifo

module tx_fifo
(
 input  wire clk,
 input  wire n_rst,
 input  wire read_enable,
 output wire [7:0] read_data,
 output wire fifo_empty,
 output wire fifo_full,
 input  wire write_enable,
 input  wire [7:0] write_data
);

endmodule