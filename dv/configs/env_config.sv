//==============================================================================
// File Name   : env_config.sv
// Author      : Abdelrahman Yassien
// Email       : Abdelrahman.Yassien11@gmail.com
// Created On  : 2026-02-13
//
// Description :
//    Configuration Object used to configure the environment
//
// Notes:
//   - Extends uvm_object
//
// Copyright (c) [2026] [Abdelrahman Mohamed Yassien]. All Rights Reserved.
//==============================================================================
`ifndef ENV_CFG
`define ENV_CFG

class env_config extends uvm_object;

    // Agent configurations
    // uvm_active_passive_enum uart_agt_is_active;
    //==========================================================================
    // ENVIRONMENT STRUCTURE CONTROL
    //==========================================================================
    // What components to instantiate
    local bit has_scoreboard = 0;
    local bit has_coverage_collector = 0;
    local bit has_reg_adapter = 0;
    
    //==========================================================================
    // ENVIRONMENT-LEVEL BEHAVIOR
    //==========================================================================
    // Scoreboard settings
    
    // Coverage settings
    local bit enable_functional_coverage = 0;

    // Register with factory
    `uvm_object_utils_begin(env_config)
        `uvm_field_int(has_scoreboard, UVM_DEFAULT)
        `uvm_field_int(has_coverage_collector, UVM_DEFAULT)
        `uvm_field_int(has_reg_adapter, UVM_DEFAULT)
    `uvm_object_utils_end
    
    // Constructor
    function new(string name = "");
        super.new(name);
    endfunction : new


endclass : env_config

`endif