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
`ifndef TASK2_1_TST
`define TASK2_1_TST
class task2_1_test extends uart_base_test;
  
  `uvm_component_utils(task2_1_test)
  
  function new(string name = "task2_1_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    uvm_cmdline_processor clp = uvm_cmdline_processor::get_inst();
    string dummy;

    // Call the build_phase method of the base class
    super.build_phase(phase);


    if(!(  (clp.get_arg_value("+REG_DATA_MSB_IDX=", dummy))
       & (clp.get_arg_value("+REG_DATA_LSB_IDX=",  dummy))
       & (clp.get_arg_value("+ADDR_MSB_IDX=",  dummy))
       & (clp.get_arg_value("+ADDR_LSB_IDX=",  dummy)))) begin
        `uvm_fatal(get_type_name(), "Can't Run RAL model test without adding MSB and LSB Index of ADDR & REG_DATA")
    end

    // Override the type of sequence used by the base_sequence class
    base_vseq::type_id::set_type_override(task2_1_vseq::type_id::get());

    // Display a message indicating the build phase of the test
    `uvm_info(get_type_name(), "Build Phase", UVM_LOW)

    `uvm_info("TEST", "=============================================", UVM_LOW)
    `uvm_info("TEST", "  UART Sequence Valid & Error Test - Task 1  ", UVM_LOW)
    `uvm_info("TEST", "=============================================", UVM_LOW)
  endfunction
  
endclass

`endif