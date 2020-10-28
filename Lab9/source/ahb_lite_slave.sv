// $Id: $
// File name:   ahb_lite_slave.sv
// Created:     10/24/2020
// Author:      Victor Le
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: ahb lite slave module

module ahb_lite_slave
(
  input wire clk,
  input wire n_rst,
  output reg [15:0] sample_data,
  output reg data_ready,
  output reg new_coefficient_set,
  input wire [1:0] coefficient_num,
  output reg [15:0] fir_coefficient,
  input wire modwait,
  input wire [15:0] fir_out,
  input wire err,
  input wire hsel,
  input wire [3:0] haddr,
  input wire hsize,
  input wire [1:0] htrans,
  input wire hwrite,
  input wire clear_new_coeff,
  input wire [15:0] hwdata,
  output reg [15:0] hrdata,
  output reg hresp
);

reg [15:0][7:0] ahb_regs, next_ahb_regs;
reg [15:0] read_data, write_data;
reg [1:0] state, next_state;
reg [3:0] write_req_addr, read_req_addr;
reg write_req, read_req, write_req_size, read_req_size;
reg data_ready_int, data_ready_int_reg, data_ready_int_reg2;
wire busy;

localparam IDLE = 2'b00;
localparam ADDR = 2'b01;
localparam DATA_ADR = 2'b10;
localparam DATA = 2'b11;

always_ff @ (posedge clk, negedge n_rst) begin
    if(n_rst == 1'b0) begin
        state <= ADDR;
    end
    else begin
        state <= next_state;
    end
end

always_ff @ (posedge clk, negedge n_rst) begin
    if(n_rst == 1'b0) begin

	ahb_regs[0] <= 8'h0;
	ahb_regs[1] <= 8'h0;
	ahb_regs[2] <= 8'h0;
	ahb_regs[3] <= 8'h0;
	ahb_regs[4] <= 8'h0;
	ahb_regs[5] <= 8'h0;
	ahb_regs[6] <= 8'h0;
	ahb_regs[7] <= 8'h0;
	ahb_regs[8] <= 8'h0;
	ahb_regs[9] <= 8'h0;
	ahb_regs[10] <= 8'h0;
	ahb_regs[11] <= 8'h0;
	ahb_regs[12] <= 8'h0;
	ahb_regs[13] <= 8'h0;
	ahb_regs[14] <= 8'h0;
	ahb_regs[15] <= 8'h0;
        read_data <= 16'h0;
	write_req <= 1'b0;
	write_req_addr <= 4'h0;
	write_req_size <= 1'b0;
	data_ready_int_reg <= 1'b0;
	data_ready_int_reg2 <= 1'b0;


    end
    else begin
	
	ahb_regs[0] <= next_ahb_regs[0];
	ahb_regs[1] <= next_ahb_regs[1];
	ahb_regs[2] <= next_ahb_regs[2];
	ahb_regs[3] <= next_ahb_regs[3];
	ahb_regs[4] <= next_ahb_regs[4];
	ahb_regs[5] <= next_ahb_regs[5];
	ahb_regs[6] <= next_ahb_regs[6];
	ahb_regs[7] <= next_ahb_regs[7];
	ahb_regs[8] <= next_ahb_regs[8];
	ahb_regs[9] <= next_ahb_regs[9];
	ahb_regs[10] <= next_ahb_regs[10];
	ahb_regs[11] <= next_ahb_regs[11];
	ahb_regs[12] <= next_ahb_regs[12];
	ahb_regs[13] <= next_ahb_regs[13];
	ahb_regs[14] <= next_ahb_regs[14];
	ahb_regs[15] <= next_ahb_regs[15];	
	if(read_req) begin
	   if (read_req_size) begin
	   read_data <= {next_ahb_regs[read_req_addr + 1], next_ahb_regs[read_req_addr]};
		end
	   else begin
	   read_data <= {8'h00, next_ahb_regs[read_req_addr[3:0]]};
		end
	end
	write_req <= hsel & hwrite & htrans == 2'b10;
	write_req_addr <= haddr[3:0];
	write_req_size <= hsize;
	data_ready_int_reg <= data_ready_int;
	data_ready_int_reg2 <= data_ready_int_reg;
    end
end
// registers value for read only registers
always_comb  begin
	next_ahb_regs <= ahb_regs;
        next_ahb_regs[0] <= {7'b0, busy};
        next_ahb_regs[1] <= {7'b0, err};
	next_ahb_regs[2] <= fir_out[7:0];
	next_ahb_regs[3] <= fir_out[15:8];
	if(write_req & (write_req_addr[3:0] == 4'd4)) begin
	   next_ahb_regs[4] <= write_data[7:0];
	   if (write_req_size)  next_ahb_regs[5] <= write_data[15:8];
	end
	if(write_req & (write_req_addr[3:0] == 4'd5)) begin
	   next_ahb_regs[5] <= write_data[7:0];
	end
	if(write_req & (write_req_addr[3:0] == 4'd6)) begin
	   next_ahb_regs[6] <= write_data;
	   if (write_req_size)  next_ahb_regs[7] <= write_data[15:8];
	end
	if(write_req & (write_req_addr[3:0] == 4'd7)) begin
	   next_ahb_regs[7] <= write_data;
	end
	if(write_req & (write_req_addr[3:0] == 4'd8)) begin
	   next_ahb_regs[8] <= write_data[7:0];
	   if (write_req_size) next_ahb_regs[9] <= write_data[15:8];
	end
	if(write_req & (write_req_addr[3:0] == 4'd9)) begin
	   next_ahb_regs[9] <= write_data[7:0];
	end
	if(write_req & (write_req_addr[3:0] == 4'd10)) begin
	   next_ahb_regs[10] <= write_data[7:0];
	   if (write_req_size) next_ahb_regs[11] <= write_data[15:8];
	end
	if(write_req & (write_req_addr[3:0] == 4'd11)) begin
	   next_ahb_regs[11] <= write_data[7:0];
	end
	if(write_req & (write_req_addr[3:0] == 4'd12)) begin
	   next_ahb_regs[12] <= write_data[7:0];
           if (write_req_size) next_ahb_regs[13] <= write_data[15:8];
	end
	if(write_req & (write_req_addr[3:0] == 4'd13)) begin
	   next_ahb_regs[13] <= write_data[7:0];
	end
	if(write_req & (write_req_addr[3:0] == 4'd14)) begin
	   next_ahb_regs[14] <= write_data[7:0];
		end
	else begin
		if (clear_new_coeff) begin
	   next_ahb_regs[14][0] <= 0;
		end
	end
end


assign sample_data = {ahb_regs[5], ahb_regs[4]};
assign fir_coefficient = coefficient_num == 2'b00 ? {ahb_regs[7], ahb_regs[6]} : coefficient_num == 2'b01 ? {ahb_regs[9],ahb_regs[8]} : coefficient_num == 2'b10 ? {ahb_regs[11],ahb_regs[10]} : {ahb_regs[13],ahb_regs[12]};
assign new_coefficient_set = ahb_regs[14][0] | next_ahb_regs[14][0];
assign hrdata = read_data;
assign write_data = hwdata;
assign read_req = hsel & !hwrite & htrans == 2'b10;
assign read_req_addr = haddr[3:0];
assign read_req_size = hsize;
assign data_ready = data_ready_int_reg | data_ready_int_reg2 | data_ready_int;
assign busy = modwait | data_ready;

always_comb begin
   next_state = state;

   case(state)
   ADDR:
   begin 
      if(hsel & (htrans == 2'b10)) begin
          next_state = DATA;
      end
      else begin
          next_state = ADDR;
      end
   end
   DATA_ADR:
   begin
      if(hsel & (htrans == 2'b10)) begin
          next_state = DATA_ADR;
      end
      else begin
          next_state = DATA;
      end
   end
   DATA:
   begin
     if(hsel & (htrans == 2'b10)) begin
          next_state = DATA_ADR;
      end
     else begin
          next_state = ADDR;
   	end
   end
   default:
   begin
      next_state = ADDR;
   end
   endcase
end

always_comb begin
   hresp = 1'b0;
   data_ready_int = 1'b0;

   case(state)
   ADDR:
   begin 
      if ((hsel & hwrite & (htrans == 2'b10) &(haddr[3:1] == 3'b000 || haddr[3:1] == 3'b001  )) ||(hsel & (htrans == 2'b10) & (haddr[3:0] == 4'b1111))) begin //write to read only addr or access unknown addr
	hresp = 1'b1;
	end
      data_ready_int = 1'b0;
   end
   DATA_ADR:
   begin
     if ((hsel & hwrite & (htrans == 2'b10) &(haddr[3:1] == 3'b000 || haddr[3:1] == 3'b001)) ||(hsel & (htrans == 2'b10) & (haddr[3:0] == 4'b1111))) begin //write to read only addr or access unknown addr
	hresp = 1'b1;
	end
      if (write_req & (write_req_addr[3:0] == 4'b0100)) begin //write to data sample register
      data_ready_int = 1'b1;
	end
   end
   DATA:
   begin
     if ((hsel & hwrite & (htrans == 2'b10) &(haddr[3:1] == 3'b000 || haddr[3:1] == 3'b001  )) ||(hsel & (htrans == 2'b10) & (haddr[3:0] == 4'b1111))) begin //write to read only addr or access unknown addr
	hresp = 1'b1;
	end
      if (write_req & (write_req_addr[3:0] == 4'b0100)) begin //write to data sample register
      data_ready_int = 1'b1;
   	end
   end
   default:
   begin
      hresp = 1'b0;
      data_ready_int = 1'b0;
   end
   endcase
end

endmodule

