#!/bin/bash

# Clean previous compilation
rm -rf work
rm -f transcript
rm -f vsim.wlf
rm -f *.vcd

# Create work library
vlib work

# Compile the testbench with UVM
vlog -sv \
     +incdir+$UVM_HOME/src \
     $UVM_HOME/src/uvm_pkg.sv \
     uart_uvm_tb.sv

# Check compilation status
if [ $? -eq 0 ]; then
    echo "Compilation successful!"
    
    # Run simulation
    vsim -c \
         -do "run -all; quit -f" \
         uart_tb_top \
         +UVM_TESTNAME=uart_test_seq1_seq2 \
         +UVM_VERBOSITY=UVM_LOW
else
    echo "Compilation failed!"
    exit 1
fi
