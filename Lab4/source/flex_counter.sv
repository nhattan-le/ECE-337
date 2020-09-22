// $Id: $
// File name:   flex_counter.sv
// Created:     9/22/2020
// Author:      Victor Le
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: Flex Counter design

module flex_counter
#(
  parameter NUM_CNT_BITS = 4
)
(
  input wire clk,
  input wire n_rst,
  input wire clear,
  input wire count_enable,
  input wire [(NUM_CNT_BITS-1):0] rollover_val,
  output wire [(NUM_CNT_BITS-1):0] count_out,
  output wire rollover_flag
);

reg [(NUM_CNT_BITS - 1):0] counter;
wire [(NUM_CNT_BITS - 1):0] nxt_count;

always_ff @ (posedge clk, negedge n_rst) 
begin
   if(n_rst == 1'b0) begin
      counter <= 'h0;
   end
   else begin
      if(clear == 1'b1) begin
         counter <= 'h0;
      end
      else if(count_enable == 1'b1) begin
         counter <= nxt_count;
      end
   end
end


assign nxt_count = (rollover_val == counter ? 'h0 : (counter + 'h1));
assign rollover_flag = (counter == rollover_val);

endmodule