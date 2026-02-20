//==============================================================================
// File Name   : env.sv
// Author      : Abdelrahman Yassien
// Email       : Abdelrahman.Yassien11@gmail.com
// Created On  : 2026-02-13
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
  
  // Environment Handle
  env_config env_cfg;

  // UART Agent Handle
  uart_agent uart_agt;

  // UART Agent Config Object Handle
  uart_agent_config uart_agt_cfg;

  // Virtual Sequencer Handle
  v_sequencer v_seqr;

  // Sequence Change TLM Component Handle
  uvm_analysis_port #(bit) seq_change_Env2Agt_;

  // ===== RAL Model Handles =====
  // uart_reg_block reg_model;
  // uart_reg_adapter reg_adapter;
  // =====================================

  `uvm_component_utils(env)
  
  // ======================================================== Constructor
  function new(string name = "env", uvm_component parent = null);
    super.new(name, parent);

    // Construction of TLM Component
    seq_change_Env2Agt_ = new("seq_change_Env2Agt_", this);
  endfunction
  
  // ======================================================== Body Task
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_type_name(), "Build Phase Started", UVM_LOW)
  
    // Environment Configuration Object Creation
    env_cfg  = env_config::type_id::create("env_cfg");

    // Use env_cfg settings to configure env
    // =====================================

    // =====================================

    // Environment Components Creation
    v_seqr = v_sequencer::type_id::create("v_seqr", this);
    uart_agt = uart_agent::type_id::create("uart_agt", this);

    // ===== RAL Model Creation =====
    // Create register model
    // reg_model = uart_reg_block::type_id::create("reg_model");
    // reg_model.build();
    
    // // Create adapter
    // reg_adapter = uart_reg_adapter::type_id::create("reg_adapter");
    
    // // Set register model in config_db
    // uvm_config_db#(uart_reg_block)::set(this, "*", "reg_model", reg_model);
    // ===========================

    `uvm_info(get_type_name(), "Build Phase Ended", UVM_LOW)
  endfunction
  
  // ======================================================== Connect Phase
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info(get_type_name(), "connect Phase Started", UVM_LOW)

    // Handing over the seqr handle to the v_sequencer
    v_seqr.UART_seqr = uart_agt.uart_seqr;

    // Connecting TLM Components
    v_seqr.seq_change_detected_ap.connect(seq_change_Env2Agt_);
    seq_change_Env2Agt_.connect(uart_agt.seq_change_Env2Agt_);


    // ===== RAL Model Connections =====
    // Connect register model to sequencer
    // if (uart_agt.uart_seqr != null) begin
    //   reg_model.default_map.set_sequencer(uart_agt.uart_seqr, reg_adapter);
    //   reg_model.default_map.set_auto_predict(1);
    // end
    // ===========================


    `uvm_info(get_type_name(), "Connect Phase Ended", UVM_LOW)
  endfunction
  
endclass

`endif