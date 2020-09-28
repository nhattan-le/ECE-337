// $Id: $
// File name:   mealy.sv
// Created:     9/28/2020
// Author:      Victor Le
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: Mealy Machine 1101 Detector

module mealy
(
   input wire clk,
   input wire n_rst,
   input wire i,
   output reg o
);

reg [1:0] next_state;
reg [1:0] state;

localparam S0 = 2'b00;
localparam S1 = 2'b01;
localparam S2 = 2'b10;
localparam S3 = 2'b11;



always_ff @ (posedge clk, negedge n_rst) begin
   if(n_rst == 1'b0) begin
       state <= S0;
   end
   else begin
       state <= next_state;
   end
end

always_comb begin
   next_state = state;
   
   case(state)
   S0:
   begin
     if (i == 1'b1) begin
        next_state = S1;
     end
     else begin
        next_state = S0;
     end
   end
   S1:
   begin
     if (i == 1) begin
        next_state = S2;
     end
     else begin
        next_state = S0;
     end 
   end
   S2:
   begin
     if (i == 1) begin
        next_state = S2;
     end
     else begin
        next_state = S3;
     end 
   end
   S3:
   begin
     if (i == 1) begin
        next_state = S1;
     end
     else begin
        next_state = S0;
     end 
   end
   default:
   begin
      next_state = S0;
   end
   endcase
end

always_comb begin
   o = 1'b0;
   
   case(state)
   S0:
   begin
      if (i == 1'b1) begin
        o = 1'b0;
     end
     else begin
        o = 1'b0;
     end
   end
   S1:
   begin
      if (i == 1'b1) begin
        o = 1'b0;
     end
     else begin
        o = 1'b0;
     end
   end
   S2:
   begin
      if (i == 1'b1) begin
        o = 1'b0;
     end
     else begin
        o = 1'b0;
     end
   end
   S3:
   begin
      if (i == 1'b1) begin
        o = 1'b1;
     end
     else begin
        o = 1'b0;
     end
   end
   default:
   begin
      o = 1'b0;
   end
   endcase
end





endmodule