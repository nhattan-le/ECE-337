// $Id: $
// File name:   crc16_checker.sv
// Created:     11/29/2020
// Author:      Victor Le
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: crc 16 bit checker

module crc16_checker
(
  input wire clk,
  input wire nrst,
  input wire d_orig,
  input wire shift_enable,
  input wire crc_init,
  output reg crc16_error
);

reg [15:0] CRC;
reg inv;
assign inv = d_orig ^ CRC[15];
always @(posedge clk, negedge nrst) begin
      if (!nrst) begin
         CRC = 16'hFFFF;                                  
         end
      else if (crc_init) begin
      CRC = 16'hFFFF;
      end
      else if (shift_enable) begin
         CRC[15] = CRC[14] ^ inv;
         CRC[14] = CRC[13];
         CRC[13] = CRC[12];
         CRC[12] = CRC[11];
         CRC[11] = CRC[10];
         CRC[10] = CRC[9];
         CRC[9] = CRC[8];
         CRC[8] = CRC[7];
         CRC[7] = CRC[6];
         CRC[6] = CRC[5];
         CRC[5] = CRC[4];
         CRC[4] = CRC[3];
         CRC[3] = CRC[2];
         CRC[2] = CRC[1]^inv;
         CRC[1] = CRC[0];
         CRC[0] = inv;
         end
end

assign crc16_error = (CRC != 16'h800D) ? 1'b1 : 1'b0;

endmodule