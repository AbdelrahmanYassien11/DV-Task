//==============================================================================
// File Name   : uart_agent.sv
// Author      : Abdelrahman Yassien
// Email       : Abdelrahman.Yassien11@gmail.com
// Created On  : 2026-02-03
//
// Description :
//   UART agent class encapsulating the UART driver, monitor, and sequencer.
//   Provides active and passive agent configurations for verification.
//
// Revision History:
//   0.1 - Initial version
//
// Copyright (c) [2026] [Abdelrahman Mohamed Yassien]. All Rights Reserved.
//==============================================================================
`ifndef UART_AGT
`define UART_AGT
class uart_agent extends uvm_agent;
  
  uart_driver driver;
  uart_monitor monitor;
  uart_sequencer sequencer;
  uart_config cfg;
  
  `uvm_component_utils(uart_agent)
  
  function new(string name = "uart_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    // Get or create configuration
    if (!uvm_config_db#(uart_config)::get(this, "", "cfg", cfg)) begin
      cfg = uart_config::type_id::create("cfg");
      cfg.set_baud_rate(115200);
    end
    
    // Create components
    monitor = uart_monitor::type_id::create("monitor", this);
    
    if (get_is_active() == UVM_ACTIVE) begin
      driver = uart_driver::type_id::create("driver", this);
      sequencer = uart_sequencer::type_id::create("sequencer", this);
    end
    
    // Set configuration in config_db for child components
    uvm_config_db#(uart_config)::set(this, "*", "cfg", cfg);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (get_is_active() == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction
  
endclass

`endif