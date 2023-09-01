onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group spi_burst_receiver /testbench/spi_burst_receiver/clock
add wave -noupdate -group spi_burst_receiver /testbench/spi_burst_receiver/reset_n
add wave -noupdate -group spi_burst_receiver /testbench/spi_burst_receiver/enable
add wave -noupdate -group spi_burst_receiver /testbench/spi_burst_receiver/burst_count
add wave -noupdate -group spi_burst_receiver /testbench/spi_burst_receiver/burst_data_enable
add wave -noupdate -group spi_burst_receiver /testbench/spi_burst_receiver/burst_data
add wave -noupdate -group spi_burst_receiver /testbench/spi_burst_receiver/busy
add wave -noupdate -group spi_burst_receiver /testbench/spi_burst_receiver/data_valid
add wave -noupdate -group spi_burst_receiver /testbench/spi_burst_receiver/memory_address
add wave -noupdate -group spi_burst_receiver /testbench/spi_burst_receiver/data
add wave -noupdate -group spi_burst_receiver /testbench/spi_burst_receiver/_state
add wave -noupdate -group spi_burst_receiver /testbench/spi_burst_receiver/state
add wave -noupdate -group spi_burst_receiver /testbench/spi_burst_receiver/counter
add wave -noupdate -group spi_burst_receiver /testbench/spi_burst_receiver/_counter
add wave -noupdate -group spi_burst_receiver /testbench/spi_burst_receiver/burst_data_enable_delay
add wave -noupdate -group spi_burst_receiver /testbench/spi_burst_receiver/_burst_data_enable_delay
add wave -noupdate -group spi_burst_receiver /testbench/spi_burst_receiver/burst_data_valid_positive_edge
add wave -noupdate -group spi_burst_receiver /testbench/spi_burst_receiver/_busy
add wave -noupdate -group spi_burst_receiver /testbench/spi_burst_receiver/_data_valid
add wave -noupdate -group spi_burst_receiver /testbench/spi_burst_receiver/_memory_address
add wave -noupdate -group spi_burst_receiver /testbench/spi_burst_receiver/_data
add wave -noupdate -group spi_slave /testbench/spi_slave_sim_model/clock
add wave -noupdate -group spi_slave /testbench/spi_slave_sim_model/reset_n
add wave -noupdate -group spi_slave /testbench/spi_slave_sim_model/serial_clock
add wave -noupdate -group spi_slave /testbench/spi_slave_sim_model/chip_select
add wave -noupdate -group spi_slave /testbench/spi_slave_sim_model/serial_in
add wave -noupdate -group spi_slave /testbench/spi_slave_sim_model/clock_polarity
add wave -noupdate -group spi_slave /testbench/spi_slave_sim_model/clock_phase
add wave -noupdate -group spi_slave /testbench/spi_slave_sim_model/serial_out
add wave -noupdate -group spi_slave /testbench/spi_slave_sim_model/read_data_valid
add wave -noupdate -group spi_slave /testbench/spi_slave_sim_model/_serial_data
add wave -noupdate -group spi_slave /testbench/spi_slave_sim_model/serial_data
add wave -noupdate -group spi_slave /testbench/spi_slave_sim_model/_serial_clock_delay
add wave -noupdate -group spi_slave /testbench/spi_slave_sim_model/serial_clock_delay
add wave -noupdate -group spi_slave /testbench/spi_slave_sim_model/serial_clock_positive_edge
add wave -noupdate -group spi_slave /testbench/spi_slave_sim_model/serial_clock_negative_edge
add wave -noupdate -group spi_slave /testbench/spi_slave_sim_model/counter
add wave -noupdate -group spi_slave /testbench/spi_slave_sim_model/_counter
add wave -noupdate -group spi_slave /testbench/spi_slave_sim_model/data
add wave -noupdate -group spi_slave /testbench/spi_slave_sim_model/_read_data
add wave -noupdate -group spi_slave /testbench/spi_slave_sim_model/read_data
add wave -noupdate -group spi_slave /testbench/spi_slave_sim_model/skip
add wave -noupdate -group spi_slave /testbench/spi_slave_sim_model/_skip
add wave -noupdate -group spi_slave /testbench/spi_slave_sim_model/_read_data_valid
add wave -noupdate -expand -group spi_master /testbench/spi_master/clock
add wave -noupdate -expand -group spi_master /testbench/spi_master/reset_n
add wave -noupdate -expand -group spi_master /testbench/spi_master/data
add wave -noupdate -expand -group spi_master /testbench/spi_master/address
add wave -noupdate -expand -group spi_master /testbench/spi_master/read_write
add wave -noupdate -expand -group spi_master /testbench/spi_master/enable
add wave -noupdate -expand -group spi_master /testbench/spi_master/burst_enable
add wave -noupdate -expand -group spi_master /testbench/spi_master/burst_count
add wave -noupdate -expand -group spi_master /testbench/spi_master/divider
add wave -noupdate -expand -group spi_master /testbench/spi_master/clock_phase
add wave -noupdate -expand -group spi_master /testbench/spi_master/clock_polarity
add wave -noupdate -expand -group spi_master /testbench/spi_master/read_data
add wave -noupdate -expand -group spi_master /testbench/spi_master/busy
add wave -noupdate -expand -group spi_master -color Gold /testbench/spi_master/serial_clock
add wave -noupdate -expand -group spi_master /testbench/spi_master/slave_select
add wave -noupdate -expand -group spi_master /testbench/spi_master/master_out_slave_in
add wave -noupdate -expand -group spi_master /testbench/spi_master/master_in_slave_out
add wave -noupdate -expand -group spi_master -color Red /testbench/spi_master/sample
add wave -noupdate -expand -group spi_master /testbench/spi_master/divider_tick
add wave -noupdate -expand -group spi_master /testbench/spi_master/read_long_data
add wave -noupdate -expand -group spi_master /testbench/spi_master/read_data_valid
add wave -noupdate -expand -group spi_master /testbench/spi_master/burst_data_ready
add wave -noupdate -expand -group spi_master /testbench/spi_master/_state
add wave -noupdate -expand -group spi_master /testbench/spi_master/state
add wave -noupdate -expand -group spi_master /testbench/spi_master/internal_serial_clock
add wave -noupdate -expand -group spi_master /testbench/spi_master/_internal_serial_clock
add wave -noupdate -expand -group spi_master /testbench/spi_master/_read_data
add wave -noupdate -expand -group spi_master /testbench/spi_master/_busy
add wave -noupdate -expand -group spi_master /testbench/spi_master/_slave_select
add wave -noupdate -expand -group spi_master /testbench/spi_master/_master_out_slave_in
add wave -noupdate -expand -group spi_master /testbench/spi_master/_read_long_data
add wave -noupdate -expand -group spi_master /testbench/spi_master/_read_data_valid
add wave -noupdate -expand -group spi_master /testbench/spi_master/_burst_data_ready
add wave -noupdate -expand -group spi_master /testbench/spi_master/process_counter
add wave -noupdate -expand -group spi_master /testbench/spi_master/_process_counter
add wave -noupdate -expand -group spi_master /testbench/spi_master/bit_counter
add wave -noupdate -expand -group spi_master /testbench/spi_master/_bit_counter
add wave -noupdate -expand -group spi_master /testbench/spi_master/saved_clock_phase
add wave -noupdate -expand -group spi_master /testbench/spi_master/_saved_clock_phase
add wave -noupdate -expand -group spi_master /testbench/spi_master/saved_clock_polarity
add wave -noupdate -expand -group spi_master /testbench/spi_master/_saved_clock_polarity
add wave -noupdate -expand -group spi_master /testbench/spi_master/saved_read_write
add wave -noupdate -expand -group spi_master /testbench/spi_master/_saved_read_write
add wave -noupdate -expand -group spi_master /testbench/spi_master/saved_burst_count
add wave -noupdate -expand -group spi_master /testbench/spi_master/_saved_burst_count
add wave -noupdate -expand -group spi_master /testbench/spi_master/divider_counter
add wave -noupdate -expand -group spi_master /testbench/spi_master/_divider_counter
add wave -noupdate -expand -group spi_master /testbench/spi_master/saved_address
add wave -noupdate -expand -group spi_master /testbench/spi_master/_saved_address
add wave -noupdate -expand -group spi_master /testbench/spi_master/saved_data
add wave -noupdate -expand -group spi_master /testbench/spi_master/_saved_data
add wave -noupdate -expand -group spi_master /testbench/spi_master/saved_burst_enable
add wave -noupdate -expand -group spi_master /testbench/spi_master/_saved_burst_enable
add wave -noupdate -expand -group spi_master /testbench/spi_master/write_shift_register
add wave -noupdate -expand -group spi_master /testbench/spi_master/_write_shift_register
add wave -noupdate -expand -group spi_master /testbench/spi_master/read_shift_register
add wave -noupdate -expand -group spi_master /testbench/spi_master/_read_shift_register
add wave -noupdate -expand -group spi_master /testbench/spi_master/end_of_burst_word
add wave -noupdate -expand -group spi_master /testbench/spi_master/_end_of_burst_word
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {11070000 ps} 0}
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
WaveRestoreZoom {10297665 ps} {12044697 ps}
