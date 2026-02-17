//==============================================================================
// File Name   : uart_config.sv
// Author      : Abdelrahman Yassien
// Email       : Abdelrahman.Yassien11@gmail.com
// Created On  : 2026-02-03
//
// Description :
//   UART configuration class holding all configurable parameters such as
//   baud rate, frame format, and agent mode (active/passive).
//   Distributed to UVM components via configuration database.
//
// Parameters  :
//   BAUD_RATE   - UART baud rate (bits per second)
//   UART TXN 
// Notes:
//   - Extends uvm_object
//   - Used by driver, monitor, and agent
//
// Copyright (c) [2026] [Abdelrahman Mohamed Yassien]. All Rights Reserved.
//==============================================================================
`ifndef UART_CFG
`define UART_CFG
class uart_config extends uvm_object;
  
  // Configuration parameters
  int baud_rate; // 19200 or 115200
  real bit_period; // Calculated based on baud_rate
  
  `uvm_object_utils_begin(uart_config)
    `uvm_field_int(baud_rate, UVM_ALL_ON)
    `uvm_field_real(bit_period, UVM_ALL_ON)
  `uvm_object_utils_end
  
  function new(string name = "uart_config");
    super.new(name);
    baud_rate = 115200; // Default
    calculate_bit_period();
  endfunction
  
  function void calculate_bit_period();
    bit_period = 1000000000.0 / baud_rate; // In nanoseconds
    `uvm_info(get_type_name(), $sformatf("BIT PERIOD = %0d", bit_period), UVM_LOW)
  endfunction
  
  function void set_baud_rate(int rate);
    if (rate == 19200 || rate == 115200) begin
      baud_rate = rate;
      calculate_bit_period();
    end else begin
      `uvm_error(get_type_name(), $sformatf("Unsupported baud rate: %0d", rate))
    end
  endfunction
  
endclass

`endif