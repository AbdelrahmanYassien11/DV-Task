//==============================================================================
// File Name   : uart_base_test.sv
// Author      : Abdelrahman Yassien
// Email       : Abdelrahman.Yassien11@gmail.com
// Created On  : 2026-02-13
//
// Description :
//   Base test class for UART verification. Provides common configuration,
//   environment creation, and utility methods for all derived UART tests.
//
// Notes:
//   - All UART tests must extend from this base test
//   - Contains default configuration and build phase logic
//
// Copyright (c) [2026] [Abdelrahman Mohamed Yassien]. All Rights Reserved.
//==============================================================================
`ifndef UART_BASE_TST
`define UART_BASE_TST
class uart_base_test extends uvm_test;
  
  local test_config test_cfg;
  env env_h;
  local uart_config cfg;

  `uvm_component_utils(uart_base_test)
  
  function new(string name = "uart_base_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Getter for Test Configuration
    if (!uvm_config_db#(test_config)::get(this, "", "test_cfg", test_cfg))
      `uvm_fatal(get_type_name(), "Could not get from the database the Test Config using name")
    
    // Create configuration
    cfg = uart_config::type_id::create("cfg");
    cfg.set_baud_rate(115200);
    
    // Set configuration in config_db
    uvm_config_db#(uart_config)::set(this, "*", "cfg", cfg);
    
    // Create environment
    env_h = env::type_id::create("env_h", this);

    `uvm_info(get_type_name(), "Build Phase", UVM_LOW)
  endfunction
  
  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
  endfunction

  task main_phase(uvm_phase phase);
    // int timeout_delay = test_cfg.get_timeout_delay();
    // super.run_phase(phase);
    // #timeout_delay;
    // `uvm_fatal(get_type_name(), "Watchdog Timeout Triggered")
    real bit_time = cfg.bit_period;

    base_vseq b_vseq;
    super.main_phase(phase);
    phase.raise_objection(this);

    `uvm_info(get_type_name(), "Main Phase Started", UVM_LOW)
  
    b_vseq = base_vseq::type_id::create("b_vseq");

    //v_seq.start(null); //virtual sequences can be started on NULL/no sequencer
    b_vseq.start(env_h.v_seqr);

    // Allow some time for monitor to collect last transactions
    #(bit_time / 2);

    phase.drop_objection(this);

  endtask : main_phase
  
  //==================
  // Report phase
  //==================
  function void report_phase(uvm_phase phase);
    uvm_report_server server = uvm_report_server::get_server();
    
    if (server.get_severity_count(UVM_FATAL) + 
        server.get_severity_count(UVM_ERROR) == 0)
      `uvm_info(get_type_name(), "TEST PASSED", UVM_LOW)
    else
      `uvm_info(get_type_name(), "TEST FAILED", UVM_LOW)
  endfunction : report_phase

endclass

`endif