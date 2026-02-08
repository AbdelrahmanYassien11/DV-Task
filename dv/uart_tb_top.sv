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
    uvm_config_db#(virtual uart_if)::set(null, "*", "vif", vif);
    
    // Run the test
    run_test("uart_test_seq1_seq2");
  end
  
  // Timeout watchdog
  initial begin
    #3000_000; // 1ns/1ps = 10_000_000_000 when asked to wait 10_000_000
                 // 1ns/1ns = 10_000_000 when asked to wait 10_000_000
                 // 1_919_965
    `uvm_fatal("TIMEOUT", "Test timeout after 1ms")
  end
  
  // Waveform dumping for debugging
  initial begin
    $dumpfile("uart_tb.vcd");
    $dumpvars(0, uart_tb_top);
  end
  
endmodule

`endif