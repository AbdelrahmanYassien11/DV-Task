//==============================================================================
// File Name   : uart_monitor.sv
// Author      : Abdelrahman Yassien
// Email       : Abdelrahman.Yassien11@gmail.com
// Created On  : 2026-02-03
//
// Description :
//   UART monitor class responsible for sampling UART transactions from the
//   DUT interface and converting them into sequence items for analysis and
//   scoreboard checking.
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
// Copyright (c) [2026] [Abdelrahman Mohamed Yassien]. All Rights Reserved.
//==============================================================================
`ifndef UART_MON
`define UART_MON

class uart_monitor extends uart_base_monitor;
  
  `uvm_component_utils(uart_monitor)

  function new(string name = "uart_monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  task collect_transaction(uart_transaction trans);
    real bit_time = cfg.bit_period;
    bit sampled_bit;
    
    // Wait for start bit (transition from 1 to 0)
    wait(vif.monitor_cb.tx == 1'b0);
    $display("a");
    // Sample start bit at mid-bit time
    #(bit_time / 2);
    trans.start_bit = vif.tx;
    #(bit_time / 2);
    
    // Sample data bits (LSB first)
    for (int i = 0; i < 8; i++) begin
      #(bit_time / 2);
      trans.data[i] = vif.tx;
      #(bit_time / 2);
    end
    
    // Sample parity bit
    #(bit_time / 2);
    trans.parity_bit = vif.tx;
    #(bit_time / 2);
    
    // Sample stop bit
    #(bit_time / 2);
    trans.stop_bit = vif.tx;
    #(bit_time / 2);
    
  endtask

endclass
`endif