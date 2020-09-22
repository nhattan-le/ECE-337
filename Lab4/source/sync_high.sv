// $Id: $
// File name:   sync_high.sv
// Created:     9/22/2020
// Author:      Victor Le
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: Reset to Logic High Sync


module sync_high 
(
   input wire clk,
   input wire n_rst,
   input wire async_in,
   output wire sync_out
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
      flop_a <= async_in;
      flop_b <= flop_a;
   end
end

assign sync_out = flop_b;

endmodule