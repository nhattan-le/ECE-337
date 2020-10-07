// $Id: $
// File name:   rcu.sv
// Created:     10/4/2020
// Author:      Victor Le
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: current mode of operation for receiver block


module rcu
(
  input wire clk,
  input wire n_rst,
  input wire start_bit_detected,
  input wire packet_done,
  input wire framing_error,
  output reg sbc_clear,
  output reg sbc_enable,
  output reg load_buffer,
  output reg enable_timer
);
localparam IDLE = 2'b00;
localparam FRAME_START = 2'b01;
localparam PACKET_DONE = 2'b10;
localparam ERROR_FRAME_CHECK = 2'b11;

reg [1:0] state;
reg [1:0] next_state;

always_ff @ (posedge clk,negedge n_rst) begin
   if(n_rst == 1'b0) begin
      state <= IDLE;
   end
   else begin
      state <= next_state;
   end
end

always_comb begin
   next_state = state;
   
   case(state)
   IDLE:
   begin
      if(start_bit_detected) begin
          next_state = FRAME_START;
      end
   end
   FRAME_START:
   begin
      if(packet_done) begin
         next_state = PACKET_DONE;
      end
   end
   PACKET_DONE:
   begin
      next_state = ERROR_FRAME_CHECK;
   end
   ERROR_FRAME_CHECK:
   begin
      next_state = IDLE;
   end
   default:
   begin
      next_state = IDLE;
   end
   endcase 
end

always_comb begin
   sbc_clear = 1'b0;
   sbc_enable = 1'b0;
   load_buffer = 1'b0;
   enable_timer = 1'b0;
   
   case(state)
   IDLE:
   begin
      sbc_enable = 1'b0;
      load_buffer = 1'b0;
      enable_timer = 1'b0;
      if(start_bit_detected) begin
         sbc_clear = 1'b1;
      end
   end
   FRAME_START:
   begin
      sbc_clear = 1'b0;
      sbc_enable = 1'b0;
      load_buffer = 1'b0;
      enable_timer = 1'b1;
   end
   PACKET_DONE:
   begin
      sbc_clear = 1'b0;
      sbc_enable = 1'b1;
      enable_timer = 1'b1;
      load_buffer = 1'b0;
   end
   ERROR_FRAME_CHECK:
   begin
      sbc_clear = 1'b0;
      sbc_enable = 1'b0;
      enable_timer = 1'b0;
      if(!framing_error) begin
         load_buffer = 1'b1;
      end
      else begin
         load_buffer = 1'b0;
      end
   end
   default:
   begin
      sbc_clear = 1'b0;
      sbc_enable = 1'b0;
      load_buffer = 1'b0;
      enable_timer = 1'b0;
   end
   endcase 
end




endmodule