quit -sim
.main clear

file delete -force presynth
vlib presynth
vmap presynth presynth

vlog -sv -work presynth \
    "rtl/spi_master.sv" \
    "test/MAX31855_Model.v \"

vsim -voptargs=+acc -L presynth -work presynth -t 1ps presynth.testbench
add log -r /*

if {[file exists "wave.do"]} {
    do  "wave.do"
}

run -all