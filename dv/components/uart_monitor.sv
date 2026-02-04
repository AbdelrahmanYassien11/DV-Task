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
`ifndef UART_MON
`define UART_MON

class uart_monitor extends uvm_monitor;
  
  virtual uart_if vif;
  uart_config cfg;
  
  uvm_analysis_port#(uart_transaction) item_collected_port;
  
  `uvm_component_utils(uart_monitor)
  
  function new(string name = "uart_monitor", uvm_component parent = null);
    super.new(name, parent);
    item_collected_port = new("item_collected_port", this);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual uart_if)::get(this, "", "vif", vif))
      `uvm_fatal("MONITOR", "Virtual interface not found")
    if (!uvm_config_db#(uart_config)::get(this, "", "cfg", cfg))
      `uvm_fatal("MONITOR", "Configuration object not found")
  endfunction
  
  task run_phase(uvm_phase phase);
    uart_transaction trans;
    
    // Wait for reset to complete
    @(negedge vif.rst);
    repeat(10) @(posedge vif.clk);
    
    forever begin
      trans = uart_transaction::type_id::create("trans");
      collect_transaction(trans);
      
      // Print collected transaction
      `uvm_info("MONITOR", $sformatf("Collected: %s", trans.convert2string()), UVM_HIGH)
      
      // Send to analysis port
      item_collected_port.write(trans);
    end
  endtask
  
  task collect_transaction(uart_transaction trans);
    real bit_time = cfg.bit_period;
    bit sampled_bit;
    
    // Wait for start bit (transition from 1 to 0)
    wait(vif.monitor_cb.tx == 1'b0);
    
    // Sample start bit at mid-bit time
    #(bit_time / 2);
    trans.start_bit = vif.tx;
    #(bit_time / 2);
    
    // Sample data bits (LSB first)
    for (int i = 0; i < 8; i++) begin
      #(bit_time / 2);
      trans.data[i] = vif.tx;
      #(bit_time / 2);
    end
    
    // Sample parity bit
    #(bit_time / 2);
    trans.parity_bit = vif.tx;
    #(bit_time / 2);
    
    // Sample stop bit
    #(bit_time / 2);
    trans.stop_bit = vif.tx;
    #(bit_time / 2);
    
  endtask
  
endclass
`endif