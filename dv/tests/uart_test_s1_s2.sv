//==============================================================================
// File Name   : uart_random_test.sv
// Author      : Abdelrahman Yassien
// Email       : Abdelrahman.Yassien11@gmail.com
// Created On  : 2026-02-03
//
// Description :
//   Randomized UART test that generates random UART frames to verify DUT
//   behavior under various data patterns and timing conditions.
//
// Revision History:
//   0.1 - Initial version
//
// Notes:
//   - Extends uart_base_test
//   - Uses randomized UART sequences
//
// Copyright (c) [2026] [Abdelrahman Mohamed Yassien]. All Rights Reserved.
//==============================================================================
`ifndef UART_S1_S2_TST
`define UART_S1_S2_TST
class uart_test_seq1_seq2 extends uart_base_test;
  
  `uvm_component_utils(uart_test_seq1_seq2)
  
  function new(string name = "uart_test_seq1_seq2", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  task main_phase(uvm_phase phase);
    uart_seq1 seq1;
    uart_seq2 seq2;
    real bit_time = cfg.bit_period;

    phase.raise_objection(this);
    
    // Run sequence 1 (10 valid transactions)
    `uvm_info(get_type_name(), "Starting Sequence 1 - Valid Transactions", UVM_LOW)
    seq1 = uart_seq1::type_id::create("seq1");
    seq1.start(env_h.uart_agt.uart_seqr);
    
    // Pause for 10 microseconds
    `uvm_info(get_type_name(), "Pausing for 1 millisecond", UVM_LOW)
    #1000_000;
    
    // Run sequence 2 (10 transactions with errors)
    `uvm_info(get_type_name(), "Starting Sequence 2 - Error Transactions", UVM_LOW)
    seq2 = uart_seq2::type_id::create("seq2");
    seq2.start(env_h.uart_agt.uart_seqr);

    // Allow some time for monitor to collect last transactions
    #(bit_time / 2);
    
    phase.drop_objection(this);
  endtask
  
endclass
`endif