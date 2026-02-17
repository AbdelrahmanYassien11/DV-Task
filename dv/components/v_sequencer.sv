//==============================================================================
// File Name   : v_sequencer.sv
// Author      : Abdelrahman Yassien
// Email       : Abdelrahman.Yassien11@gmail.com
// Created On  : 2026-02-15
//
// Description :
// Virtual Sequencer used to run virtual sequences (Not needed) and also
// Contains handles of the different seequencers for each agent
// and also contains TLM ports between virtual sequence and the rest of the
// Environment
//
// Copyright (c) [2026] [Abdelrahman Mohamed Yassien]. All Rights Reserved.
//==============================================================================
`ifndef V_SEQR
`define V_SEQR
class v_sequencer extends uvm_sequencer;
  `uvm_component_utils(v_sequencer)
  uart_sequencer		  UART_seqr;
  //rst_sequencer 	    RST_seqr;

  // Declaring TLM Analysis Port
  // Which is used to detect sequence changes
  // and accordingly notify the UART Agent
  uvm_analysis_port #(bit) seq_change_detected_ap;

  // ======================================================== Constructor
  function new(string name = "v_sequencer", uvm_component parent = null);
    super.new(name, parent);
    seq_change_detected_ap = new("seq_change_detected_ap", this);
  endfunction
endclass 

`endif