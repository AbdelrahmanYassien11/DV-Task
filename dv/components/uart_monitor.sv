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
      for(int i = 1; i <= START_BITS_WIDTH; i++) begin
        #(bit_time / 2);
        trans.start_bit[i-1] = vif.tx;
        #(bit_time / 2);
      end
      
      // Sample data bits (LSB first)
      for (int i = 1; i <= 10; i++) begin
        #(bit_time / 2);
        trans.data[i-1] = vif.tx;
        #(bit_time / 2);
      end
      
      // Sample parity bit
      for (int i = 1; i <= PARITY_BITS_WIDTH; i++) begin
        #(bit_time / 2);
        trans.parity_bit[i-1] = vif.tx;
        #(bit_time / 2);
      end
      
      // Sample stop bit
      for (int i = 1; i <= PARITY_BITS_WIDTH; i++) begin
        #(bit_time / 2);
        trans.stop_bit[i-1] = vif.tx;
        #(bit_time / 2);
      end

      // Increment Monitored Items Counter
      mon_pkts++;

      // Print collected transaction
      `uvm_info(get_type_name(), $sformatf("Collected Item Number %0d: %s", mon_pkts, trans.convert2string()), UVM_LOW)
      
      // Send to analysis port
      item_collected_port.write(trans);    
    end
  endtask

endclass
`endif