//==============================================================================
// File Name   : tb_top.sv
// Author      : Abdelrahman Yassien
// Email       : Abdelrahman.Yassien11@gmail.com
// Created On  : 2026-02-03
//
// Description :
//   Top-level testbench module that instantiates the DUT, UART interface,
//   and launches the UVM test environment.
//
// Revision History:
//   0.1 - Initial version
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
  
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import uart_pkg::*;

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
  
endmodule

`endif