//==============================================================================
// File Name   : test_config.sv
// Author      : Abdelrahman Yassien
// Email       : Abdelrahman.Yassien11@gmail.com
// Created On  : 2026-02-13
//
// Description :
//
// Notes:
//   - Extends uvm_object
//
// Copyright (c) [2026] [Abdelrahman Mohamed Yassien]. All Rights Reserved.
//==============================================================================
`ifndef TEST_CFG
`define TEST_CFG

  class test_config extends uvm_object;
    `uvm_object_utils(test_config)

    // TEST-LEVEL settings only
    local string test_name;
    //local int unsigned num_transactions = 1000;
    local int unsigned timeout_ns = 10_000_000;
    local uvm_verbosity verbosity;

    // Random seed control
    local int unsigned seed;

    // Test scenario control
    local bit enable_error_injection = 0;

    function void set_timeout_delay(int unsigned timeout);
      this.timeout_ns = timeout;
    endfunction : set_timeout_delay

    function void set_verbosity_level(uvm_verbosity verbosity_level);
      this.verbosity = verbosity_level;
    endfunction : set_verbosity_level

    function int unsigned get_timeout_delay();
      return this.timeout_ns;
    endfunction : get_timeout_delay

    function uvm_verbosity get_verbosity_level();
      return this.verbosity;
    endfunction : get_verbosity_level

    function new(string name = "");
      super.new(name);
    endfunction

  endclass : test_config

`endif