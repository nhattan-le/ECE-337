// $Id: $
// File name:   moore.sv
// Created:     9/27/2020
// Author:      Victor Le
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: Moore 1101 Dector Design

module moore 
(
   input wire clk,
   input wire n_rst,
   input wire i,
   output reg o
);

reg [2:0] next_state;
reg [2:0] state;

localparam S0 = 3'b000;
localparam S1 = 3'b001;
localparam S2 = 3'b010;
localparam S3 = 3'b011;
localparam S4 = 3'b100;



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
        next_state = S4;
     end
     else begin
        next_state = S0;
     end 
   end
   S4:
   begin
     if (i == 1) begin
        next_state = S2;
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
      o = 1'b0;
   end
   S1:
   begin
      o = 1'b0;
   end
   S2:
   begin
      o = 1'b0;
   end
   S3:
   begin
      o = 1'b0;
   end
   S4:
   begin
      o = 1'b1;
   end
   default:
   begin
      o = 1'b0;
   end
   endcase
end





endmodule
