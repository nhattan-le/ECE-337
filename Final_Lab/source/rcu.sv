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
  input wire shift_enable,
  input wire byte_received,
  input wire crc5_error,
  input wire crc16_error,
  input wire d_edge,
  input wire eop,
  input wire [7:0] rcv_data,
  output reg crc_init,
  output reg w_enable,
  output reg rcving,
  output reg r_error,
  output reg [3:0] pid,
  output reg idle
);
localparam IDLE = 3'b000;
localparam SYNC = 3'b001;
localparam PID = 3'b010;
localparam DATA = 3'b011;
localparam WAIT = 3'b100;
localparam ERROR = 3'b101;
localparam ERROR_WAIT = 3'b110;
localparam TOKEN = 3'b111;

reg [2:0] state;
reg [2:0] next_state;
reg valid_pid;
reg data_pid;
reg token_pid;
reg ack_pid;
reg byte_received_pulse;
reg byte_received_ff;
reg [3:0] pid_next;
reg r_error_next;
reg rcving_next;

//only need one pulse from byte_received
assign byte_received_pulse = ~byte_received_ff & byte_received;

always_ff @ (posedge clk,negedge n_rst) begin
   if(n_rst == 1'b0) begin
      state <= IDLE;
      byte_received_ff <= 1'b0;
      pid <= 'h1;
      r_error <= 1'b0;
      rcving <= 1'b0;
   end
   else begin
      state <= next_state;
      byte_received_ff <= byte_received;
      pid <= pid_next;
      r_error <= r_error_next;
      rcving <= rcving_next;
   end
end
//validates the PID Packet
assign valid_pid = rcv_data == 8'hE1 ? 1'b1 : rcv_data == 8'h69 ? 1'b1 : rcv_data == 8'hD2 ? 1'b1 : rcv_data == 8'h5A ? 1'b1 : rcv_data == 8'hC3 ? 1'b1 : rcv_data == 8'h4B ? 1'b1 : 1'b0;
assign data_pid = (rcv_data[3:0] == 4'h3) || (rcv_data[3:0] == 4'hB);
assign token_pid = (rcv_data[3:0] == 4'h1) || (rcv_data[3:0] == 4'h9);
assign ack_pid = (rcv_data[3:0] == 4'h2) || (rcv_data[3:0] == 4'hA);
always_comb begin
   next_state = state;
   
   case(state)
   IDLE:
   begin
      if(d_edge) begin
          next_state = SYNC;
      end
   end
   SYNC:
   begin
      if(byte_received_pulse  & (rcv_data == 8'h80)) begin
         next_state = PID;
      end
      else if(byte_received_pulse  & (rcv_data != 8'h80)) begin
         next_state = ERROR;
      end
   end
   PID:
   begin
      if(byte_received_pulse & valid_pid & data_pid)  begin
         next_state = DATA ;
      end
      else if(byte_received_pulse  & valid_pid & token_pid) begin
         next_state = TOKEN ;
      end
   
     else if(byte_received_pulse & valid_pid & ack_pid)  begin
         next_state = WAIT ;
      end
      else if(byte_received_pulse  & !valid_pid) begin
         next_state = ERROR ;
      end
   end

   TOKEN:
   begin
      if(eop & !crc5_error) begin
         next_state = WAIT ;
	end
	else if (eop & crc5_error) begin
	 next_state = ERROR;      
      end
   end
   DATA:
   begin
      if(eop & !crc16_error) begin
         next_state = WAIT ;
	end
	else if (eop & crc16_error) begin
	 next_state = ERROR;      
      end
   end
   ERROR:
   begin
      if(eop) begin
         next_state = ERROR_WAIT ;
      end
   end
   ERROR_WAIT:
   begin
      if(d_edge) begin
         next_state = IDLE ;
      end
   end
   WAIT:
   begin
      if(d_edge) begin
         next_state = IDLE ;
      end
   end
   default:
   begin
      next_state = IDLE;
   end
   endcase 
end

always_comb begin
  
  crc_init = 1'b0;
  w_enable = 1'b0;
  rcving_next = 1'b0;
  r_error_next = r_error;
  pid_next = pid;
  idle = 1'b1;
   
   case(state)
   IDLE:
   begin
     crc_init = 1'b0;
     w_enable = 1'b0;
     rcving_next = 1'b0;
     if(d_edge) begin
        r_error_next = 1'b0;
     end
   end
   SYNC:
   begin
     crc_init = 1'b0;
     w_enable = 1'b0;
     rcving_next = 1'b1;
     r_error_next = 1'b0;
     pid_next = 4'b0001;
     idle = 1'b0;
   end
   PID:
   begin
     crc_init = 1'b1;
     w_enable = 1'b0;
     rcving_next = 1'b1;
     idle = 1'b0;
     if(byte_received_pulse ) begin
       pid_next = rcv_data[3:0];
     end
   end
   DATA:
   begin
     crc_init = 1'b0;
     if(byte_received_pulse) begin
        w_enable = 1'b1;
     end
     rcving_next = 1'b1;
     idle = 1'b0;
   end
   TOKEN:
   begin
     crc_init = 1'b0;
     w_enable = 1'b0;
     rcving_next = 1'b1;

     idle = 1'b0;
   end
   ERROR:
   begin
     crc_init = 1'b0;
     w_enable = 1'b0;
     rcving_next = 1'b1;
     r_error_next = 1'b1;
     pid_next = 4'h1;
     idle = 1'b0;
   end
   ERROR_WAIT:
   begin
     crc_init = 1'b0;
     w_enable = 1'b0;
     rcving_next = 1'b0;
     idle = 1'b0;
   end
   WAIT:
   begin
     crc_init = 1'b0;
     w_enable = 1'b0;
     rcving_next = 1'b1;
     idle = 1'b0;
   end
   default:
   begin
     crc_init = 1'b0;
     w_enable = 1'b0;
     rcving_next = 1'b0;
     r_error_next = r_error;
     pid_next = pid;
     idle = 1'b1;
   end
   endcase 
end




endmodule