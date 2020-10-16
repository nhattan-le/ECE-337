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

localparam STORE_F0 = 5'b10000;
localparam WAIT_F1 = 5'b10001;
localparam STORE_F1 = 5'b10010;
localparam WAIT_F2 = 5'b10011;
localparam STORE_F2 = 5'b10100;
localparam WAIT_F3 = 5'b10101;
localparam STORE_F3 = 5'b10110;



reg [4:0] state;
reg [4:0] next_state;
reg [1:0] lc_count;
reg lc_delay;
reg modwait_int;
reg [2:0] op_int;
reg [3:0] src1_int;
reg [3:0] src2_int;
reg [3:0] dest_int;
reg err_int;
reg cnt_up_int;
reg clear_int;


always_ff @ (posedge clk, negedge n_rst) begin
    if(n_rst == 1'b0) begin
        modwait <= 1'b0;
        op <= 3'b000;
        src1 <= 4'b0000;
        src2 <= 4'b0000;
        dest <= 4'b0000;
        err <= 1'b0;
        cnt_up <= 1'b0;
        clear <= 1'b0;
    end
    else begin
       modwait <= modwait_int;
       op <= op_int;
       src1 <= src1_int;
       src2 <= src2_int;
       dest <= dest_int;
       err <= err_int;
       cnt_up <= cnt_up_int;
       clear <= clear_int;
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
         next_state = STORE_F0;
      end
      else if(dr) begin 
         next_state = STORE;
      end
   end
   STORE_F0:
   begin
      if(!lc) begin
          next_state = WAIT_F1;
      end
   end
   WAIT_F1:
   begin
      if(lc) begin
          next_state = STORE_F1;
      end
   end
   STORE_F1:
   begin
       if(!lc) begin
           next_state = WAIT_F2;
       end
   end
   WAIT_F2:
   begin
      if(lc) begin
          next_state = STORE_F2;
      end
   end
   STORE_F2:
   begin
       if(!lc) begin
           next_state = WAIT_F3;
       end
   end
   WAIT_F3:
   begin
      if(lc) begin
          next_state = STORE_F3;
      end
   end
   STORE_F3:
   begin
      if(!lc) begin
          next_state = IDLE;
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
   op_int = 3'b000;
   src1_int = 4'b0000;
   src2_int = 4'b0000;
   dest_int = 4'b0000;
   err_int = 1'b0;
   cnt_up_int = 1'b0;
   clear_int = 1'b0;
   modwait_int = 1'b0;

   case(next_state)
   IDLE:
   begin
      op_int = 3'b000;
      src1_int = 4'b0000;
      src2_int = 4'b0000;
      dest_int = 4'b0000;
      err_int = 1'b0;
      modwait_int = 1'b0;
   end
   STORE_F0:
   begin
      op_int = 3'b011;
      dest_int = 4'b0111;
      modwait_int = 1'b1;
   end
   WAIT_F1:
   begin
      op_int = 3'b000;
      dest_int = 4'b0000;
      modwait_int = 1'b0;
   end
   STORE_F1:
   begin
      op_int = 3'b011;
      dest_int = 4'b1000;
      modwait_int = 1'b1;
   end
   WAIT_F2:
   begin
      op_int = 3'b000;
      dest_int = 4'b0000;
      modwait_int = 1'b0;
   end
   STORE_F2:
   begin
      op_int = 3'b011;
      dest_int = 4'b1001;
      modwait_int = 1'b1;
   end
   WAIT_F3:
   begin
      op_int = 3'b000;
      dest_int = 4'b0000;
      modwait_int = 1'b0;
   end
   STORE_F3:
   begin
      op_int = 3'b011;
      dest_int = 4'b1010;
      modwait_int = 1'b1;
      clear_int = 1'b1;
   end
   
   STORE:
   begin 
      op_int = 3'b010;
      src1_int = 4'b0000;
      src2_int = 4'b0000;
      dest_int = 4'b0101;
      err_int = 1'b0;
      modwait_int = 1'b1;
   end
   ZERO: 
   begin 
      op_int = 3'b101;
      src1_int = 4'b0000;
      src2_int = 4'b0000;
      dest_int = 4'b0000;
      err_int = 1'b0;
      modwait_int = 1'b1;
   end
   SORT1: 
   begin 
      op_int = 3'b001;
      src1_int = 4'b0010;
      src2_int = 4'b0000;
      dest_int = 4'b0001;
      err_int = 1'b0;
      modwait_int = 1'b1;
   end
   SORT2: 
   begin 
      op_int = 3'b001;
      src1_int = 4'b0011;
      src2_int = 4'b0000;
      dest_int = 4'b0010;
      err_int = 1'b0;
      modwait_int = 1'b1;
   end
   SORT3: 
   begin 
      op_int = 3'b001;
      src1_int = 4'b0100;
      src2_int = 4'b0000;
      dest_int = 4'b0011;
      err_int = 1'b0;
      modwait_int = 1'b1;
   end
   SORT4: 
   begin 
      op_int = 3'b001;
      src1_int = 4'b0101;
      src2_int = 4'b0000;
      dest_int = 4'b0100;
      err_int = 1'b0;
      modwait_int = 1'b1;
   end
   MUL1: 
   begin 
      op_int = 3'b110;
      src1_int = 4'b0001;
      src2_int = 4'b1010;
      dest_int = 4'b0110;
      err_int = 1'b0;
      modwait_int = 1'b1;
   end
   ADD1: 
   begin 
      op_int = 3'b100;
      src1_int = 4'b0000;
      src2_int = 4'b0110;
      dest_int = 4'b0000;
      err_int = 1'b0;
      modwait_int = 1'b1;
   end
   MUL2: 
   begin 
      op_int = 3'b110;
      src1_int = 4'b0010;
      src2_int = 4'b1001;
      dest_int = 4'b0110;
      err_int = 1'b0;
      modwait_int = 1'b1;
   end
   SUB1: 
   begin 
      op_int = 3'b101;
      src1_int = 4'b0000;
      src2_int = 4'b0110;
      dest_int = 4'b0000;
      err_int = 1'b0;
      modwait_int = 1'b1;
   end
   MUL3: 
   begin 
      op_int = 3'b110;
      src1_int = 4'b0011;
      src2_int = 4'b1000;
      dest_int = 4'b0110;
      err_int = 1'b0;
      modwait_int = 1'b1;
   end
   ADD2: 
   begin 
      op_int = 3'b100;
      src1_int = 4'b0000;
      src2_int = 4'b0110;
      dest_int = 4'b0000;
      err_int = 1'b0;
      modwait_int = 1'b1;
   end
   MUL4: 
   begin 
      op_int = 3'b110;
      src1_int = 4'b0100;
      src2_int = 4'b0111;
      dest_int = 4'b0110;
      err_int = 1'b0;
      modwait_int = 1'b1;
   end
   SUB2: 
   begin 
      op_int = 3'b101;
      src1_int = 4'b0000;
      src2_int = 4'b0110;
      dest_int = 4'b0000;
      err_int = 1'b0;
      cnt_up_int = 1'b1;
      modwait_int = 1'b1;
   end
   EIDLE: 
   begin 
      op_int = 3'b000;
      src1_int = 4'b0000;
      src2_int = 4'b0000;
      dest_int = 4'b0000;
      err_int = 1'b1;
      modwait_int = 1'b0;
   end
   default:
   begin
      op_int = 3'b000;
      src1_int = 4'b0000;
      src2_int = 4'b0000;
      dest_int = 4'b0000;
      err_int = 1'b0;
      cnt_up_int = 1'b0;
      clear_int = 1'b0;
      modwait_int = 1'b0;
   end
   endcase
end

endmodule

   
   
