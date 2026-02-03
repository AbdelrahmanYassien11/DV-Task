# Makefile for UART UVM Testbench with Questa

# Variables
TB_FILE = uart_uvm_tb.sv
TOP_MODULE = uart_tb_top
TEST_NAME = uart_test_seq1_seq2
VERBOSITY = UVM_MEDIUM

# UVM Home (adjust if needed)
UVM_HOME ?= $(QUESTA_HOME)/verilog_src/uvm-1.2

# Compilation flags
VLOG_FLAGS = -sv +incdir+$(UVM_HOME)/src

# Simulation flags
VSIM_FLAGS = +UVM_TESTNAME=$(TEST_NAME) +UVM_VERBOSITY=$(VERBOSITY)

.PHONY: all compile sim clean help gui

all: compile sim

# Compile the design
compile:
	@echo "Cleaning previous build..."
	@rm -rf work transcript vsim.wlf *.vcd
	@echo "Creating work library..."
	@vlib work
	@echo "Compiling UVM package and testbench..."
	@vlog $(VLOG_FLAGS) $(UVM_HOME)/src/uvm_pkg.sv $(TB_FILE)
	@echo "Compilation complete!"

# Run simulation in console mode
sim:
	@echo "Running simulation in console mode..."
	@vsim -c $(TOP_MODULE) $(VSIM_FLAGS) -do "run -all; quit -f"

# Run simulation in GUI mode
gui:
	@echo "Running simulation in GUI mode..."
	@vsim -gui $(TOP_MODULE) $(VSIM_FLAGS) -do "add wave -r /*; run -all"

# Run with different verbosity levels
sim_low:
	@make sim VERBOSITY=UVM_LOW

sim_high:
	@make sim VERBOSITY=UVM_HIGH

sim_debug:
	@make sim VERBOSITY=UVM_DEBUG

# Clean build artifacts
clean:
	@echo "Cleaning build artifacts..."
	@rm -rf work transcript vsim.wlf *.vcd *.log

# Help target
help:
	@echo "UART UVM Testbench Makefile"
	@echo "==========================="
	@echo "Targets:"
	@echo "  all        - Compile and run simulation (default)"
	@echo "  compile    - Compile the testbench only"
	@echo "  sim        - Run simulation in console mode"
	@echo "  gui        - Run simulation in GUI mode"
	@echo "  sim_low    - Run with UVM_LOW verbosity"
	@echo "  sim_high   - Run with UVM_HIGH verbosity"
	@echo "  sim_debug  - Run with UVM_DEBUG verbosity"
	@echo "  clean      - Remove all build artifacts"
	@echo "  help       - Show this help message"
	@echo ""
	@echo "Variables:"
	@echo "  TEST_NAME  - UVM test to run (default: $(TEST_NAME))"
	@echo "  VERBOSITY  - UVM verbosity level (default: $(VERBOSITY))"
	@echo ""
	@echo "Examples:"
	@echo "  make                    # Compile and run"
	@echo "  make compile            # Just compile"
	@echo "  make gui                # Run with GUI"
	@echo "  make sim_high           # Run with high verbosity"
	@echo "  make clean              # Clean all files"
