//==============================================================================
// File Name   : base_v_seq.sv
// Author      : Abdelrahman Yassien
// Email       : Abdelrahman.Yassien11@gmail.com
// Created On  : 2026-02-03
//
// Description :
// Base Virtual Sequence that is the parent to the other virtual sequqences.
// It defines necessary elements needed by the virtual sequences
// p_sequencer is also declared within it.
//
// Copyright (c) [2026] [Abdelrahman Mohamed Yassien]. All Rights Reserved.
//==============================================================================

`ifndef BASE_V_SEQ
`define BASE_V_SEQ
class base_v_seq extends uvm_sequence;

  // Sequencer Handles
  uart_sequencer		  UART_seqr;
  //rst_sequencer     seqr_RST;

  // Registering Object into Factory
  `uvm_object_utils(base_v_seq)

  // Declaring p_sequencer and giving it the virtual sequencer handle
  `uvm_declare_p_sequencer(v_sequencer)

  // ======================================================== Constructor
  function new (string name = "base_v_seq");
    super.new(name);
  endfunction

  // ======================================================== Body Task
  virtual task body();
    `uvm_fatal(get_type_name(), "Inside Body");
  endtask

endclass

`endif