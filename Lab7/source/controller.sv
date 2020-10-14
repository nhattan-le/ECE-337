// $Id: $
// File name:   controller.sv
// Created:     10/12/2020
// Author:      Victor Le
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: controller

module controller
(
   input wire clk,
   input wire n_rst,
   input wire dr,
   input wire lc,
   input wire overflow,
   output reg cnt_up,
   output reg clear,
   output reg modwait,
   output reg [2:0] op,
   output reg [3:0] src1,
   output reg [3:0] src2,
   output reg [3:0] dest,
   output reg err
);

localparam IDLE = 5'b00000;
localparam STORE = 5'b00001;
localparam ZERO = 5'b00010;
localparam SORT1 = 5'b00011;
localparam SORT2 = 5'b00100;
localparam SORT3 = 5'b00101;
localparam SORT4 = 5'b00110;
localparam MUL1 = 5'b00111;
localparam ADD1 = 5'b01000;
localparam MUL2 = 5'b01001;
localparam SUB1 = 5'b01010;
localparam MUL3 = 5'b01011;
localparam ADD2 = 5'b01100;
localparam MUL4 = 5'b01101;
localparam SUB2 = 5'b01110;
localparam EIDLE = 5'b01111;
localparam STORE_LC = 5'b10000;

reg [4:0] state;
reg [4:0] next_state;
reg [1:0] lc_count;
reg lc_delay;
reg modwait_int;
flex_counter #2 LC_COUNT(.clk(clk), .n_rst(n_rst), .count_enable(lc_delay), .clear(), .count_out(lc_count), .rollover_val(2'b11), .rollover_flag());

always_ff @ (posedge clk, negedge n_rst) begin
    if(n_rst == 1'b0) begin
        lc_delay <= 1'b0;
    end
    else begin
       lc_delay <= lc;
    end
end

always_ff @ (posedge clk, negedge n_rst) begin
    if(n_rst == 1'b0) begin
        modwait <= 1'b0;
    end
    else begin
       modwait <= modwait_int;
    end
end

always_ff @ (posedge clk, negedge n_rst) begin
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
      if(lc) begin
         next_state = STORE_LC;
      end
      else if(dr) begin 
         next_state = STORE;
      end
   end
   STORE:
   begin
      if(dr) begin 
         next_state = ZERO;
      end
      else begin
         next_state = EIDLE;
      end
   end
   STORE_LC:
   begin
      if(!lc) begin 
         next_state = IDLE;
      end
      else begin
         next_state = EIDLE;
      end
   end
   ZERO: 
   begin
      next_state = SORT1;
   end
   SORT1: 
   begin
      next_state = SORT2;
   end
   SORT2: 
   begin
      next_state = SORT3;
   end
   SORT3: 
   begin
      next_state = SORT4;
   end
   SORT4: 
   begin
      next_state = MUL1;
   end
   MUL1: 
   begin
      next_state = ADD1;
   end
   ADD1: 
   begin
      if(overflow) begin 
         next_state = EIDLE;
      end
      else begin
         next_state = MUL2;
      end
   end
   MUL2: 
   begin
      next_state = SUB1;
   end
   SUB1: 
   begin
      if(overflow) begin 
         next_state = EIDLE;
      end
      else begin
         next_state = MUL3;
      end
   end
   MUL3: 
   begin
      next_state = ADD2;
   end
   ADD2: 
   begin
      if(overflow) begin 
         next_state = EIDLE;
      end
      else begin
         next_state = MUL4;
      end
   end
   MUL4: 
   begin
      next_state = SUB2;
   end
   SUB2: 
   begin
      if(overflow) begin 
         next_state = EIDLE;
      end
      else begin
         next_state = IDLE;
      end
   end
   EIDLE: 
   begin
      if(dr) begin
         next_state = IDLE;
      end
      else 
      begin
         next_state = EIDLE;
      end
   end
   default:
   begin
      next_state = IDLE;
   end
   endcase
end

always_comb begin
   op = 3'b000;
   src1 = 4'b0000;
   src2 = 4'b0000;
   dest = 4'b0000;
   modwait_int = 1'b0;
   err = 1'b0;

   case(state)
   IDLE:
   begin
      op = 3'b000;
      src1 = 4'b0000;
      src2 = 4'b0000;
      dest = 4'b0000;
      modwait_int = 1'b0;
      err = 1'b0;
   end
   STORE:
   begin 
      op = 3'b010;
      src1 = 4'b0000;
      src2 = 4'b0000;
      dest = 4'b0101;
      modwait_int = 1'b1;
      err = 1'b0;
   end
   STORE_LC:
   begin
      op = 3'b011;
      src1 = 4'b0000;
      src2 = 4'b0000;
      case(lc_count)
      2'b00:
      begin
         dest = 4'b0111;
      end
      2'b01:
      begin
         dest = 4'b1000;
      end
      2'b10:
      begin
         dest = 4'b1001;
      end
      2'b11:
      begin
         dest = 4'b1010;
      end
      endcase
      modwait_int = 1'b1;
      err = 1'b0;
   end
   ZERO: 
   begin 
      op = 3'b101;
      src1 = 4'b0000;
      src2 = 4'b0000;
      dest = 4'b0000;
      modwait_int = 1'b1;
      err = 1'b0;
   end
   SORT1: 
   begin 
      op = 3'b001;
      src1 = 4'b0010;
      src2 = 4'b0000;
      dest = 4'b0001;
      modwait_int = 1'b1;
      err = 1'b0;
   end
   SORT2: 
   begin 
      op = 3'b001;
      src1 = 4'b0011;
      src2 = 4'b0000;
      dest = 4'b0010;
      modwait_int = 1'b1;
      err = 1'b0;
   end
   SORT3: 
   begin 
      op = 3'b001;
      src1 = 4'b0100;
      src2 = 4'b0000;
      dest = 4'b0011;
      modwait_int = 1'b1;
      err = 1'b0;
   end
   SORT4: 
   begin 
      op = 3'b001;
      src1 = 4'b0101;
      src2 = 4'b0000;
      dest = 4'b0100;
      modwait_int = 1'b1;
      err = 1'b0;
   end
   MUL1: 
   begin 
      op = 3'b110;
      src1 = 4'b0001;
      src2 = 4'b1010;
      dest = 4'b0110;
      modwait_int = 1'b1;
      err = 1'b0;
   end
   ADD1: 
   begin 
      op = 3'b100;
      src1 = 4'b0000;
      src2 = 4'b0110;
      dest = 4'b0000;
      modwait_int = 1'b1;
      err = 1'b0;
   end
   MUL2: 
   begin 
      op = 3'b110;
      src1 = 4'b0010;
      src2 = 4'b1001;
      dest = 4'b0110;
      modwait_int = 1'b1;
      err = 1'b0;
   end
   SUB1: 
   begin 
      op = 3'b101;
      src1 = 4'b0000;
      src2 = 4'b0110;
      dest = 4'b0000;
      modwait_int = 1'b1;
      err = 1'b0;
   end
   MUL3: 
   begin 
      op = 3'b110;
      src1 = 4'b0011;
      src2 = 4'b1000;
      dest = 4'b0110;
      modwait_int = 1'b1;
      err = 1'b0;
   end
   ADD2: 
   begin 
      op = 3'b100;
      src1 = 4'b0000;
      src2 = 4'b0110;
      dest = 4'b0000;
      modwait_int = 1'b1;
      err = 1'b0;
   end
   MUL4: 
   begin 
      op = 3'b110;
      src1 = 4'b0100;
      src2 = 4'b0111;
      dest = 4'b0110;
      modwait_int = 1'b1;
      err = 1'b0;
   end
   SUB2: 
   begin 
      op = 3'b101;
      src1 = 4'b0000;
      src2 = 4'b0110;
      dest = 4'b0000;
      modwait_int = 1'b1;
      err = 1'b0;
   end
   EIDLE: 
   begin 
      op = 3'b000;
      src1 = 4'b0000;
      src2 = 4'b0000;
      dest = 4'b0000;
      modwait_int = 1'b0;
      err = 1'b1;
   end
   default:
   begin
      op = 3'b000;
      src1 = 4'b0000;
      src2 = 4'b0000;
      dest = 4'b0000;
      modwait_int = 1'b0;
      err = 1'b0;
   end
   endcase
end

endmodule

   
   
