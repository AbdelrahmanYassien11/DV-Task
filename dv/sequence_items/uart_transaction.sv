//==============================================================================
// File Name   : uart_transaction.sv
// Author      : Abdelrahman Yassien
// Email       : Abdelrahman.Yassien11@gmail.com
// Created On  : 2026-02-03
//
// Description :
//   UART transaction (sequence item) class defining the UART frame fields
//   including start bits, data bits, parity bit(s), and stop bit(s).
//   Used by sequences and driver to generate UART stimulus.
//
// Parameters  :
//   DATA_BITS   - Number of data bits   (default 8)
//   PARITY_BITS - Number of parity bits (default 1)
//   STOP_BITS   - Number of stop bits   (default 1)
//
// Revision History:
//   0.1 - Initial version
//
// Notes:
//   - Extends uvm_sequence_item
//   - Represents a single UART frame transaction
//
// Copyright (c) [2026] [Abdelrahman Mohamed Yassien]. All Rights Reserved.
//==============================================================================
`ifndef UART_TXN
`define UART_TXN
class uart_transaction extends uvm_sequence_item;
  
  // Transaction fields
  rand bit [`TX_DATA_WIDTH-1:0]     data;
  rand bit [`START_BITS_WIDTH-1:0]  start_bit;
  rand bit [`STOP_BITS_WIDTH-1:0]   stop_bit;
  rand bit [`PARITY_BITS_WIDTH-1:0] parity_bit;
  
  // Constraints for proper UART protocol
  constraint valid_start_bit  { start_bit  == 'b0; }
  constraint valid_stop_bit   { stop_bit   == 'b1; }
  constraint valid_parity_bit { parity_bit == ^data; } // Even parity
  
  // UVM macros
  `uvm_object_utils_begin(uart_transaction)
    `uvm_field_int(data, UVM_ALL_ON)
    `uvm_field_int(start_bit, UVM_ALL_ON)
    `uvm_field_int(stop_bit, UVM_ALL_ON)
    `uvm_field_int(parity_bit, UVM_ALL_ON)
  `uvm_object_utils_end
  
  // Constructor
  function new(string name = "uart_transaction");
    super.new(name);
  endfunction
  
  // Convert to string for printing
  function string convert2string();
    return $sformatf(" \n ------------------------------------------------------------------------------------------------------ Data=0x%0h, Start=%0b, Stop=%0b, Parity=%0b --------------------------------------------------------
                       \n -----------------------------------------------------------------------------------------------------", 
                     data, start_bit, stop_bit, parity_bit);
  endfunction
  
endclass
`endif