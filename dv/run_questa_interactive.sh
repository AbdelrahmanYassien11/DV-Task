#!/bin/bash

# Clean previous compilation
rm -rf work
rm -f transcript
rm -f vsim.wlf
rm -f *.vcd

# Create work library
vlib work

# Compile the testbench with UVM
echo "Compiling UVM testbench..."
vlog -sv \
     +incdir+$UVM_HOME/src \
     $UVM_HOME/src/uvm_pkg.sv \
     uart_uvm_tb.sv

# Check compilation status
if [ $? -ne 0 ]; then
    echo "Compilation failed!"
    exit 1
fi

echo "Compilation successful!"

# Ask user for simulation mode
echo ""
echo "Choose simulation mode:"
echo "1) Console mode (batch)"
echo "2) GUI mode"
read -p "Enter choice [1-2]: " choice

case $choice in
    1)
        echo "Running in console mode..."
        vsim -c \
             -do "run -all; quit -f" \
             uart_tb_top \
             +UVM_TESTNAME=uart_test_seq1_seq2 \
             +UVM_VERBOSITY=UVM_MEDIUM
        ;;
    2)
        echo "Running in GUI mode..."
        vsim -gui \
             uart_tb_top \
             +UVM_TESTNAME=uart_test_seq1_seq2 \
             +UVM_VERBOSITY=UVM_MEDIUM \
             -do "add wave -r /*; run -all"
        ;;
    *)
        echo "Invalid choice!"
        exit 1
        ;;
esac
