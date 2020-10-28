// $Id: $
// File name:   coefficient_loader.sv
// Created:     10/25/2020
// Author:      Victor Le
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: Manages loading set of coeff

module coefficient_loader
(
   input wire clk,
   input wire n_reset,
   input wire new_coefficient_set,
   input wire modwait,
   output reg busy,
   output reg load_coeff,
   output reg [1:0] coefficient_num,
   output reg clear_new_coeff
);

localparam IDLE = 4'b0000;
localparam LOAD_F0 = 4'b0001;
localparam DONE_F0 = 4'b0010;
localparam LOAD_F1 = 4'b0011;
localparam DONE_F1 = 4'b0100;
localparam LOAD_F2 = 4'b0101;
localparam DONE_F2 = 4'b0110;
localparam LOAD_F3 = 4'b0111;
localparam DONE_F3 = 4'b1000;

reg [3:0] state, next_state;

reg busy_int;
wire edge_detect;
reg coeff_set_ff;

assign busy = busy_int | edge_detect;


always_ff @ (posedge clk, negedge n_reset) begin
    if(n_reset == 1'b0) begin
        state <= IDLE;
        coeff_set_ff <= 1'b0;
    end
    else begin
        state <= next_state;
        coeff_set_ff <= new_coefficient_set;
    end
end

assign edge_detect = !coeff_set_ff && new_coefficient_set;

always_comb begin
   next_state = state;

   case(state)
   IDLE:
   begin
      if(edge_detect) begin
         next_state = LOAD_F0;
      end 
   end
   LOAD_F0:
   begin
      next_state = DONE_F0;
   end
   DONE_F0:
   begin
      if(!modwait) begin
         next_state = LOAD_F1;
      end 
   end
   LOAD_F1:
   begin
      next_state = DONE_F1;
   end
   DONE_F1:
   begin
      if(!modwait) begin
         next_state = LOAD_F2;
      end 
   end
   LOAD_F2:
   begin
      next_state = DONE_F2;
   end
   DONE_F2:
   begin
      if(!modwait) begin
         next_state = LOAD_F3;
      end 
   end
   LOAD_F3:
   begin
      next_state = DONE_F3;
   end
   DONE_F3:
   begin
      if(!modwait) begin
         next_state = IDLE;
      end 
   end
   default:
   begin
      next_state = IDLE;
   end
   endcase
end

always_comb begin
   load_coeff = 1'b0;
   coefficient_num = 2'b00;
   busy_int = 1'b0;
   clear_new_coeff = 1'b0;

   case(state)
   IDLE:
   begin
      load_coeff = 1'b0;
      coefficient_num = 2'b00;
      busy_int = 1'b0;
   clear_new_coeff = 1'b0;
   end
   LOAD_F0:
   begin
      load_coeff = 1'b1;
      coefficient_num = 2'b00;
      busy_int = 1'b1;
   clear_new_coeff = 1'b0;
   end
   DONE_F0:
   begin
      load_coeff = 1'b0;
      coefficient_num = 2'b00;
      busy_int = 1'b1;
   clear_new_coeff = 1'b0;
   end
   LOAD_F1:
   begin
      load_coeff = 1'b1;
      coefficient_num = 2'b01;
      busy_int = 1'b1;
   clear_new_coeff = 1'b0;
   end
   DONE_F1:
   begin
      load_coeff = 1'b0;
      coefficient_num = 2'b01;
      busy_int = 1'b1;
   clear_new_coeff = 1'b0;
   end
   LOAD_F2:
   begin
      load_coeff = 1'b1;
      coefficient_num = 2'b10;
      busy_int = 1'b1;
   clear_new_coeff = 1'b0;
   end
   DONE_F2:
   begin
      load_coeff = 1'b0;
      coefficient_num = 2'b10;
      busy_int = 1'b1;
   clear_new_coeff = 1'b0;
   end
   LOAD_F3:
   begin
      load_coeff = 1'b1;
      coefficient_num = 2'b11;
      busy_int = 1'b1;
   clear_new_coeff = 1'b0;
   end
   DONE_F3:
   begin
      load_coeff = 1'b0;
      coefficient_num = 2'b11;
      busy_int = 1'b1;
   clear_new_coeff = 1'b1;
   end
   default:
   begin
      load_coeff = 1'b0;
      coefficient_num = 2'b00;
      busy_int = 1'b0;
   clear_new_coeff = 1'b0;
   end
   endcase
end

endmodule