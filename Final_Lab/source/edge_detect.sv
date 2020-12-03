// $Id: $
// File name:   edge_detect.sv
// Created:     11/30/2020
// Author:      Victor Le
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: edge detect

module edge_detect
(
  input wire clk,
  input wire n_rst,
  input wire d_plus_sync,
  output reg d_edge
);

  reg d_sync_ff;
  
  always @ (negedge n_rst, posedge clk) begin
    if (1'b0 == n_rst)
    begin
      d_sync_ff <= 1'b1; // Reset value to idle line value
    end
    else
    begin
      d_sync_ff  <= d_plus_sync;
    end
  end
  
  // Output logic
  assign d_edge = d_plus_sync ^ d_sync_ff;

endmodule