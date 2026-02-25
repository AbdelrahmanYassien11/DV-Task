//==============================================================================
// File Name   : uart_seq1.sv
// Author      : Abdelrahman Yassien
// Email       : Abdelrahman.Yassien11@gmail.com
// Created On  : 2026-02-13
//
// Description :
//   UART sequence definitions for generating UART transaction stimulus,
//   including random and directed test scenarios.
//
// Notes:
//   - Contains base sequence and derived sequences
//   - Used by UART driver through sequence items
//
// Copyright (c) [2026] [Abdelrahman Mohamed Yassien]. All Rights Reserved.
//==============================================================================
`ifndef UART_SEQ1
`define UART_SEQ1
class uart_seq1 extends uvm_sequence#(uart_transaction);
  
  `uvm_object_utils(uart_seq1)
  
  function new(string name = "uart_seq1");
    super.new(name);
  endfunction
  
  task body();
    uart_transaction trans;
    
    repeat(10) begin
      trans = uart_transaction::type_id::create("trans");
      start_item(trans);
      assert(trans.randomize());
      finish_item(trans);
      `uvm_info(get_type_name(), $sformatf("Sent valid transaction: %s", trans.convert2string()), UVM_LOW)
    end
  
    `uvm_info(get_type_name(), "FINISHED", UVM_LOW)

  endtask
  
endclass

`endif