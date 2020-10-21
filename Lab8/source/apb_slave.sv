// $Id: $
// File name:   apb_slave.sv
// Created:     10/19/2020
// Author:      Victor Le
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: apb slave

module apb_slave
(
   input wire clk,
   input wire n_rst,
   input wire [7:0] rx_data,
   input wire data_ready,
   input wire overrun_error,
   input wire framing_error,
   output reg data_read,
   input wire psel,
   input wire [2:0] paddr,
   input wire penable,
   input wire pwrite,
   input wire [7:0] pwdata,
   output reg [7:0] prdata,
   output reg pslverr,
   output reg [3:0] data_size,
   output reg [13:0] bit_period
);
reg [6:0][7:0] apb_regs;
reg [7:0] read_data, write_data;
reg [1:0] state, next_state;
reg data_read_int;
localparam START = 2'b00;
localparam READ = 2'b01;
localparam WRITE = 2'b11;

always_ff @ (posedge clk, negedge n_rst) begin
    if(n_rst == 1'b0) begin
        state <= START;
    end
    else begin
        state <= next_state;
    end
end

always_ff @ (posedge clk, negedge n_rst) begin
    if(n_rst == 1'b0) begin

	apb_regs[2] <= 8'h0;
	apb_regs[3] <= 8'h0;
	apb_regs[4] <= 8'h0;
        read_data <= 8'h0;
//	data_read <= 1'b0;
    end
    else begin

	if((paddr[2:0] == 3'b010) & psel & penable & pwrite) begin
	   apb_regs[2] <= pwdata;
	end
	if((paddr[2:0] == 3'b011) & psel & penable & pwrite) begin
	   apb_regs[3] <= pwdata;
	end
	if((paddr[2:0] == 3'b100) & psel & penable & pwrite) begin
	   apb_regs[4] <= pwdata;
	end
	
	if(psel & !pwrite) begin
	   read_data <= apb_regs[paddr[2:0]];
	end
//	data_read <= 1'b1;
    end
end
always_comb  begin

        apb_regs[0] <= {7'b0, data_ready};
	apb_regs[1] <= {6'b0, overrun_error, framing_error};

	apb_regs[5] <= 8'h0;
	apb_regs[6] <= rx_data[7:0];
	
end

assign bit_period[7:0] = apb_regs[2];
assign bit_period[13:8] = apb_regs[3][5:0];
assign data_size[3:0] = apb_regs[4][3:0];
assign prdata = read_data;

always_comb begin
   next_state = state;

   case(state)
   START: 
   begin
      if(psel & !pwrite) begin
          next_state = READ;
      end
      else if(psel & pwrite) begin
          next_state = WRITE;
      end
   end
   READ:
   begin 
      if(penable) begin
         next_state = START;
      end
   end
   WRITE:
   begin
      if(penable) begin
         next_state = START;
      end
   end
   default:
   begin
      next_state = START;
   end
   endcase
end

always_comb begin
   pslverr = 1'b0;
   data_read = 1'b0;

   case(state)
   START: 
   begin
      pslverr = 1'b0;
      data_read = 1'b0;
   end
   READ:
   begin 
      if(paddr[2:0] == 3'b111) begin
         pslverr = 1'b1;
      end
      if(paddr[2:0] == 3'b110) begin
         data_read = 1'b1;
      end
   end
   WRITE:
   begin
      if((paddr[2:0] == 3'b000) | (paddr[2:0] == 3'b001) | (paddr[2:0] == 3'b101) | (paddr[2:0] == 3'b110) | (paddr[2:0] == 3'b111)) begin
         pslverr = 1'b1;
      end
      data_read = 1'b0;
   end
   default:
   begin
      pslverr = 1'b0;
      data_read = 1'b0;
   end
   endcase
end



endmodule