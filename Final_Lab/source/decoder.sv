// $Id: $
// File name:   decoder.sv
// Created:     11/29/2020
// Author:      Victor Le
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: NRZI Decoder


module decoder
(
  input wire clk,
  input wire nrst,
  input wire d_plus_sync,
  input wire shift_enable,
  output reg d_orig
);

reg [1:0] FF_logic;
wire [1:0] next_FF_logic;


always_ff @ (posedge clk, negedge nrst) begin
  if (nrst == 1'b0) begin
     FF_logic <= 2'b11;
  end
  else begin
     FF_logic <= next_FF_logic;
  end
end


assign next_FF_logic[0] = shift_enable == 1'b1 ? d_plus_sync : FF_logic[0]; 
assign next_FF_logic[1] = shift_enable == 1'b1 ? FF_logic[0] : FF_logic[1]; 

assign d_orig = ~(next_FF_logic[0] ^ next_FF_logic[1]);

endmodule