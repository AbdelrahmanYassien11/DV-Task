//==============================================================================
// File Name   : uart_sequencer.sv
// Author      : Abdelrahman Yassien
// Email       : Abdelrahman.Yassien11@gmail.com
// Created On  : 2026-02-13
//
// Description :
//   UART sequencer class responsible for arbitrating and sending UART
//   sequence items from sequences to the UART driver.
//
// Notes:
//   - Extends uvm_sequencer #(uart_transaction)
//   - Controls the flow of UART transactions
//
// Copyright (c) [2026] [Abdelrahman Mohamed Yassien]. All Rights Reserved.
//==============================================================================
`ifndef UART_SEQR
`define UART_SEQR

class uart_sequencer extends uvm_sequencer#(uart_transaction);
  
  // Registering Component within Factory
  `uvm_component_utils(uart_sequencer)
  
  // ======================================================== Constructor
  function new(string name = "uart_sequencer", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
endclass
`endif