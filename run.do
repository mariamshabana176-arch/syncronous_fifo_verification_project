vlib work
vlog *sv  +cover
vsim -voptargs=+acc FIFO_TOP -cover
add wave *
coverage save FIFO_TOP.ucdb -onexit
run -all
