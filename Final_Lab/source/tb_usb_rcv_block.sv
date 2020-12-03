// $Id: $
// File name:   tb_rcv_block-starter.sv
// Created:     2/5/2013
// Author:      foo
// Lab Section: 99
// Version:     1.0  Initial Design Entry
// Description: starter top level test bench provided for Lab 5

`timescale 1ns / 10ps

module tb_usb_rcv_block();

  // Define parameters
  parameter CLK_PERIOD        = 10;
  parameter NORM_DATA_PERIOD  = (8 * CLK_PERIOD);
  
  localparam OUTPUT_CHECK_DELAY = (CLK_PERIOD - 0.2);
  localparam WORST_FAST_DATA_PERIOD = (NORM_DATA_PERIOD * 0.96);
  localparam WORST_SLOW_DATA_PERIOD = (NORM_DATA_PERIOD * 1.04);

  localparam USB_ADDRESS = 0;
  localparam ENDPOINT_ADDRESS = 0;
  
  //  DUT inputs
  reg tb_clk;
  reg tb_n_rst;
  reg tb_dplus;
  reg tb_dminus;
  reg tb_r_enable;
  
  // DUT outputs
  wire [7:0] tb_r_data;
  wire tb_full;
  wire tb_empty;
  wire tb_rcving;
  wire tb_r_error;
  wire [3:0] tb_pid;
  
  // Test bench debug signals
  // Overall test case number for reference
  integer tb_test_num;
  string  tb_test_case;
  // Test case 'inputs' used for test stimulus
  reg [63:0][7:0] tb_test_data;
  int tb_test_data_num;
  reg [7:0] tb_test_sync_byte;
  reg [7:0] tb_test_pid_byte;
  reg       tb_test_fifo_read; // read fifo or not
  // Test case expected output values for the test case
  reg [7:0] tb_expected_r_data;
  reg [3:0] tb_expected_pid;
  reg       tb_expected_rcving;
  reg       tb_expected_r_error;
  reg       tb_expected_empty;
  reg       tb_expected_full;
  integer   i;
  // DUT portmap
  usb_rcv_block DUT
  (
    .clk(tb_clk),
    .nrst(tb_n_rst),
    .d_plus(tb_dplus),
    .d_minus(tb_dminus),
    .r_enable(tb_r_enable),
    .r_data(tb_r_data),
    .pid(tb_pid),
    .r_error(tb_r_error),
    .rcving (tb_rcving),
    .full(tb_full),
    .empty(tb_empty)
  );
  
  // Tasks for regulating the timing of input stimulus to the design
  task send_usb_packet;
    input  [63:0][7:0] data;
    input  int data_num;
    input  [7:0] sync_byte;
    input  [7:0] pid_byte;
    
    integer i, j;
    logic bbit;
    integer d_stuff;
  begin
    // First synchronize to away from clock's rising edge
    @(negedge tb_clk)
    
    // Send sync byte   
    // Send data bits
    for(i = 0; i < 8; i = i + 1)
    begin
      bbit = sync_byte[i];
      if (~bbit) begin
	tb_dplus <= ~tb_dplus;
        tb_dminus <= ~tb_dminus;
	end
      #NORM_DATA_PERIOD;
    end
     // Send pid byte   
    // Send data bits
    for(i = 0; i < 8; i = i + 1)
    begin
      bbit = pid_byte[i];
      if (~bbit) begin
	tb_dplus <= ~tb_dplus;
        tb_dminus <= ~tb_dminus;
	end
      #NORM_DATA_PERIOD;
    end
    // Send data bytes
    // d_stuff can only happen in data phase
    d_stuff = 0;
    for (j = 0; j <data_num; j = j + 1)
    for(i = 0; i < 8; i = i + 1)
    begin
      bbit = data[j][i];
      if (bbit == 1'b1) begin
	d_stuff = d_stuff + 1;
	end
	else begin
        d_stuff = 0;
	end
      if (~bbit) begin
	tb_dplus <= ~tb_dplus;
        tb_dminus <= ~tb_dminus;
	end
      #NORM_DATA_PERIOD;
      // stuff bit zero
      if (d_stuff == 6) begin
	//insert zero bit 
	tb_dplus <= ~tb_dplus;
        tb_dminus <= ~tb_dminus;	
	d_stuff = 0;	
	#NORM_DATA_PERIOD;
	end
    end
    // Send eop
    tb_dplus  <= 1'b0;
    tb_dminus   <= 1'b0;
    #(NORM_DATA_PERIOD * 2);
    tb_dplus  <= 1'b1;
    tb_dminus   <= 1'b0;
    #NORM_DATA_PERIOD;
  end
  endtask
  
  task reset_dut;
  begin
    // Activate the design's reset (does not need to be synchronize with clock)
    tb_n_rst = 1'b0;
    
    // Wait for a couple clock cycles
    @(posedge tb_clk);
    @(posedge tb_clk);
    
    // Release the reset
    @(negedge tb_clk);
    tb_n_rst = 1;
    
    // Wait for a while before activating the design
    #NORM_DATA_PERIOD;
  end
  endtask
  
  task check_outputs;
    input assert_fifo_read;
  begin
    
    // check outputs pins
    assert(tb_expected_rcving == tb_rcving)
      $info("Test case %0d: Test rcving correctly checked", tb_test_num);
    else
      $error("Test case %0d: Test rcving was not correctly checked", tb_test_num);
      
    assert(tb_expected_r_error == tb_r_error)
      $info("Test case %0d: Test r_error correctly checked", tb_test_num);
    else
      $error("Test case %0d: Test r_error was not correctly checked", tb_test_num);

    assert(tb_expected_pid == tb_pid)
      $info("Test case %0d: Test pid correctly checked", tb_test_num);
    else
      $error("Test case %0d: Test pid was not correctly checked", tb_test_num); 
    
    if(1'b1 == assert_fifo_read)
    begin
	//do fifo read and check the received data
    assert(tb_expected_full == tb_full)
      $info("Test case %0d: Test r_error correctly checked", tb_test_num);
    else
      $error("Test case %0d: Test r_error was not correctly checked", tb_test_num);

    assert(tb_expected_empty == tb_empty)
      $info("Test case %0d: Test empty correctly checked", tb_test_num);
    else
      $error("Test case %0d: Test empty was not correctly checked", tb_test_num); 
    end
  end
  endtask
  
  always
  begin : CLK_GEN
    tb_clk = 1'b0;
    #(CLK_PERIOD / 2);
    tb_clk = 1'b1;
    #(CLK_PERIOD / 2);
  end

  // Actual test bench process
  initial
  begin : TEST_PROC
    // Initialize all test bench signals
    tb_test_num               = -1;
    tb_test_case              = "TB Init";
    tb_test_data              = '0;
    tb_test_data_num          = 0;
    tb_test_sync_byte         = 8'h01;
    tb_test_pid_byte          = 8'hE1;
    tb_expected_r_data       = '0;
    tb_expected_pid          = 4'h1;
    tb_expected_rcving    = 1'b0; 
    tb_expected_r_error = 1'b0;
    tb_expected_full       = 1'b0;
    tb_expected_empty       = 1'b0;

    // Initilize all inputs to inactive/idle values
    tb_n_rst      = 1'b1; // Initially inactive
    tb_dplus  = 1'b1; // Initially idle
    tb_dminus  = 1'b0; // Initially idle
    tb_r_enable  = 1'b0; // Initially inactive
    
    // Get away from Time = 0
    #0.1; 
    
    // Test case 0: Basic Power on Reset
    tb_test_num  = 0;
    tb_test_case = "Power-on-Reset";
    
    // Power-on Reset Test case: Simply populate the expected outputs
    // These values don't matter since it's a reset test but really should be set to 'idle'/inactive values
    tb_test_data              = '0;
    tb_test_data_num          = 0;
    tb_test_fifo_read         = '0;
    tb_test_sync_byte         = 8'h01;
    tb_test_pid_byte          = 8'hE1;
    tb_expected_r_data       = '0;
    tb_expected_pid          = 4'h1;
    tb_expected_rcving    = 1'b0; 
    tb_expected_r_error = 1'b0;
    tb_expected_full       = 1'b0;
    tb_expected_empty       = 1'b0;
    
    // DUT Reset
    reset_dut;
    
    // Check outputs
    check_outputs(tb_test_fifo_read);
    
    // Test case 1: Basic PID test - OUT token packet
    // Synchronize to falling edge of clock to prevent timing shifts from prior test case(s)
    @(negedge tb_clk);
    tb_test_num  += 1;
    tb_test_case = "Basic PID test - OUT token packet";
    
    // Setup packet info for debugging/verificaton signals
    tb_test_data              = { 8'h10, 8'h00}; //address = 7'h0, endpoint = 4'h0, crc5 = 5'h02

    tb_test_data_num          = 2;
    tb_test_fifo_read         = '0;
    tb_test_sync_byte         = 8'h80;
    tb_test_pid_byte          = 8'hE1;
    tb_expected_pid          = 4'h1;
    tb_expected_r_data       = '0;
    tb_expected_rcving    = 1'b0; 
    tb_expected_r_error = 1'b0;
    tb_expected_full       = 1'b0;
    tb_expected_empty       = 1'b0;
    
    // DUT Reset
    reset_dut;
    
    // Send packet
    send_usb_packet(tb_test_data, tb_test_data_num, tb_test_sync_byte, tb_test_pid_byte);
    
    // Check outputs
    check_outputs(tb_test_fifo_read);
    
    // Test case 2: Basic PID test - IN token packet
    // Synchronize to falling edge of clock to prevent timing shifts from prior test case(s)    
    @(negedge tb_clk);
    tb_test_num  += 1;
    tb_test_case = "Basic PID test - IN token packet";
    
    // Setup packet info for debugging/verificaton signals
    tb_test_data              = { 8'h10, 8'h00}; //address = 7'h0, endpoint = 4'h0, crc5 = 5'h02

    tb_test_data_num          = 2;
    tb_test_fifo_read         = '0;
    tb_test_sync_byte         = 8'h80;
    tb_test_pid_byte          = 8'h69;
    tb_expected_pid          = 4'h9;
    tb_expected_r_data       = '0;
    tb_expected_rcving    = 1'b0; 
    tb_expected_r_error = 1'b0;
    tb_expected_full       = 1'b0;
    tb_expected_empty       = 1'b0;
    
    // DUT Reset
    reset_dut;
    
    // Send packet
    send_usb_packet(tb_test_data, tb_test_data_num, tb_test_sync_byte, tb_test_pid_byte);
    
    // Check outputs
    check_outputs(tb_test_fifo_read);
     // Test case 3: Basic PID test - ACK packet
    // Synchronize to falling edge of clock to prevent timing shifts from prior test case(s)
    @(negedge tb_clk);
    tb_test_num  += 1;
    tb_test_case = "Basic PID test - ACK packet";
    
    // Setup packet info for debugging/verificaton signals
    tb_test_data              = { 8'h10, 8'h00}; //address = 7'h0, endpoint = 4'h0, crc5 = 5'h02

    tb_test_data_num          = 0;  //ACK has no data byte
    tb_test_fifo_read         = '0;
    tb_test_sync_byte         = 8'h80;
    tb_test_pid_byte          = 8'hD2;
    tb_expected_pid          = 4'h2;
    tb_expected_r_data       = '0;
    tb_expected_rcving    = 1'b0; 
    tb_expected_r_error = 1'b0;
    tb_expected_full       = 1'b0;
    tb_expected_empty       = 1'b0;
    
    // DUT Reset
    reset_dut;
    
    // Send packet
    send_usb_packet(tb_test_data, tb_test_data_num, tb_test_sync_byte, tb_test_pid_byte);
    
    // Check outputs
    check_outputs(tb_test_fifo_read);
    
    // Test case 4: Basic PID test - NAK packet
    // Synchronize to falling edge of clock to prevent timing shifts from prior test case(s)    
    @(negedge tb_clk);
    tb_test_num  += 1;
    tb_test_case = "Basic PID test - NAK packet";
    
    // Setup packet info for debugging/verificaton signals
    tb_test_data              = { 8'h10, 8'h00}; //address = 7'h0, endpoint = 4'h0, crc5 = 5'h02

    tb_test_data_num          = 0; //NAK has no data byte
    tb_test_fifo_read         = '0;
    tb_test_sync_byte         = 8'h80;
    tb_test_pid_byte          = 8'h5A;
    tb_expected_pid          = 4'hA;
    tb_expected_r_data       = '0;
    tb_expected_rcving    = 1'b0; 
    tb_expected_r_error = 1'b0;
    tb_expected_full       = 1'b0;
    tb_expected_empty       = 1'b0;
    
    // DUT Reset
    reset_dut;
    
    // Send packet
    send_usb_packet(tb_test_data, tb_test_data_num, tb_test_sync_byte, tb_test_pid_byte);
    
    // Check outputs
    check_outputs(tb_test_fifo_read);

     // Test case 5: Basic Data test - DATA0 4 byte packet
    // Synchronize to falling edge of clock to prevent timing shifts from prior test case(s)
    @(negedge tb_clk);
    tb_test_num  += 1;
    tb_test_case = "Basic Data test - DATA0 4 byte packet";
    
    // Setup packet info for debugging/verificaton signals
    tb_test_data              = { 8'h1E, 8'h7E, 8'h02, 8'h01}; //2 bytes of data followed by valid crc16 by crc16.pl

    tb_test_data_num          = 4;  //ACK has no data byte
    tb_test_fifo_read         = '0;
    tb_test_sync_byte         = 8'h80;
    tb_test_pid_byte          = 8'hC3;
    tb_expected_pid          = 4'h3;
    tb_expected_r_data       = '0;
    tb_expected_rcving    = 1'b0; 
    tb_expected_r_error = 1'b0;
    tb_expected_full       = 1'b0;
    tb_expected_empty       = 1'b0;
    
    // DUT Reset
    reset_dut;
    
    // Send packet
    send_usb_packet(tb_test_data, tb_test_data_num, tb_test_sync_byte, tb_test_pid_byte);
    
    // Check outputs
    check_outputs(tb_test_fifo_read);
    
    // Test case 6: Basic Data test - DATA1 4 bytes packet
    // Synchronize to falling edge of clock to prevent timing shifts from prior test case(s)    
    @(negedge tb_clk);
    tb_test_num  += 1;
    tb_test_case = "Basic Data test - DATA1 4 byte packet";
    
    // Setup packet info for debugging/verificaton signals
    tb_test_data              = { 8'h1E, 8'h7E, 8'h02, 8'h01}; //2 bytes of data followed by valid crc16 by crc16.pl

    tb_test_data_num          = 4; 
    tb_test_fifo_read         = '0;
    tb_test_sync_byte         = 8'h80;
    tb_test_pid_byte          = 8'h4B;
    tb_expected_pid          = 4'hB;
    tb_expected_r_data       = '0;
    tb_expected_rcving    = 1'b0; 
    tb_expected_r_error = 1'b0;
    tb_expected_full       = 1'b0;
    tb_expected_empty       = 1'b0;
    
    // DUT Reset
    reset_dut;
    
    // Send packet
    send_usb_packet(tb_test_data, tb_test_data_num, tb_test_sync_byte, tb_test_pid_byte);
    
    // Check outputs
    check_outputs(tb_test_fifo_read);

     // Test case 7: Basic Data test - DATA0 64 byte packet
    // Synchronize to falling edge of clock to prevent timing shifts from prior test case(s)
    @(negedge tb_clk);
    tb_test_num  += 1;
    tb_test_case = "Basic Data test - DATA0 64 byte packet";
    
    // Setup packet info for debugging/verificaton signals
     for (i=0; i <62; i=i+2) begin
	tb_test_data[i] = 8'h01;
	tb_test_data[i+1] = 8'h02; 
	end
        tb_test_data[62] = 8'h4B;
	tb_test_data[63] = 8'h78;
      
    tb_test_data_num          = 64;  
    tb_test_fifo_read         = '0;
    tb_test_sync_byte         = 8'h80;
    tb_test_pid_byte          = 8'hC3;
    tb_expected_pid          = 4'h3;
    tb_expected_r_data       = '0;
    tb_expected_rcving    = 1'b0; 
    tb_expected_r_error = 1'b0;
    tb_expected_full       = 1'b0;
    tb_expected_empty       = 1'b0;
    
    // DUT Reset
    reset_dut;
    
    // Send packet
    send_usb_packet(tb_test_data, tb_test_data_num, tb_test_sync_byte, tb_test_pid_byte);
    
    // Check outputs
    check_outputs(tb_test_fifo_read);
    
    // Test case 8: Basic Data test - DATA1 4 bytes bit stuff packet
    // Synchronize to falling edge of clock to prevent timing shifts from prior test case(s)    
    @(negedge tb_clk);
    tb_test_num  += 1;
    tb_test_case = "Basic Data test - DATA1 4 byte bit stuff packet";
    
    // Setup packet info for debugging/verificaton signals
    tb_test_data              = { 8'h9F, 8'hBF, 8'hFF, 8'h01}; //2 bytes of data followed by valid crc16 by crc16.pl, FF byte cause bit stuff

    tb_test_data_num          = 4; 
    tb_test_fifo_read         = '0;
    tb_test_sync_byte         = 8'h80;
    tb_test_pid_byte          = 8'h4B;
    tb_expected_pid          = 4'hB;
    tb_expected_r_data       = '0;
    tb_expected_rcving    = 1'b0; 
    tb_expected_r_error = 1'b0;
    tb_expected_full       = 1'b0;
    tb_expected_empty       = 1'b0;
    
    // DUT Reset
    reset_dut;
    
    // Send packet
    send_usb_packet(tb_test_data, tb_test_data_num, tb_test_sync_byte, tb_test_pid_byte);
    
    // Check outputs
    check_outputs(tb_test_fifo_read);   

     // Test case 9: Basic ERR test - Sync ERR packet
    // Synchronize to falling edge of clock to prevent timing shifts from prior test case(s)
    @(negedge tb_clk);
    tb_test_num  += 1;
    tb_test_case = "Basic ERR test - Sync ERR packet";
    
    // Setup packet info for debugging/verificaton signals
    tb_test_data              = { 8'h10, 8'h00}; //address = 7'h0, endpoint = 4'h0, crc5 = 5'h02

    tb_test_data_num          = 2;  
    tb_test_fifo_read         = '0;
    tb_test_sync_byte         = 8'h00;  //bad SyNC byte
    tb_test_pid_byte          = 8'h69;
    tb_expected_pid          = 4'h1;
    tb_expected_r_data       = '0;
    tb_expected_rcving    = 1'b0; 
    tb_expected_r_error = 1'b1;
    tb_expected_full       = 1'b0;
    tb_expected_empty       = 1'b0;
    
    // DUT Reset
    reset_dut;
    
    // Send packet
    send_usb_packet(tb_test_data, tb_test_data_num, tb_test_sync_byte, tb_test_pid_byte);
    
    // Check outputs
    check_outputs(tb_test_fifo_read);
    
    // Test case 10: Basic ERR test - Bad PID packet
    // Synchronize to falling edge of clock to prevent timing shifts from prior test case(s)    
    @(negedge tb_clk);
    tb_test_num  += 1;
    tb_test_case = "Basic ERR test - Bad PID packet";
    
    // Setup packet info for debugging/verificaton signals

    tb_test_data              = { 8'h10, 8'h00}; //address = 7'h0, endpoint = 4'h0, crc5 = 5'h02

    tb_test_data_num          = 2; 
    tb_test_fifo_read         = '0;
    tb_test_sync_byte         = 8'h80;
    tb_test_pid_byte          = 8'hF2;
    tb_expected_pid          = 4'h1;
    tb_expected_r_data       = '0;
    tb_expected_rcving    = 1'b0; 
    tb_expected_r_error = 1'b1;
    tb_expected_full       = 1'b0;
    tb_expected_empty       = 1'b0;
    
    // DUT Reset
    reset_dut;
    
    // Send packet
    send_usb_packet(tb_test_data, tb_test_data_num, tb_test_sync_byte, tb_test_pid_byte);
    
    // Check outputs
    check_outputs(tb_test_fifo_read);   


    // Test case 11: Basic ERR test - OUT token with Bad CRC5 packet
    // Synchronize to falling edge of clock to prevent timing shifts from prior test case(s)    
    @(negedge tb_clk);
    tb_test_num  += 1;
    tb_test_case = "Basic ERR test - OUT token bad CRC5 packet";
    
    // Setup packet info for debugging/verificaton signals

    tb_test_data              = { 8'h30, 8'h00}; //address = 7'h0, endpoint = 4'h0, crc5 = 5'h06 (bad crc)

    tb_test_data_num          = 2; 
    tb_test_fifo_read         = '0;
    tb_test_sync_byte         = 8'h80;
    tb_test_pid_byte          = 8'hE1;
    tb_expected_pid          = 4'h1;
    tb_expected_r_data       = '0;
    tb_expected_rcving    = 1'b0; 
    tb_expected_r_error = 1'b1;
    tb_expected_full       = 1'b0;
    tb_expected_empty       = 1'b0;
    
    // DUT Reset
    reset_dut;
    
    // Send packet
    send_usb_packet(tb_test_data, tb_test_data_num, tb_test_sync_byte, tb_test_pid_byte);
    
    // Check outputs
    check_outputs(tb_test_fifo_read); 
  
    // Test case 12: Basic ERR test - DATA1 BadCRC 4 bytes packet
    // Synchronize to falling edge of clock to prevent timing shifts from prior test case(s)    
    @(negedge tb_clk);
    tb_test_num  += 1;
    tb_test_case = "Basic ERR test - DATA1 4 byte bad CRC16 packet";
    
    // Setup packet info for debugging/verificaton signals
    tb_test_data              = { 8'h1F, 8'h7E, 8'h02, 8'h01}; //2 bytes of data followed by valid crc16 by crc16.pl

    tb_test_data_num          = 4; 
    tb_test_fifo_read         = '0;
    tb_test_sync_byte         = 8'h80;
    tb_test_pid_byte          = 8'h4B;
    tb_expected_pid          = 4'h1;
    tb_expected_r_data       = '0;
    tb_expected_rcving    = 1'b0; 
    tb_expected_r_error = 1'b1;
    tb_expected_full       = 1'b0;
    tb_expected_empty       = 1'b0;
    
    // DUT Reset
    reset_dut;
    
    // Send packet
    send_usb_packet(tb_test_data, tb_test_data_num, tb_test_sync_byte, tb_test_pid_byte);
 
    
  end

endmodule
