//==============================================================================
// File Name   : uart_base_driver.sv
// Author      : Abdelrahamn Yassien
// Email       : Abdelrahman.Yassien11@gmail.com
// Created On  : 2026-02-03
//
// Description :
// Contains the needed base elements by the drivers and the TLM Components required
// for comunication with the rest of the Environment (sequencer, specially)
//
// Revision History:
//   0.1 - Initial version
//
//  Copyright (c) [2026] [Abdelrahman Mohamed Yassien]. All Rights Reserved.
//==============================================================================

`ifndef UART_BASE_DRV
`define UART_BASE_DRV

class uart_base_driver extends uvm_driver#(uart_transaction);

  // Virtual Interface Handle
  protected virtual uart_if vif;

  // UART Config Object Handle
  uart_config cfg;

  // UART Agent Config Handle
  uart_agent_config uart_agt_cfg;

  // Number of driven sequence items
  protected int unsigned driven_pkts;

  // Value of the time between each bit transfer
  protected real bit_time;

  //----------------------------------------------- 
  // Declare TLM component for sequence change to notify 
  // the component when it happens, effectively killing its process 
  // Probably obsolete in the driver, but lets keep it for now
  //-----------------------------------------------------
  uvm_analysis_export #(bit) seq_change_exp;
  uvm_tlm_analysis_fifo #(bit) seq_change_fifo;
  

  // Registering the Component within the Factory
  `uvm_component_utils(uart_base_driver)
  
  // ======================================================== Constructor
  function new(string name = "uart_base_driver", uvm_component parent = null);
    super.new(name, parent);

    // Constructing TLM Components
    seq_change_exp     = new ("seq_change_exp", this);
    seq_change_fifo    = new ("seq_change_fifo", this);
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

    // To be used while driving
    bit_time = cfg.bit_period;

    `uvm_info(get_type_name(), "Build Phase Ended", UVM_LOW)
  endfunction

  // ======================================================== Connect Phase
  function void connect_phase( uvm_phase phase);
    super.connect_phase(phase);
    // Connecting TLM Components
    seq_change_exp.connect(seq_change_fifo.analysis_export);
  endfunction : connect_phase

  // ======================================================== Reset Phase
  task reset_phase(uvm_phase phase);
    super.reset_phase(phase);
    `uvm_info(get_type_name(),"RESET PHASE STARTED", UVM_LOW)
    phase.raise_objection(this);

    // Before reset, TX should be X
    vif.tx <= 1'bx;

    // Apply reset
    vif.rst <= 1'b1;
    repeat(10) @(posedge vif.clk);
    vif.rst <= 1'b0;
    
    // After reset, TX should be 1 (idle state)
    vif.tx <= 1'b1;
    repeat(5) @(posedge vif.clk);
    
    phase.drop_objection(this);
    `uvm_info(get_type_name(),"RESET PHASE ENDED", UVM_LOW)
  endtask

  // ======================================================== Main Phase
  task main_phase(uvm_phase phase);
    
    // To be used to identify when a sequence change has occured.
    bit seq_change;
    super.main_phase(phase);
    `uvm_info(get_type_name(),"MAIN PHASE STARTED", UVM_LOW)

    // Loop to ensure that the driver handles sequence changes and process 
    // killing correctly while keeping the driving functionality valid and 
    // as inteded by the protocol
    while(1) begin
      fork
        begin
          drive_transaction();
        end
        begin
          seq_change_fifo.get(seq_change);
          $display("FRAIL, THE SKIN IS DRY AND PALE");
          seq_change = 0;
        end
      join_any;
      disable fork;
      seq_change_fifo.get(seq_change);
      seq_change = 0;
    end
  endtask

  virtual task drive_transaction();
    `uvm_fatal(get_type_name(), "Base Driver Virtual Task Must be Overridden in Driver");
  endtask : drive_transaction

  // ======================================================== Report Phase
  function void report_phase(uvm_phase phase);
    $display("===================================================================================================================");
    `uvm_info(get_type_name(), 
              $sformatf("\n Report:\n\t                             Total pkts: %0d", driven_pkts), UVM_LOW)

    `uvm_info(get_type_name(), " Report Phase Complete", UVM_LOW)
    $display("===================================================================================================================");
  endfunction : report_phase

endclass // uart_base_driver

`endif // UART_BASE_DRV