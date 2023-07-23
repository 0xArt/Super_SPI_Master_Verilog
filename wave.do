onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group spi_master /testbench/spi_master/clock
add wave -noupdate -group spi_master /testbench/spi_master/reset_n
add wave -noupdate -group spi_master /testbench/spi_master/data
add wave -noupdate -group spi_master /testbench/spi_master/address
add wave -noupdate -group spi_master /testbench/spi_master/read_write
add wave -noupdate -group spi_master /testbench/spi_master/enable
add wave -noupdate -group spi_master /testbench/spi_master/burst_enable
add wave -noupdate -group spi_master /testbench/spi_master/burst_count
add wave -noupdate -group spi_master /testbench/spi_master/divider
add wave -noupdate -group spi_master /testbench/spi_master/clock_phase
add wave -noupdate -group spi_master /testbench/spi_master/clock_polarity
add wave -noupdate -group spi_master /testbench/spi_master/master_in_slave_out
add wave -noupdate -group spi_master /testbench/spi_master/serial_clock
add wave -noupdate -group spi_master /testbench/spi_master/read_data
add wave -noupdate -group spi_master /testbench/spi_master/busy
add wave -noupdate -group spi_master /testbench/spi_master/slave_select
add wave -noupdate -group spi_master /testbench/spi_master/master_out_slave_in
add wave -noupdate -group spi_master /testbench/spi_master/read_long_data
add wave -noupdate -group spi_master /testbench/spi_master/burst_data_valid
add wave -noupdate -group spi_master /testbench/spi_master/burst_data_ready
add wave -noupdate -group spi_master /testbench/spi_master/_state
add wave -noupdate -group spi_master /testbench/spi_master/state
add wave -noupdate -group spi_master /testbench/spi_master/_serial_clock
add wave -noupdate -group spi_master /testbench/spi_master/_read_data
add wave -noupdate -group spi_master /testbench/spi_master/_busy
add wave -noupdate -group spi_master /testbench/spi_master/_slave_select
add wave -noupdate -group spi_master /testbench/spi_master/_master_out_slave_in
add wave -noupdate -group spi_master /testbench/spi_master/_read_long_data
add wave -noupdate -group spi_master /testbench/spi_master/_burst_data_valid
add wave -noupdate -group spi_master /testbench/spi_master/_burst_data_ready
add wave -noupdate -group spi_master /testbench/spi_master/process_counter
add wave -noupdate -group spi_master /testbench/spi_master/_process_counter
add wave -noupdate -group spi_master /testbench/spi_master/bit_counter
add wave -noupdate -group spi_master /testbench/spi_master/_bit_counter
add wave -noupdate -group spi_master /testbench/spi_master/saved_clock_phase
add wave -noupdate -group spi_master /testbench/spi_master/_saved_clock_phase
add wave -noupdate -group spi_master /testbench/spi_master/saved_clock_polarity
add wave -noupdate -group spi_master /testbench/spi_master/_saved_clock_polarity
add wave -noupdate -group spi_master /testbench/spi_master/saved_read_write
add wave -noupdate -group spi_master /testbench/spi_master/_saved_read_write
add wave -noupdate -group spi_master /testbench/spi_master/saved_burst_count
add wave -noupdate -group spi_master /testbench/spi_master/_saved_burst_count
add wave -noupdate -group spi_master /testbench/spi_master/divider_counter
add wave -noupdate -group spi_master /testbench/spi_master/_divider_counter
add wave -noupdate -group spi_master /testbench/spi_master/divider_tick
add wave -noupdate -group spi_master /testbench/spi_master/saved_address
add wave -noupdate -group spi_master /testbench/spi_master/_saved_address
add wave -noupdate -group spi_master /testbench/spi_master/saved_data
add wave -noupdate -group spi_master /testbench/spi_master/_saved_data
add wave -noupdate -group spi_master /testbench/spi_master/saved_burst_enable
add wave -noupdate -group spi_master /testbench/spi_master/_saved_burst_enable
add wave -noupdate -group spi_master /testbench/spi_master/write_shift_register
add wave -noupdate -group spi_master /testbench/spi_master/_write_shift_register
add wave -noupdate -group spi_master /testbench/spi_master/read_shift_register
add wave -noupdate -group spi_master /testbench/spi_master/_read_shift_register
add wave -noupdate -expand -group spi_slave /testbench/spi_slave_sim_model/clock
add wave -noupdate -expand -group spi_slave /testbench/spi_slave_sim_model/reset_n
add wave -noupdate -expand -group spi_slave /testbench/spi_slave_sim_model/serial_clock
add wave -noupdate -expand -group spi_slave /testbench/spi_slave_sim_model/chip_select
add wave -noupdate -expand -group spi_slave /testbench/spi_slave_sim_model/serial_in
add wave -noupdate -expand -group spi_slave /testbench/spi_slave_sim_model/serial_out
add wave -noupdate -expand -group spi_slave /testbench/spi_slave_sim_model/_serial_data
add wave -noupdate -expand -group spi_slave /testbench/spi_slave_sim_model/serial_data
add wave -noupdate -expand -group spi_slave /testbench/spi_slave_sim_model/_serial_clock_delay
add wave -noupdate -expand -group spi_slave /testbench/spi_slave_sim_model/serial_clock_delay
add wave -noupdate -expand -group spi_slave /testbench/spi_slave_sim_model/serial_clock_positive_edge
add wave -noupdate -expand -group spi_slave /testbench/spi_slave_sim_model/serial_clock_negative_edge
add wave -noupdate -expand -group spi_slave /testbench/spi_slave_sim_model/counter
add wave -noupdate -expand -group spi_slave /testbench/spi_slave_sim_model/_counter
add wave -noupdate -expand -group spi_slave /testbench/spi_slave_sim_model/data
add wave -noupdate -expand -group spi_slave /testbench/spi_slave_sim_model/_read_data
add wave -noupdate -expand -group spi_slave /testbench/spi_slave_sim_model/read_data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {12006477774 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 343
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
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
WaveRestoreZoom {11998548498 ps} {12012378404 ps}
