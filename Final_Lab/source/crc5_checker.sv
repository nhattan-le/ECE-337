// $Id: $
// File name:   crc5_checker.sv
// Created:     11/29/2020
// Author:      Victor Le
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: 5 bit crc checker


module crc5_checker
(
  input wire clk,
  input wire nrst,
  input wire d_orig,
  input wire shift_enable,
  input wire crc_init,
  output reg crc5_error
);

reg [4:0] CRC;
reg inv;

assign inv = d_orig ^ CRC[4];
always @(posedge clk, negedge nrst) begin
      if (!nrst) begin
         CRC = 5'h1F;                                  
         end
      else if (crc_init) begin
      CRC = 5'h1F;
      end
      else if (shift_enable) begin
         CRC[4] = CRC[3];
         CRC[3] = CRC[2];
         CRC[2] = CRC[1]^ inv;
         CRC[1] = CRC[0];
         CRC[0] = inv;
         end
      
end

assign crc5_error = (CRC != 16'hC) ? 1'b1 : 1'b0;

endmodule