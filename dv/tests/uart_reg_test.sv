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
class uart_reg_test extends uart_base_test;
  
  `uvm_component_utils(uart_reg_test)
  
  function new(string name = "uart_reg_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    uvm_cmdline_processor clp = uvm_cmdline_processor::get_inst();
    string dummy;

    super.build_phase(phase);
    if(!(  (clp.get_arg_value("+REG_DATA_MSB_IDX=", dummy))
       & (clp.get_arg_value("+REG_DATA_LSB_IDX=",  dummy))
       & (clp.get_arg_value("+ADDR_MSB_IDX=",  dummy))
       & (clp.get_arg_value("+ADDR_LSB_IDX=",  dummy)))) begin
        `uvm_fatal(get_type_name(), "Can't Run RAL model test without adding MSB and LSB Index of ADDR & REG_DATA")
    end
  endfunction

  task main_phase(uvm_phase phase);
    uart_reg_write_seq seq;
    
    phase.raise_objection(this);
    
    `uvm_info("TEST", "========================================", UVM_LOW)
    `uvm_info("TEST", "  UART Register Model Test - Task 2.1  ", UVM_LOW)
    `uvm_info("TEST", "========================================", UVM_LOW)
    
    // Run register write sequence
    seq = uart_reg_write_seq::type_id::create("seq");
    seq.start(env_h.uart_agt.uart_seqr);
    
    // Allow time for completion
    #10us;
    
    phase.drop_objection(this);
  endtask
  
endclass