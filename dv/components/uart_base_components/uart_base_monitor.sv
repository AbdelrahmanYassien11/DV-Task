//==============================================================================
// File Name   : uart_monitor.sv
// Author      : Abdelrahman Yassien
// Email       : Abdelrahman.Yassien11@gmail.com
// Created On  : 2026-02-03
//
// Description :
//   UART monitor class responsible for sampling UART transactions from the
//   DUT interface and converting them into sequence items for analysis and
//   scoreboard checking.
//
// Parameters  :
//   BAUD_RATE   - UART baud rate (bits per second)
//   START_BITS  - Number of start bits  (default 1)
//   DATA_BITS   - Number of data bits   (default 8)
//   PARITY_BITS - Number of parity bits (default 1)
//   STOP_BITS   - Number of stop bits   (default 1)
//
// Revision History:
//   0.1 - Initial version
//
// Copyright (c) [2026] [Abdelrahman Mohamed Yassien]. All Rights Reserved.
//==============================================================================
`ifndef UART_BASE_MON
`define UART_BASE_MON

virtual class uart_base_monitor extends uvm_monitor;
  
  virtual uart_if vif;
  uart_agent_config uart_agt_cfg;
  uart_config cfg;
  local int mon_pkts;
  
  uvm_analysis_port#(uart_transaction) item_collected_port;
  
  `uvm_component_utils(uart_base_monitor)
  
  function new(string name = "uart_base_monitor", uvm_component parent = null);
    super.new(name, parent);
    item_collected_port = new("item_collected_port", this);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_type_name(), "Build Phase Started", UVM_LOW)

    this.vif = uart_agt_cfg.get_vif();
    
    // Getter Function for UART Config Object
    if (!uvm_config_db#(uart_config)::get(this, "", "cfg", cfg))
      `uvm_fatal(get_type_name(), "Configuration object not found")

    `uvm_info(get_type_name(), "Build Phase Ended", UVM_LOW)
  endfunction

  task main_phase(uvm_phase phase);
    super.main_phase(phase);
    `uvm_info(get_type_name(),"MAIN PHASE STARTED", UVM_LOW)
    
    while(1) begin
      fork
        begin
          collect_transaction();
        end
        begin
          @(posedge sequence_change_detected);
        end
      join_any;
      disable fork;
    end
  endtask

  pure virtual task collect_transaction(uart_transaction trans);

  // Report Phase
  function void report_phase(uvm_phase phase);
    $display("===================================================================================================================");
    `uvm_info(get_type_name(), 
              $sformatf("\n Report:\n\t                             Total pkts: %0d", mon_pkts), UVM_LOW)

    `uvm_info(get_type_name(), " Report Phase Complete", UVM_LOW)
    $display("===================================================================================================================");
  endfunction : report_phase

endclass //uart_base_monitor
`endif  // UART_BASE_MON