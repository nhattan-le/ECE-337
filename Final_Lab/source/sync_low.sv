// $Id: $
// File name:   sync_low.sv
// Created:     11/30/2020
// Author:      Victor Le
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: sync low

module sync_low
(
  input wire clk,
  input wire n_rst,
  input wire d_minus,
  output reg d_minus_sync
);

reg flop_a;
reg flop_b;

always_ff @ (posedge clk, negedge n_rst) 
begin : flop_block
   if(1'b0 == n_rst) begin
      flop_a <= 1'b0;
      flop_b <= 1'b0;
   end 
   else begin
      flop_a <= d_minus;
      flop_b <= flop_a;
   end
end

assign d_minus_sync = flop_b;


endmodule