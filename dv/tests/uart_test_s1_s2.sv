//==============================================================================
// File Name   : uart_random_test.sv
// Author      : Abdelrahman Yassien
// Email       : Abdelrahman.Yassien11@gmail.com
// Created On  : 2026-02-13
//
// Description :
//   Randomized UART test that generates random UART frames to verify DUT
//   behavior under various data patterns and timing conditions.
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
    v_seq vs1;
    real bit_time = cfg.bit_period;
    vs1 = v_seq::type_id::create("vs1", this);

    phase.raise_objection(this);

    //v_seq.start(null); //virtual sequences can be started on NULL/no sequencer
    vs1.start(env_h.v_seqr);

    // Allow some time for monitor to collect last transactions
    #(bit_time / 2);
    
    phase.drop_objection(this);
  endtask
  
endclass
`endif