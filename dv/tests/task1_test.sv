//==============================================================================
// File Name   : task1_test.sv
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
`ifndef TASK1_TST
`define TASK1_TST
class task1_test extends uart_base_test;
  
  `uvm_component_utils(task1_test)
  
  function new(string name = "task1_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Build phase where configuration and setup occur
  function void build_phase(uvm_phase phase);
    // Override the type of sequence used by the base_sequence class
    base_vseq::type_id::set_type_override(task1_vseq::type_id::get());
    // Call the build_phase method of the base class
    super.build_phase(phase);
    // Display a message indicating the build phase of the test
    `uvm_info(get_type_name(), "Build Phase", UVM_LOW)
  endfunction
  
endclass
`endif