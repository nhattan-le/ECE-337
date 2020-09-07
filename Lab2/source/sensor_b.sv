// $Id: $
// File name:   sensor_b.sv
// Created:     9/6/2020
// Author:      Victor Le
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: Behavioral Version of Sensor Error Detection

module sensor_b
(
  input wire [3:0] sensors,
  output reg error
);

reg XY;
reg WY;
reg Z;

always_comb
begin
  error = 0;
  XY = 0;
  WY = 0;
  Z = 0;
  if((sensors[2] & sensors[1]) == 1'b1)
  begin
    XY = 1'b1;
  end
  if((sensors[3] & sensors[1]) == 1'b1)
  begin
    WY = 1'b1;
  end
  if(sensors[0] == 1'b1)
  begin
    Z = 1'b1;
  end
  if(XY | WY | Z)
  begin
    error = 1'b1;
  end
end

endmodule