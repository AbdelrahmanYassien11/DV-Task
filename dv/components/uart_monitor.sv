//==============================================================================
// File Name   : uart_monitor.sv
// Author      : Abdelrahman Yassien
// Email       : Abdelrahman.Yassien11@gmail.com
// Created On  : 2026-02-13
//
// Description :
//   UART monitor class responsible for sampling UART transactions from the
//   DUT interface and converting them into sequence items for analysis and
//   scoreboard checking.
//
// Copyright (c) [2026] [Abdelrahman Mohamed Yassien]. All Rights Reserved.
//==============================================================================
`ifndef UART_MON
`define UART_MON

class uart_monitor extends uart_base_monitor;
  
  // Registering Component within Factory
  `uvm_component_utils(uart_monitor)

  // ======================================================== Constructor
  function new(string name = "uart_monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  // A task that is used to monitor the TX transactions on UART
  task collect_transaction();
    real bit_time = cfg.bit_period;
    bit sampled_bit;
    uart_transaction trans;
    $display(" Started Monitoring Transactions %0t", $realtime());
    forever begin
      
      // Creating everytime to prevent overwriting, because items are referenced by mem location, not value
      trans = uart_transaction::type_id::create("trans");
      
      // Sample start bit at mid-bit time
      uart_bits_collector(trans.start_bit);
      
      // Sample data bits (LSB first)
      uart_bits_collector(trans.data);
      
      // Sample parity bit
        #(bit_time / 2);
        trans.parity_bit = vif.tx;
        #(bit_time / 2);
      
      // Sample stop bit
      uart_bits_collector(trans.stop_bit);

      // Increment Monitored Items Counter
      mon_pkts++;

      // Print collected transaction
      `uvm_info(get_type_name(), $sformatf("Collected Item Number %0d: %s", mon_pkts, trans.convert2string()), UVM_LOW)
      
      // Send to analysis port
      item_collected_port.write(trans);

      //trans.decode_reg_fields();  // Decode register fields for easier viewing
    
    end
  endtask

  // A task that sends the bits over the TX wire using the virtual interface
  // Using Dynamic Arrays allows scalability
  task uart_bits_collector (inout bit uart_tx[]);
    real bit_time = cfg.bit_period;
    foreach(uart_tx[i]) begin
      #(bit_time / 2);
      uart_tx[i]= vif.tx;
      #(bit_time / 2);
    end
  endtask : uart_bits_collector

endclass
`endif