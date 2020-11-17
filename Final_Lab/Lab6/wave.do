onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_rcv_block/DUT/clk
add wave -noupdate /tb_rcv_block/DUT/n_rst
add wave -noupdate /tb_rcv_block/DUT/serial_in
add wave -noupdate /tb_rcv_block/DUT/data_read
add wave -noupdate /tb_rcv_block/DUT/rx_data
add wave -noupdate /tb_rcv_block/DUT/data_ready
add wave -noupdate /tb_rcv_block/DUT/overrun_error
add wave -noupdate /tb_rcv_block/DUT/framing_error
add wave -noupdate /tb_rcv_block/DUT/load_buffer
add wave -noupdate /tb_rcv_block/DUT/sbc_enable
add wave -noupdate /tb_rcv_block/DUT/sbc_clear
add wave -noupdate /tb_rcv_block/DUT/enable_timer
add wave -noupdate /tb_rcv_block/DUT/packet_done
add wave -noupdate /tb_rcv_block/DUT/start_bit_detected
add wave -noupdate /tb_rcv_block/DUT/shift_strobe
add wave -noupdate /tb_rcv_block/DUT/stop_bit
add wave -noupdate /tb_rcv_block/DUT/packet_data
add wave -noupdate /tb_rcv_block/DUT/RCU/state
add wave -noupdate /tb_rcv_block/DUT/SR9/ninebit_sr/shift_reg
add wave -noupdate /tb_rcv_block/DUT/SR9/ninebit_sr/n_rst
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {53841 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {525 ns}
