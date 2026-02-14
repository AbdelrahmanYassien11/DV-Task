//==============================================================================
// File Name   : env.sv
// Author      : Abdelrahman Yassien
// Email       : Abdelrahman.Yassien11@gmail.com
// Created On  : 2026-02-03
//
// Description :
//   UART verification environment containing UART agent(s), scoreboard,
//   and coverage components for end-to-end UART protocol verification.
//
// Notes:
//   - Top-level verification environment
//   - Connects agent to scoreboard and coverage
//
// Copyright (c) [2026] [Abdelrahman Mohamed Yassien]. All Rights Reserved.
//==============================================================================
`ifndef ENV
`define ENV

class env extends uvm_env;
  
  env_config env_cfg;

  uart_agent uart_agt;
  uart_agent_config uart_agt_cfg;
  
  `uvm_component_utils(env)
  
  function new(string name = "env", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_type_name(), "Build Phase Started", UVM_LOW)
    env_cfg  = env_config::type_id::create("env_cfg");

    // Use env_cfg settings to configure env
    // =====================================

    // =====================================
    uart_agt = uart_agent::type_id::create("uart_agt", this);
    //uart_agt_cfg = uart_agent_config::type_id::create("uart_agt_cfg");
    `uvm_info(get_type_name(), "Build Phase Ended", UVM_LOW)
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info(get_type_name(), "connect Phase Started", UVM_LOW)
    `uvm_info(get_type_name(), "Connect Phase Ended", UVM_LOW)
  endfunction
  
endclass

`endif