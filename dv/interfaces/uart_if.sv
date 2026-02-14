//==============================================================================
// File Name   : uart_if.sv
// Author      : Abdelrahman Yassien
// Email       : Abdelrahman.Yassien11@gmail.com
// Created On  : 2026-02-03
//
// Description :
//   UART interface definition containing all UART signals and clocking blocks
//   used to connect the DUT with the UVM driver and monitor.
//
// Notes:
//   - Provides modports for driver and monitor
//   - Contains clocking blocks for synchronized signal access
//   - Simulation-only construct
//
// Copyright (c) [2026] [Abdelrahman Mohamed Yassien]. All Rights Reserved.
//==============================================================================

`ifndef UART_IF
`define UART_IF

interface uart_if(input bit clk);
  import uart_pkg::*;

  // Block Signals
  logic tx;
  logic rst;

  // TB Signals
  header_e header;
  state_e  state;

  // ============================================
  // ENUMS TO VIEW VALUES IN WAVEFORM
  // ============================================
    header_e         header_view;
    state_e          state_view;

    //assign  header_view     = header_e'(??);

  // Testbench behaviour control signals
  bit has_checks;
  int hang_threshold;
  initial begin
      has_checks = 0;
  end

  // Clocking block for driver
  clocking driver_cb @(posedge clk);
    output tx;
    output rst;
  endclocking
  
  // Clocking block for monitor
  clocking monitor_cb @(posedge clk);
    input tx;
    input rst;
  endclocking
  
  modport DRIVER (clocking driver_cb, output rst);
  modport MONITOR (clocking monitor_cb, input rst);
  
endinterface

`endif