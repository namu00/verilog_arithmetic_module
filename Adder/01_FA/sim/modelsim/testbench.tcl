# stop any simulation that is currently running
quit -sim

#vdel -all -lib work;
# create the default "work" library
vlib work;

# compile the Verilog source code in the parent folder
#vlog ../*.v
# compile the Verilog code of the testbench

vlog -f run.f

#vlog src/*.v
#vlog tb/*.v
#vlog ip/clock_gen/clock_gen.v
#vlog ip/rom_1port/rom_1port.v
# start the Simulator, including some libraries
vsim work.testbench -Lf 220model -Lf altera_mf_ver -Lf verilog -Lf cycloneive_ver
# show waveforms specified in wave.do
# do wave.do
# advance the simulation the desired amount of time
#run 120 ns
add wave -position insertpoint sim:/testbench/*
