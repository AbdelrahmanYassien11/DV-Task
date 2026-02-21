//==============================================================================
// File Name   : uart_transaction.sv
// Author      : Abdelrahman Yassien
// Email       : Abdelrahman.Yassien11@gmail.com
// Created On  : 2026-02-13
//
// Description :
//   UART transaction (sequence item) class defining the UART frame fields
//   including start bits, data bits, parity bit(s), and stop bit(s).
//   Used by sequences and driver to generate UART stimulus.
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
  // rand bit [TX_DATA_WIDTH-1:0]     data;
  // rand bit [START_BITS_WIDTH-1:0]  start_bit;
  // rand bit [STOP_BITS_WIDTH-1:0]   stop_bit;
  // rand bit [PARITY_BITS_WIDTH-1:0] parity_bit;
  
  rand bit data       [];
  rand bit start_bit  [];
  rand bit stop_bit   [];
  rand bit parity_bit;

  // Constraints for proper UART protocol
  //constraint valid_start_bit  { start_bit  == 'b0; }
  constraint valid_start_bit  { foreach(start_bit[i]) start_bit[i] == 1'b0; }
  constraint valid_stop_bit   { foreach(stop_bit[i]) stop_bit[i] == 1'b1; }

  // Parity bit array must be uniform and match EVEN parity
  constraint parity_bit_c { parity_bit == calc_even_parity(data);}

  // UVM macros
  `uvm_object_utils_begin(uart_transaction)
    `uvm_field_array_int(data, UVM_ALL_ON)
    `uvm_field_array_int(start_bit, UVM_ALL_ON)
    `uvm_field_array_int(stop_bit, UVM_ALL_ON)
    `uvm_field_int(parity_bit, UVM_ALL_ON)
  `uvm_object_utils_end
  
  // Constructor
  function new(string name = "uart_transaction");
    int unsigned start_bits_width;
    int unsigned tx_data_width;
    int unsigned stop_bits_width;

    string start_bits_width_str;    
    string tx_data_width_str;
    string stop_bits_width_str;
    
    uvm_cmdline_processor clp = uvm_cmdline_processor::get_inst();

    super.new(name);

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

    start_bit   = new[start_bits_width];
    data        = new[tx_data_width];
    stop_bit    = new[stop_bits_width];

  endfunction
  
  // Convert to string for printing
  function string convert2string();
    
    // { << { parity_bit } }
    //return $sformatf(" \n ---------------------------------------------------------- Data=0x%0h, Start=%0b, Stop=%0b, Parity=%0b --------------------------------------------------------\n", 
    //                 data, start_bit, stop_bit, parity_bit);
    return $sformatf(" \n ---------------------------------------------------------- Data=%0p, Start=%0p, Stop=%0p, Parity=%0p --------------------------------------------------------\n", 
                     data, start_bit, stop_bit, parity_bit);
  endfunction
  
  function automatic bit calc_even_parity(bit data[]);
    bit p;
    p = 1'b0;
    foreach (data[i])
      p ^= data[i];
    return p;
  endfunction



endclass
`endif