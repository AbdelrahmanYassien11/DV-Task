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
// Revision History:
//   0.1 - Initial version
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

	import uvm_pkg::*;
	`include "uvm_macros.svh"
	`include "uart_header.svh"
	`include "uart_config.sv"


	typedef enum {START, STOP, TX_ON} header_e;
	typedef enum {OK, ERR, TX} state_e;

  	int incorrect_counter;
   	int correct_counter;

   	//******************************************************************************************************************//
   	//												UVM ENVIRONMENT COMPONENTS
   	//*****************************************************************************************************************//


	`include "uart_transaction.sv"

	`include "uart_base_driver.sv"
	`include "uart_base_monitor.sv"
	`include "uart_sequencer.sv"

	//`include "passive_agent_config.svh"
	//`include "active_agent_config.svh"
	//`include "env_config.svh"

	// `include "predictor.svh"
	// `include "comparator.svh"

	// `include "base_sequence.svh"

	`include "uart_driver.sv"
	// `include "inputs_monitor.svh"
	// `include "outputs_monitor.svh"
	`include "uart_monitor.sv"

	`include "uart_agent.sv"
	// `include "active_agent.svh"
	// `include "passive_agent.svh"

	// `include "scoreboard.svh"
	// `include "coverage.svh"

	`include "uart_env.sv"


   	//******************************************************************************************************************//
   	//												UVM AMBA AHB LITE SEQUENCES
   	//*****************************************************************************************************************//
	`include "uart_seq.sv"


   	//******************************************************************************************************************//
   	//												UVM AMBA AHB LITE TESTS
   	//*****************************************************************************************************************//

	`include "uart_base_test.sv"

	`include "uart_test_s1_s2.sv"

endpackage

`endif