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

`ifndef UART_DRV
`define UART_DRV

class uart_driver extends uvm_driver#(uart_transaction);
  
  virtual uart_if vif;
  uart_config cfg;
  
  `uvm_component_utils(uart_driver)
  
  function new(string name = "uart_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual uart_if)::get(this, "", "vif", vif))
      `uvm_fatal("DRIVER", "Virtual interface not found")
    if (!uvm_config_db#(uart_config)::get(this, "", "cfg", cfg))
      `uvm_fatal("DRIVER", "Configuration object not found")
  endfunction
  
  task main_phase(uvm_phase phase);
    super.main_phase(phase);
    `uvm_info(get_type_name(),"MAIN PHASE STARTED" ,UVM_LOW)
    phase.raise_objection(this);

    // Before reset, TX should be X
    vif.driver_cb.tx <= 1'bx;
    
    forever begin
      seq_item_port.get_next_item(req);
      drive_transaction(req);
      seq_item_port.item_done();
    end
    phase.drop_objection(this);
    `uvm_info(get_type_name(),"MAIN PHASE ENDED" ,UVM_LOW)
  endtask
  
  task drive_transaction(uart_transaction trans);
    real bit_time = cfg.bit_period;

    `uvm_info("DRIVER", $sformatf("Driving: %s", trans.convert2string()), UVM_MEDIUM)
    
    // Send start bit
    vif.driver_cb.tx <= trans.start_bit;
    vif.header = START;
    vif.state  = state_e'(trans.start_bit);
    #(bit_time);
    

    // Send data bits (LSB first)
    for (int i = 0; i < 8; i++) begin
      vif.driver_cb.tx <= trans.data[i];
      vif.header = TX_ON;
      vif.state  = TX;
      #(bit_time);
    end

    // Send parity bit
    vif.driver_cb.tx <= trans.parity_bit;
    #(bit_time);
    

    // Send stop bit
    vif.driver_cb.tx <= trans.stop_bit;
    vif.header = STOP;
    vif.state  = state_e'(~trans.stop_bit);
    #(bit_time);
    
    // No delay between transmissions as per requirement
  endtask
  
  task reset_phase(uvm_phase phase);
    super.reset_phase(phase);
    `uvm_info(get_type_name(),"RESET PHASE ENDED" ,UVM_LOW)
    phase.raise_objection(this);
    
    // Apply reset
    vif.rst <= 1'b1;
    repeat(10) @(posedge vif.clk);
    vif.rst <= 1'b0;
    
    // After reset, TX should be 1 (idle state)
    vif.driver_cb.tx <= 1'b1;
    repeat(5) @(posedge vif.clk);
    
    phase.drop_objection(this);
    `uvm_info(get_type_name(),"RESET PHASE ENDED" ,UVM_LOW)
  endtask
  
endclass

`endif // UART_DRV