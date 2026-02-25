//==============================================================================
// File Name   : base_vseq.sv
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

`ifndef base_vseq
`define base_vseq
class base_vseq extends uvm_sequence;

  // Sequencer Handles
  uart_sequencer		  UART_seqr;
  //rst_sequencer     seqr_RST;

  // Registering Object into Factory
  `uvm_object_utils(base_vseq)

  // Declaring p_sequencer and giving it the virtual sequencer handle
  `uvm_declare_p_sequencer(v_sequencer)

  // ======================================================== Constructor
  function new (string name = "base_vseq");
    super.new(name);
  endfunction

  // ======================================================== Body Task
  virtual task body();
    `uvm_fatal(get_type_name(), "Inside Body");
  endtask

endclass

`endif