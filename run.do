quit -sim
.main clear

file delete -force presynth
vlib presynth
vmap presynth presynth

vlog -sv -work presynth \
    "rtl/spi_master.sv" \
    "test/spi_slave_sim_model.sv \"

vsim -voptargs=+acc -L presynth -work presynth -t 1ps presynth.testbench
add log -r /*

if {[file exists "wave.do"]} {
    do  "wave.do"
}

run -all