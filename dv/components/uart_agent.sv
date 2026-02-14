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
  
  uart_driver uart_drv;
  uart_monitor uart_mon;
  uart_sequencer uart_seqr;
  uart_config cfg;
  uart_agent_config uart_agt_cfg;
  
  `uvm_component_utils(uart_agent)
  
  function new(string name = "uart_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    `uvm_info(get_type_name(), "Build Phase Started", UVM_LOW)

    uart_agt_cfg = uart_agent_config::type_id::create("uart_agt_cfg", this);

    // Get or create configuration
    if (!uvm_config_db#(uart_config)::get(this, "", "cfg", cfg)) begin
      cfg = uart_config::type_id::create("cfg");
      cfg.set_baud_rate(115200);
    end

    // Create components
    uart_mon = uart_monitor::type_id::create("uart_mon", this);
    uart_mon.uart_agt_cfg = uart_agt_cfg;
    
    if (uart_agt_cfg.get_is_active() == UVM_ACTIVE) begin
      uart_drv = uart_driver::type_id::create("uart_drv", this);
      uart_seqr = uart_sequencer::type_id::create("uart_seqr", this);
      uart_drv.uart_agt_cfg = uart_agt_cfg;
    end
    
    // Set configuration in config_db for child components
    uvm_config_db#(uart_config)::set(this, "*", "cfg", cfg);

    `uvm_info(get_type_name(), "Build Phase Ended", UVM_LOW)
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    `uvm_info(get_type_name(), "Connect Phase Started", UVM_LOW)
    if (uart_agt_cfg.get_is_active() == UVM_ACTIVE) begin
      uart_drv.seq_item_port.connect(uart_seqr.seq_item_export);
    end
    `uvm_info(get_type_name(), "Connect Phase Ended", UVM_LOW)
  endfunction
  
endclass

`endif