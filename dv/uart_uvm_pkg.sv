//==============================================================================
// File Name   : uart_uvm_pkg.sv
// Author      : Abdelrahman Yassien
// Email       : Abdelrahman.Yassien11@gmail.com
// Created On  : 2026-02-03
//
// Description :
//   UART UVM package containing all UART verification components including
//   transaction, sequences, driver, monitor, agent, environment, and tests.
//
// Notes:
//   - Central package for UART UVM testbench
//   - Imported by tb_top and test files
//
// Copyright (c) [2026] [Abdelrahman Mohamed Yassien]. All Rights Reserved.
//==============================================================================
`ifndef UART_PKG
`define UART_PKG
package uart_pkg;

	localparam TX_DATA_WIDTH     = 9;
	localparam START_BITS_WIDTH  = 1;
	localparam PARITY_BITS_WIDTH = 1;
	localparam STOP_BITS_WIDTH   = 1;


	import uvm_pkg::*;
	`include "uvm_macros.svh"
	`include "uart_types.sv"
	`include "test_config.sv"
	`include "env_config.sv"
	`include "uart_agent_config.sv"
	`include "uart_config.sv"

  	int incorrect_counter;
   	int correct_counter;

   	//******************************************************************************************************************//
   	//												UVM ENVIRONMENT COMPONENTS
   	//*****************************************************************************************************************//


	`include "uart_transaction.sv"

	`include "uart_base_driver.sv"
	`include "uart_base_monitor.sv"
	`include "uart_sequencer.sv"

	// `include "predictor.svh"
	// `include "comparator.svh"

	`include "uart_driver.sv"
	// `include "inputs_monitor.svh"
	// `include "outputs_monitor.svh"
	`include "uart_monitor.sv"

	`include "uart_agent.sv"

	// `include "scoreboard.svh"
	// `include "coverage.svh"

	`include "v_sequencer.sv"
	`include "env.sv"


   	//******************************************************************************************************************//
   	//												UVM UART SEQUENCES
   	//*****************************************************************************************************************//
	`include "uart_seq.sv"


   	//******************************************************************************************************************//
   	//												UVM UART TESTS
   	//*****************************************************************************************************************//

	`include "base_v_seq.sv"
	`include "v_seq.sv"

	`include "uart_base_test.sv"

	`include "uart_test_s1_s2.sv"

endpackage

`endif

//====================================================================