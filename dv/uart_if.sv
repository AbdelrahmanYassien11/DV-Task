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
// Parameters  :
//   BAUD_RATE   - UART baud rate (bits per second)
//   START_BITS  - Number of start bits  (default 1)
//   DATA_BITS   - Number of data bits   (default 8)
//   PARITY_BITS - Number of parity bits (default 1)
//   STOP_BITS   - Number of stop bits   (default 1)
//
// Revision History:
//   0.1 - Initial version
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