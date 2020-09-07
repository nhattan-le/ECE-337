// $Id: $
// File name:   sensor_s.sv
// Created:     9/2/2020
// Author:      Victor Le
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: structural verilog for sensor dectector kmap

module sensor_s
(
  input wire [3:0] sensors,
  output wire error
);
//sensors[3] & [2] - W & X
//sensors[1] - Y
//sensors[0] - Z
wire combine_sen1;
wire combine_sen2;
wire error_1;

AND2X1 A1(.A(sensors[3]), .B(sensors[1]), .Y(combine_sen1));
AND2X1 A2(.A(sensors[1]), .B(sensors[2]), .Y(combine_sen2));
OR2X1 B1(.A(sensors[0]), .B(combine_sen1), .Y(error_1));
OR2X1 B2(.A(error_1), .B(combine_sen2), .Y(error));

endmodule