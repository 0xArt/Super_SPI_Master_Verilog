quit -sim
.main clear

file delete -force presynth
vlib presynth
vmap presynth presynth

vlog -sv -work presynth \
    "rtl/spi_master.sv" \
    "rtl/spi_burst_receiver.sv" \
    "test/spi_slave_sim_model.sv" \
    "test/testbench.sv"

vsim -voptargs=+acc -L presynth -work presynth -t 1ps presynth.testbench
add log -r /*

if {[file exists "wave.do"]} {
    do  "wave.do"
}

run -all