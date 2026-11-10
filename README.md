# Super_SPI_Master_Verilog

SPI Master verilog module

More info at:
http://www.circuitden.com/blog/22

## Burst writes

The first word of a burst write is taken from `data` when the transaction starts.
Every later word crosses a valid/ready handshake: the master takes `data` on any clock
where both `burst_data_enable` and `burst_data_ready` are high. The words land in a one
word prefetch buffer, so `burst_data_ready` rises as soon as slave select falls and the
host has roughly a whole word time to supply each next word.

If the next word has not arrived by the time the current word finishes, the burst ends
cleanly at that word boundary and `burst_underflow` goes high. It stays high until the
next transaction starts. The words that made it onto the wire are complete, and the
flag tells the host the rest of the burst was cut.

All configuration inputs, including `divider`, are captured when a transaction starts,
so changing them mid transaction has no effect until the next one. Reset is
synchronous, and `serial_clock` idles at the configured `clock_polarity` from reset.
