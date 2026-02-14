//==============================================================================
// File Name   : uart_driver.sv
// Author      : Abdelrahamn Yassien
// Email       : Abdelrahman.Yassien11@gmail.com
// Created On  : 2026-02-03
//
// Description :
//   UART driver module/class responsible for generating UART transactions
//   according to the configured baud rate and frame format. Used for driving
//   stimulus to the DUT in simulation.
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
//  Copyright (c) [2026] [Abdelrahman Mohamed Yassien]. All Rights Reserved.
//==============================================================================

`ifndef UART_BASE_DRV
`define UART_BASE_DRV

virtual class uart_base_driver extends uvm_driver#(uart_transaction);
  
  virtual uart_if vif;
  uart_config cfg;
  uart_agent_config uart_agt_cfg;
  protected int driven_pkts;
  protected real bit_time;
  
  `uvm_component_utils(uart_base_driver)
  
  function new(string name = "uart_base_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_type_name(), "Build Phase Started", UVM_LOW)

    this.vif = uart_agt_cfg.get_vif();

    // Getter Function for Virtual Interface

    // Getter Function for UART Config Object    
    if (!uvm_config_db#(uart_config)::get(this, "", "cfg", cfg))
      `uvm_fatal(get_type_name(), "Configuration object not found")

    bit_time = cfg.bit_period;

    `uvm_info(get_type_name(), "Build Phase Ended", UVM_LOW)
  endfunction
  
  task reset_phase(uvm_phase phase);
    super.reset_phase(phase);
    `uvm_info(get_type_name(),"RESET PHASE STARTED", UVM_LOW)
    phase.raise_objection(this);

    // Before reset, TX should be X
    vif.driver_cb.tx <= 1'bx;

    // Apply reset
    vif.rst <= 1'b1;
    repeat(10) @(posedge vif.clk);
    vif.rst <= 1'b0;
    
    // After reset, TX should be 1 (idle state)
    vif.driver_cb.tx <= 1'b1;
    repeat(5) @(posedge vif.clk);
    
    phase.drop_objection(this);
    `uvm_info(get_type_name(),"RESET PHASE ENDED", UVM_LOW)
  endtask

  task main_phase(uvm_phase phase);
    super.main_phase(phase);
    `uvm_info(get_type_name(),"MAIN PHASE STARTED", UVM_LOW)
    
    forever begin
      seq_item_port.get_next_item(req);
      drive_transaction(req);
      driven_pkts++;
      seq_item_port.item_done();
    end
  endtask

  pure virtual task drive_transaction(uart_transaction trans);

  // Report Phase
  function void report_phase(uvm_phase phase);
    $display("===================================================================================================================");
    `uvm_info(get_type_name(), 
              $sformatf("\n Report:\n\t                             Total pkts: %0d", driven_pkts), UVM_LOW)

    `uvm_info(get_type_name(), " Report Phase Complete", UVM_LOW)
    $display("===================================================================================================================");
  endfunction : report_phase

endclass // uart_base_driver

`endif // UART_BASE_DRV