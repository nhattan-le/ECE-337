// $Id: $
// File name:   ahb_lite_fir_filter.sv
// Created:     10/26/2020
// Author:      Victor Le
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: ahb fir filter wrapper
module ahb_lite_fir_filter
(
   input wire clk,
   input wire n_rst,
   input wire hsel,
   input wire [3:0] haddr,
   input wire hsize,
   input wire [1:0] htrans,
   input wire hwrite,
   input wire [15:0] hwdata,
   output reg [15:0] hrdata,
   output wire hresp 
);
wire [15:0] fir_out; //fir results
wire modwait;
wire err;
wire [15:0] sample_data;
wire data_ready;
wire [15:0] fir_coefficient;
wire new_coefficient_set;
wire [1:0] coefficient_num;
wire clear_new_coeff;

wire load_coeff;
wire modwait_int, busy;

ahb_lite_slave AHB(.clk(clk), .n_rst(n_rst),
                    // FIR Filter Operation signals
                    .fir_out(fir_out),
                    .modwait(modwait),
                    .err(err),
                    .sample_data(sample_data),
                    .data_ready(data_ready),
                    .fir_coefficient(fir_coefficient),
                    .new_coefficient_set(new_coefficient_set),
                    .coefficient_num(coefficient_num),
		    .clear_new_coeff(clear_new_coeff),
                    // AHB-Lite-Slave bus signals
                    .hsel(hsel),
                    .htrans(htrans),
                    .haddr(haddr),
                    .hsize(hsize),
                    .hwrite(hwrite),
                    .hwdata(hwdata),
                    .hrdata(hrdata),
                    .hresp(hresp));

fir_filter FIL(.clk(clk), .n_reset(n_rst), .sample_data(sample_data), .fir_coefficient(fir_coefficient), .load_coeff(load_coeff), .data_ready(data_ready), .one_k_samples(), .modwait(modwait_int), .fir_out(fir_out), .err(err));

coefficient_loader COF(.clk(clk), .n_reset(n_rst), .new_coefficient_set(new_coefficient_set), .modwait(modwait_int), .load_coeff(load_coeff), .coefficient_num(coefficient_num), .busy(busy), .clear_new_coeff(clear_new_coeff));

assign modwait = busy | modwait_int;



endmodule