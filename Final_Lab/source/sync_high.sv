// $Id: $
// File name:   sync_high.sv
// Created:     11/30/2020
// Author:      Victor Le
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: sync high


module sync_high
(
  input wire clk,
  input wire n_rst,
  input wire d_plus,
  output reg d_plus_sync
);

reg flop_a;
reg flop_b;

always_ff @ (posedge clk, negedge n_rst) 
begin : flop_block
   if(1'b0 == n_rst) begin
      flop_a <= 1'b1;
      flop_b <= 1'b1;
   end 
   else begin
      flop_a <= d_plus;
      flop_b <= flop_a;
   end
end

assign d_plus_sync = flop_b;


endmodule