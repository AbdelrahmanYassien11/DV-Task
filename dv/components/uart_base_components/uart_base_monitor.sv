//==============================================================================
// File Name   : uart_base_monitor.sv
// Author      : Abdelrahman Yassien
// Email       : Abdelrahman.Yassien11@gmail.com
// Created On  : 2026-02-13
//
// Description :
// Contains the needed base elements by the monitors and the TLM Components required
// for comunication with the rest of the Environment
//
// Copyright (c) [2026] [Abdelrahman Mohamed Yassien]. All Rights Reserved.
//==============================================================================
`ifndef UART_BASE_MON
`define UART_BASE_MON

class uart_base_monitor extends uvm_monitor;

  // Virtual Interface Handle
  protected virtual uart_if vif;

  // UART Config Object Handle
  uart_config cfg;

  // UART Agent Config Handle
  uart_agent_config uart_agt_cfg;

  // Number of monitored sequence items
  protected int unsigned mon_pkts;
  
  // TLM Component to write monitored items to ENV -> SCB/SUB
  uvm_analysis_port#(uart_transaction) item_collected_port;
  
  //-------------------------------------------
  // Declare TLM component for sequence change to notify 
  // the component when it happens, effectively killing its process  
  //-------------------------------------------
  uvm_analysis_export #(bit) seq_change_exp;
  uvm_tlm_analysis_fifo #(bit) seq_change_fifo;

  // Registering Component within the Factory
  `uvm_component_utils(uart_base_monitor)
  
    // ======================================================== Constructor
  function new(string name = "uart_base_monitor", uvm_component parent = null);
    super.new(name, parent);
    // Constructing TLM Components
    seq_change_exp      = new ("seq_change_exp", this);
    seq_change_fifo     = new ("seq_change_fifo", this);
    item_collected_port = new("item_collected_port", this);
  endfunction

  // ======================================================== Build Phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_type_name(), "Build Phase Started", UVM_LOW)

    // Getting Virtual Interface Instance / Handle
    this.vif = uart_agt_cfg.get_vif();
    
    // Getter Function for UART Config Object
    if (!uvm_config_db#(uart_config)::get(this, "", "cfg", cfg))
      `uvm_fatal(get_type_name(), "Configuration object not found")

    `uvm_info(get_type_name(), "Build Phase Ended", UVM_LOW)
  endfunction


  // ======================================================== Connect Phase
  function void connect_phase( uvm_phase phase);
    super.connect_phase(phase);
    // Connecting TLM Components
    seq_change_exp.connect(seq_change_fifo.analysis_export);
  endfunction : connect_phase

  // ======================================================== Main Phase
  task main_phase(uvm_phase phase);
    bit seq_change;
    super.main_phase(phase);
    `uvm_info(get_type_name(),"MAIN PHASE STARTED", UVM_LOW)
    
    // Loop to ensure that the monitor handles sequence changes and process 
    // killing correctly while keeping the driving functionality valid and 
    // as inteded by the protocol  
    while(1) begin
      fork
        begin
          collect_transaction();
        end
        begin
          seq_change_fifo.get(seq_change);
          seq_change = 0;
        end
      join_any;
      disable fork;
      seq_change_fifo.get(seq_change);
      seq_change = 0;
    end
  endtask

  // Task to collect transaction to be defined by monitor components
  virtual task collect_transaction();
    `uvm_fatal(get_type_name(), "Base Monitor Virtual Task Must be Overridden in Monitor");
  endtask : collect_transaction

  // ======================================================== Report Phase
  function void report_phase(uvm_phase phase);
    $display("===================================================================================================================");
    `uvm_info(get_type_name(), 
              $sformatf("\n Report:\n\t                             Total pkts: %0d", mon_pkts), UVM_LOW)

    `uvm_info(get_type_name(), " Report Phase Complete", UVM_LOW)
    $display("===================================================================================================================");
  endfunction : report_phase

endclass //uart_base_monitor
`endif  // UART_BASE_MON