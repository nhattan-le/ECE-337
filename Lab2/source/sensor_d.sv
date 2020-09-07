// $Id: $
// File name:   sensor_d.sv
// Created:     9/6/2020
// Author:      Victor Le
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: Dataflow style for Error Detector Design

module sensor_d
(
  input wire [3:0] sensors,
  output wire error
);

//sensors[3] & [2] - W & X
//sensors[1] - Y
//sensors[0] - Z

wire combine_XY;
wire combine_WY;
wire error_Z;

assign combine_XY = ((sensors[2] & sensors[1]) == 1'b1) ? 1'b1 : 1'b0;
assign combine_WY = ((sensors[3] & sensors[1]) == 1'b1) ? 1'b1 : 1'b0;
assign error_Z = (sensors[0] == 1'b1) ? 1'b1 : 1'b0;

assign error = combine_XY | combine_WY | error_Z;

endmodule