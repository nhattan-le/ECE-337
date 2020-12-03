// $Id: $
// File name:   eop_detect.sv
// Created:     11/30/2020
// Author:      Victor Le
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: end of packet detect


module eop_detect
(
  input wire clk,
  input wire n_rst,
  input wire d_minus_sync,
  input wire d_plus_sync,
  output reg eop
);

  reg d_sync_ff;
  reg d_sync_ff_m;
  
  always @ (negedge n_rst, posedge clk)
  begin
    if(1'b0 == n_rst)
    begin
      d_sync_ff <= 1'b1; // Reset value to idle line value
      d_sync_ff_m <= 1'b0;
    end
    else
    begin
      d_sync_ff  <= d_plus_sync;
      d_sync_ff_m <= d_minus_sync;
    end
  end
  
  // Output logic
  assign eop = ((d_sync_ff == 1'b0) & (d_sync_ff_m == 1'b0)) ? 1'b1 : 1'b0;

endmodule