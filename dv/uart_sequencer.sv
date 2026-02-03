//==============================================================================
// File Name   : uart_sequencer.sv
// Author      : Abdelrahman Yassien
// Email       : Abdelrahman.Yassien11@gmail.com
// Created On  : 2026-02-03
//
// Description :
//   UART sequencer class responsible for arbitrating and sending UART
//   sequence items from sequences to the UART driver.
//
// Revision History:
//   0.1 - Initial version
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
  
  `uvm_component_utils(uart_sequencer)
  
  function new(string name = "uart_sequencer", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
endclass
`endif