//==============================================================================
// File Name   : uart_env.sv
// Author      : Abdelrahman Yassien
// Email       : Abdelrahman.Yassien11@gmail.com
// Created On  : 2026-02-03
//
// Description :
//   UART verification environment containing UART agent(s), scoreboard,
//   and coverage components for end-to-end UART protocol verification.
//
// Revision History:
//   0.1 - Initial version
//
// Notes:
//   - Top-level verification environment
//   - Connects agent to scoreboard and coverage
//
// Copyright (c) [2026] [Abdelrahman Mohamed Yassien]. All Rights Reserved.
//==============================================================================
`ifndef UART_ENV
`define UART_ENV

class uart_env extends uvm_env;
  
  uart_agent agent;
  
  `uvm_component_utils(uart_env)
  
  function new(string name = "uart_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_type_name(), "Build Phase Started", UVM_LOW)
    agent = uart_agent::type_id::create("agent", this);
    `uvm_info(get_type_name(), "Build Phase Ended", UVM_LOW)
  endfunction
  
endclass

`endif