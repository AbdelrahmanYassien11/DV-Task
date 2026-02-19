//==============================================================================
// File Name   : tb_top.sv
// Author      : Abdelrahman Yassien
// Email       : Abdelrahman.Yassien11@gmail.com
// Created On  : 2026-02-13
//
// Description :
//   Top-level testbench module that instantiates the DUT, UART interface,
//   and launches the UVM test environment.
//
// Notes:
//   - Connects DUT with UART virtual interface
//   - Starts UVM run_test()
//   - Simulation-only module
//
// Copyright (c) [2026] [Abdelrahman Mohamed Yassien]. All Rights Reserved.
//==============================================================================
`ifndef UART_TB
`define UART_TB

`timescale 1ns/1ns
module uart_tb_top;
  
  // Importing UVM Necessities
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  // Importing UART UVM Hierarchy Package
  import uart_pkg::*;

  // Test Configuration Object Handle
  test_config test_cfg;

  // Clock generation
  bit clk;
  initial begin
    clk = 0;
    forever #5 clk = ~clk; // 100MHz clock
  end
  
  // Interface instantiation
  uart_if vif(clk);
  
  // Connect interface to config_db
  initial begin
    test_cfg = new();
    test_cfg.set_timeout_delay(10_000_000);
    //test_cfg.set_verbosity_level(UVM_MEDIUM); // May be obsolete because UVM provides that
    uvm_config_db#(test_config)::set(null,"uvm_test_top", "test_cfg", test_cfg);
    uvm_config_db#(virtual uart_if)::set(null, "uvm_test_top.env_h.uart_agt.uart_agt_cfg", "vif", vif);
    
    // Run the test
    run_test("");
  end
  
  // Waveform dumping for debugging
  initial begin
    $dumpfile("uart_tb.vcd");
    $dumpvars(0, uart_tb_top);
  end

  int unsigned start_bits_width;
  int unsigned tx_data_width;
  int unsigned stop_bits_width;
  initial begin
    uvm_cmdline_processor clp = uvm_cmdline_processor::get_inst();
    string start_bits_width_str;    
    string tx_data_width_str;
    string stop_bits_width_str;

    start_bits_width  = START_BITS_WIDTH;
    tx_data_width     = TX_DATA_WIDTH;
    stop_bits_width   = STOP_BITS_WIDTH;
    
    if(clp.get_arg_value("+START_BITS_WIDTH=", start_bits_width_str)) begin
      start_bits_width = start_bits_width_str.atoi();
    end

    if(clp.get_arg_value("+TX_DATA_WIDTH=", tx_data_width_str)) begin
      tx_data_width = tx_data_width_str.atoi();
    end

    if(clp.get_arg_value("+STOP_BITS_WIDTH=", stop_bits_width_str)) begin
      stop_bits_width = stop_bits_width_str.atoi();
    end 

  end
  
endmodule

`endif