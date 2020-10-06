/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : K-2015.06-SP1
// Date      : Tue Oct  6 00:48:12 2020
/////////////////////////////////////////////////////////////


module rx_data_buff ( clk, n_rst, load_buffer, packet_data, data_read, rx_data, 
        data_ready, overrun_error );
  input [7:0] packet_data;
  output [7:0] rx_data;
  input clk, n_rst, load_buffer, data_read;
  output data_ready, overrun_error;
  wire   n30, n31, n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n15, n17, n19,
         n21, n23, n25, n27, n29;

  DFFSR \rx_data_reg[7]  ( .D(n15), .CLK(clk), .R(1'b1), .S(n_rst), .Q(
        rx_data[7]) );
  DFFSR \rx_data_reg[6]  ( .D(n17), .CLK(clk), .R(1'b1), .S(n_rst), .Q(
        rx_data[6]) );
  DFFSR \rx_data_reg[5]  ( .D(n19), .CLK(clk), .R(1'b1), .S(n_rst), .Q(
        rx_data[5]) );
  DFFSR \rx_data_reg[4]  ( .D(n21), .CLK(clk), .R(1'b1), .S(n_rst), .Q(
        rx_data[4]) );
  DFFSR \rx_data_reg[3]  ( .D(n23), .CLK(clk), .R(1'b1), .S(n_rst), .Q(
        rx_data[3]) );
  DFFSR \rx_data_reg[2]  ( .D(n25), .CLK(clk), .R(1'b1), .S(n_rst), .Q(
        rx_data[2]) );
  DFFSR \rx_data_reg[1]  ( .D(n27), .CLK(clk), .R(1'b1), .S(n_rst), .Q(
        rx_data[1]) );
  DFFSR \rx_data_reg[0]  ( .D(n29), .CLK(clk), .R(1'b1), .S(n_rst), .Q(
        rx_data[0]) );
  DFFSR data_ready_reg ( .D(n31), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        data_ready) );
  DFFSR overrun_error_reg ( .D(n30), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        overrun_error) );
  INVX1 U3 ( .A(n1), .Y(n15) );
  MUX2X1 U4 ( .B(rx_data[7]), .A(packet_data[7]), .S(load_buffer), .Y(n1) );
  INVX1 U5 ( .A(n2), .Y(n17) );
  MUX2X1 U6 ( .B(rx_data[6]), .A(packet_data[6]), .S(load_buffer), .Y(n2) );
  INVX1 U7 ( .A(n3), .Y(n19) );
  MUX2X1 U8 ( .B(rx_data[5]), .A(packet_data[5]), .S(load_buffer), .Y(n3) );
  INVX1 U9 ( .A(n4), .Y(n21) );
  MUX2X1 U10 ( .B(rx_data[4]), .A(packet_data[4]), .S(load_buffer), .Y(n4) );
  INVX1 U11 ( .A(n5), .Y(n23) );
  MUX2X1 U12 ( .B(rx_data[3]), .A(packet_data[3]), .S(load_buffer), .Y(n5) );
  INVX1 U13 ( .A(n6), .Y(n25) );
  MUX2X1 U14 ( .B(rx_data[2]), .A(packet_data[2]), .S(load_buffer), .Y(n6) );
  INVX1 U15 ( .A(n7), .Y(n27) );
  MUX2X1 U16 ( .B(rx_data[1]), .A(packet_data[1]), .S(load_buffer), .Y(n7) );
  INVX1 U17 ( .A(n8), .Y(n29) );
  MUX2X1 U18 ( .B(rx_data[0]), .A(packet_data[0]), .S(load_buffer), .Y(n8) );
  OAI21X1 U19 ( .A(data_read), .B(n9), .C(n10), .Y(n31) );
  INVX1 U20 ( .A(load_buffer), .Y(n10) );
  INVX1 U21 ( .A(data_ready), .Y(n9) );
  NOR2X1 U22 ( .A(data_read), .B(n11), .Y(n30) );
  AOI21X1 U23 ( .A(data_ready), .B(load_buffer), .C(overrun_error), .Y(n11) );
endmodule


module flex_stp_sr_NUM_BITS9_SHIFT_MSB0 ( clk, n_rst, serial_in, shift_enable, 
        parallel_out );
  output [8:0] parallel_out;
  input clk, n_rst, serial_in, shift_enable;
  wire   n13, n15, n17, n19, n21, n23, n25, n27, n29, n1, n2, n3, n4, n5, n6,
         n7, n8, n9;

  DFFSR \shift_reg_reg[0]  ( .D(n29), .CLK(clk), .R(1'b1), .S(n_rst), .Q(
        parallel_out[8]) );
  DFFSR \shift_reg_reg[1]  ( .D(n27), .CLK(clk), .R(1'b1), .S(n_rst), .Q(
        parallel_out[7]) );
  DFFSR \shift_reg_reg[2]  ( .D(n25), .CLK(clk), .R(1'b1), .S(n_rst), .Q(
        parallel_out[6]) );
  DFFSR \shift_reg_reg[3]  ( .D(n23), .CLK(clk), .R(1'b1), .S(n_rst), .Q(
        parallel_out[5]) );
  DFFSR \shift_reg_reg[4]  ( .D(n21), .CLK(clk), .R(1'b1), .S(n_rst), .Q(
        parallel_out[4]) );
  DFFSR \shift_reg_reg[5]  ( .D(n19), .CLK(clk), .R(1'b1), .S(n_rst), .Q(
        parallel_out[3]) );
  DFFSR \shift_reg_reg[6]  ( .D(n17), .CLK(clk), .R(1'b1), .S(n_rst), .Q(
        parallel_out[2]) );
  DFFSR \shift_reg_reg[7]  ( .D(n15), .CLK(clk), .R(1'b1), .S(n_rst), .Q(
        parallel_out[1]) );
  DFFSR \shift_reg_reg[8]  ( .D(n13), .CLK(clk), .R(1'b1), .S(n_rst), .Q(
        parallel_out[0]) );
  INVX1 U2 ( .A(n1), .Y(n29) );
  MUX2X1 U3 ( .B(parallel_out[8]), .A(serial_in), .S(shift_enable), .Y(n1) );
  INVX1 U4 ( .A(n2), .Y(n27) );
  MUX2X1 U5 ( .B(parallel_out[7]), .A(parallel_out[8]), .S(shift_enable), .Y(
        n2) );
  INVX1 U6 ( .A(n3), .Y(n25) );
  MUX2X1 U7 ( .B(parallel_out[6]), .A(parallel_out[7]), .S(shift_enable), .Y(
        n3) );
  INVX1 U8 ( .A(n4), .Y(n23) );
  MUX2X1 U9 ( .B(parallel_out[5]), .A(parallel_out[6]), .S(shift_enable), .Y(
        n4) );
  INVX1 U10 ( .A(n5), .Y(n21) );
  MUX2X1 U11 ( .B(parallel_out[4]), .A(parallel_out[5]), .S(shift_enable), .Y(
        n5) );
  INVX1 U12 ( .A(n6), .Y(n19) );
  MUX2X1 U13 ( .B(parallel_out[3]), .A(parallel_out[4]), .S(shift_enable), .Y(
        n6) );
  INVX1 U14 ( .A(n7), .Y(n17) );
  MUX2X1 U15 ( .B(parallel_out[2]), .A(parallel_out[3]), .S(shift_enable), .Y(
        n7) );
  INVX1 U16 ( .A(n8), .Y(n15) );
  MUX2X1 U17 ( .B(parallel_out[1]), .A(parallel_out[2]), .S(shift_enable), .Y(
        n8) );
  INVX1 U18 ( .A(n9), .Y(n13) );
  MUX2X1 U19 ( .B(parallel_out[0]), .A(parallel_out[1]), .S(shift_enable), .Y(
        n9) );
endmodule


module sr_9bit ( clk, n_rst, shift_strobe, serial_in, packet_data, stop_bit );
  output [7:0] packet_data;
  input clk, n_rst, shift_strobe, serial_in;
  output stop_bit;


  flex_stp_sr_NUM_BITS9_SHIFT_MSB0 ninebit_sr ( .clk(clk), .n_rst(n_rst), 
        .serial_in(serial_in), .shift_enable(shift_strobe), .parallel_out({
        stop_bit, packet_data}) );
endmodule


module start_bit_det ( clk, n_rst, serial_in, start_bit_detected, 
        new_package_detected );
  input clk, n_rst, serial_in;
  output start_bit_detected, new_package_detected;
  wire   start_bit_detected, old_sample, new_sample, sync_phase, n4;
  assign new_package_detected = start_bit_detected;

  DFFSR sync_phase_reg ( .D(serial_in), .CLK(clk), .R(1'b1), .S(n_rst), .Q(
        sync_phase) );
  DFFSR new_sample_reg ( .D(sync_phase), .CLK(clk), .R(1'b1), .S(n_rst), .Q(
        new_sample) );
  DFFSR old_sample_reg ( .D(new_sample), .CLK(clk), .R(1'b1), .S(n_rst), .Q(
        old_sample) );
  NOR2X1 U6 ( .A(new_sample), .B(n4), .Y(start_bit_detected) );
  INVX1 U7 ( .A(old_sample), .Y(n4) );
endmodule


module stop_bit_chk ( clk, n_rst, sbc_clear, sbc_enable, stop_bit, 
        framing_error );
  input clk, n_rst, sbc_clear, sbc_enable, stop_bit;
  output framing_error;
  wire   n5, n2, n3;

  DFFSR framing_error_reg ( .D(n5), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        framing_error) );
  NOR2X1 U3 ( .A(sbc_clear), .B(n2), .Y(n5) );
  MUX2X1 U4 ( .B(framing_error), .A(n3), .S(sbc_enable), .Y(n2) );
  INVX1 U5 ( .A(stop_bit), .Y(n3) );
endmodule


module rcu ( clk, n_rst, start_bit_detected, packet_done, framing_error, 
        sbc_clear, sbc_enable, load_buffer, enable_timer );
  input clk, n_rst, start_bit_detected, packet_done, framing_error;
  output sbc_clear, sbc_enable, load_buffer, enable_timer;
  wire   N23, n13, n14, n3, n4, n5, n6, n7, n8, n9, n10;
  wire   [1:0] state;
  assign sbc_clear = N23;

  DFFSR \state_reg[0]  ( .D(n14), .CLK(clk), .R(n_rst), .S(1'b1), .Q(state[0])
         );
  DFFSR \state_reg[1]  ( .D(n13), .CLK(clk), .R(n_rst), .S(1'b1), .Q(state[1])
         );
  MUX2X1 U5 ( .B(n3), .A(n4), .S(n5), .Y(n14) );
  OAI21X1 U6 ( .A(framing_error), .B(n6), .C(n4), .Y(n3) );
  OAI22X1 U7 ( .A(n7), .B(n8), .C(n9), .D(n5), .Y(n13) );
  OAI22X1 U8 ( .A(packet_done), .B(n9), .C(start_bit_detected), .D(n10), .Y(n5) );
  NAND2X1 U9 ( .A(n4), .B(n6), .Y(n10) );
  INVX1 U10 ( .A(framing_error), .Y(n8) );
  NOR2X1 U11 ( .A(framing_error), .B(n7), .Y(load_buffer) );
  NAND2X1 U12 ( .A(n7), .B(n9), .Y(enable_timer) );
  NAND2X1 U13 ( .A(state[0]), .B(n6), .Y(n9) );
  INVX1 U14 ( .A(sbc_enable), .Y(n7) );
  NOR2X1 U15 ( .A(n6), .B(state[0]), .Y(sbc_enable) );
  NOR2X1 U16 ( .A(n6), .B(n4), .Y(N23) );
  INVX1 U17 ( .A(state[0]), .Y(n4) );
  INVX1 U18 ( .A(state[1]), .Y(n6) );
endmodule


module flex_counter_1 ( clk, n_rst, clear, count_enable, rollover_val, 
        count_out, rollover_flag );
  input [3:0] rollover_val;
  output [3:0] count_out;
  input clk, n_rst, clear, count_enable;
  output rollover_flag;
  wire   n28, n29, n30, n31, n1, n2, n3, n4, n5, n10, n11, n12, n13, n14, n15,
         n16, n17, n18, n19, n20, n21, n22, n23, n24, n25, n26;

  DFFSR \counter_reg[0]  ( .D(n31), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        count_out[0]) );
  DFFSR \counter_reg[1]  ( .D(n30), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        count_out[1]) );
  DFFSR \counter_reg[2]  ( .D(n29), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        count_out[2]) );
  DFFSR \counter_reg[3]  ( .D(n28), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        count_out[3]) );
  OAI22X1 U7 ( .A(n1), .B(n2), .C(n3), .D(n4), .Y(n31) );
  OAI22X1 U8 ( .A(n5), .B(n2), .C(n10), .D(n4), .Y(n30) );
  XNOR2X1 U9 ( .A(n1), .B(n11), .Y(n5) );
  NOR2X1 U10 ( .A(rollover_flag), .B(n10), .Y(n11) );
  OAI22X1 U11 ( .A(n12), .B(n4), .C(n13), .D(n2), .Y(n29) );
  XNOR2X1 U12 ( .A(n14), .B(n15), .Y(n13) );
  OAI22X1 U13 ( .A(n16), .B(n2), .C(n17), .D(n4), .Y(n28) );
  NAND2X1 U14 ( .A(n2), .B(n18), .Y(n4) );
  NAND2X1 U15 ( .A(count_enable), .B(n18), .Y(n2) );
  INVX1 U16 ( .A(clear), .Y(n18) );
  XOR2X1 U17 ( .A(n19), .B(n20), .Y(n16) );
  NOR2X1 U18 ( .A(rollover_flag), .B(n17), .Y(n20) );
  INVX1 U19 ( .A(count_out[3]), .Y(n17) );
  NAND2X1 U20 ( .A(n14), .B(n15), .Y(n19) );
  AND2X1 U21 ( .A(n1), .B(count_out[1]), .Y(n15) );
  NOR2X1 U22 ( .A(n3), .B(rollover_flag), .Y(n1) );
  NOR2X1 U23 ( .A(n12), .B(rollover_flag), .Y(n14) );
  INVX1 U24 ( .A(n21), .Y(rollover_flag) );
  NAND3X1 U25 ( .A(n22), .B(n23), .C(n24), .Y(n21) );
  NOR2X1 U26 ( .A(n25), .B(n26), .Y(n24) );
  XNOR2X1 U27 ( .A(rollover_val[1]), .B(n10), .Y(n26) );
  INVX1 U28 ( .A(count_out[1]), .Y(n10) );
  XNOR2X1 U29 ( .A(rollover_val[0]), .B(n3), .Y(n25) );
  INVX1 U30 ( .A(count_out[0]), .Y(n3) );
  XNOR2X1 U31 ( .A(count_out[2]), .B(rollover_val[2]), .Y(n23) );
  XNOR2X1 U32 ( .A(count_out[3]), .B(rollover_val[3]), .Y(n22) );
  INVX1 U33 ( .A(count_out[2]), .Y(n12) );
endmodule


module flex_counter_0 ( clk, n_rst, clear, count_enable, rollover_val, 
        count_out, rollover_flag );
  input [3:0] rollover_val;
  output [3:0] count_out;
  input clk, n_rst, clear, count_enable;
  output rollover_flag;
  wire   n1, n2, n3, n4, n5, n10, n11, n12, n13, n14, n15, n16, n17, n18, n19,
         n20, n21, n22, n23, n24, n25, n26, n32, n33, n34, n35;

  DFFSR \counter_reg[0]  ( .D(n32), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        count_out[0]) );
  DFFSR \counter_reg[1]  ( .D(n33), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        count_out[1]) );
  DFFSR \counter_reg[2]  ( .D(n34), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        count_out[2]) );
  DFFSR \counter_reg[3]  ( .D(n35), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        count_out[3]) );
  OAI22X1 U7 ( .A(n1), .B(n2), .C(n3), .D(n4), .Y(n32) );
  OAI22X1 U8 ( .A(n5), .B(n2), .C(n10), .D(n4), .Y(n33) );
  XNOR2X1 U9 ( .A(n1), .B(n11), .Y(n5) );
  NOR2X1 U10 ( .A(rollover_flag), .B(n10), .Y(n11) );
  OAI22X1 U11 ( .A(n12), .B(n4), .C(n13), .D(n2), .Y(n34) );
  XNOR2X1 U12 ( .A(n14), .B(n15), .Y(n13) );
  OAI22X1 U13 ( .A(n16), .B(n2), .C(n17), .D(n4), .Y(n35) );
  NAND2X1 U14 ( .A(n2), .B(n18), .Y(n4) );
  NAND2X1 U15 ( .A(count_enable), .B(n18), .Y(n2) );
  INVX1 U16 ( .A(clear), .Y(n18) );
  XOR2X1 U17 ( .A(n19), .B(n20), .Y(n16) );
  NOR2X1 U18 ( .A(rollover_flag), .B(n17), .Y(n20) );
  INVX1 U19 ( .A(count_out[3]), .Y(n17) );
  NAND2X1 U20 ( .A(n14), .B(n15), .Y(n19) );
  AND2X1 U21 ( .A(n1), .B(count_out[1]), .Y(n15) );
  NOR2X1 U22 ( .A(n3), .B(rollover_flag), .Y(n1) );
  NOR2X1 U23 ( .A(n12), .B(rollover_flag), .Y(n14) );
  INVX1 U24 ( .A(n21), .Y(rollover_flag) );
  NAND3X1 U25 ( .A(n22), .B(n23), .C(n24), .Y(n21) );
  NOR2X1 U26 ( .A(n25), .B(n26), .Y(n24) );
  XNOR2X1 U27 ( .A(rollover_val[1]), .B(n10), .Y(n26) );
  INVX1 U28 ( .A(count_out[1]), .Y(n10) );
  XNOR2X1 U29 ( .A(rollover_val[0]), .B(n3), .Y(n25) );
  INVX1 U30 ( .A(count_out[0]), .Y(n3) );
  XNOR2X1 U31 ( .A(count_out[2]), .B(rollover_val[2]), .Y(n23) );
  XNOR2X1 U32 ( .A(count_out[3]), .B(rollover_val[3]), .Y(n22) );
  INVX1 U33 ( .A(count_out[2]), .Y(n12) );
endmodule


module timer ( clk, n_rst, enable_timer, shift_enable, packet_done );
  input clk, n_rst, enable_timer;
  output shift_enable, packet_done;
  wire   n1, n2, n3, n4, n5, n6;
  wire   [3:0] shift_count;
  wire   [3:0] bit_count;

  flex_counter_1 shift_cnt ( .clk(clk), .n_rst(n_rst), .clear(n6), 
        .count_enable(enable_timer), .rollover_val({1'b1, 1'b0, 1'b1, 1'b0}), 
        .count_out(shift_count) );
  flex_counter_0 packet_done_cnt ( .clk(clk), .n_rst(n_rst), .clear(n6), 
        .count_enable(n5), .rollover_val({1'b1, 1'b0, 1'b1, 1'b0}), 
        .count_out(bit_count), .rollover_flag(packet_done) );
  AOI21X1 U3 ( .A(n1), .B(n2), .C(n3), .Y(shift_enable) );
  NOR2X1 U4 ( .A(bit_count[3]), .B(bit_count[2]), .Y(n2) );
  NOR2X1 U5 ( .A(bit_count[1]), .B(bit_count[0]), .Y(n1) );
  INVX1 U6 ( .A(n3), .Y(n5) );
  NAND3X1 U7 ( .A(shift_count[1]), .B(shift_count[0]), .C(n4), .Y(n3) );
  NOR2X1 U8 ( .A(shift_count[3]), .B(shift_count[2]), .Y(n4) );
  INVX1 U9 ( .A(enable_timer), .Y(n6) );
endmodule


module rcv_block ( clk, n_rst, serial_in, data_read, rx_data, data_ready, 
        overrun_error, framing_error );
  output [7:0] rx_data;
  input clk, n_rst, serial_in, data_read;
  output data_ready, overrun_error, framing_error;
  wire   load_buffer, shift_strobe, stop_bit, start_bit_detected, sbc_clear,
         sbc_enable, packet_done, enable_timer;
  wire   [7:0] packet_data;

  rx_data_buff BUF ( .clk(clk), .n_rst(n_rst), .load_buffer(load_buffer), 
        .packet_data(packet_data), .data_read(data_read), .rx_data(rx_data), 
        .data_ready(data_ready), .overrun_error(overrun_error) );
  sr_9bit SR9 ( .clk(clk), .n_rst(n_rst), .shift_strobe(shift_strobe), 
        .serial_in(serial_in), .packet_data(packet_data), .stop_bit(stop_bit)
         );
  start_bit_det SBD ( .clk(clk), .n_rst(n_rst), .serial_in(serial_in), 
        .start_bit_detected(start_bit_detected) );
  stop_bit_chk SBC ( .clk(clk), .n_rst(n_rst), .sbc_clear(sbc_clear), 
        .sbc_enable(sbc_enable), .stop_bit(stop_bit), .framing_error(
        framing_error) );
  rcu RCU ( .clk(clk), .n_rst(n_rst), .start_bit_detected(start_bit_detected), 
        .packet_done(packet_done), .framing_error(framing_error), .sbc_clear(
        sbc_clear), .sbc_enable(sbc_enable), .load_buffer(load_buffer), 
        .enable_timer(enable_timer) );
  timer TMR ( .clk(clk), .n_rst(n_rst), .enable_timer(enable_timer), 
        .shift_enable(shift_strobe), .packet_done(packet_done) );
endmodule

