//==============================================================================
// File Name   : uart_driver.sv
// Author      : Abdelrahamn Yassien
// Email       : Abdelrahman.Yassien11@gmail.com
// Created On  : 2026-02-13
//
// Description :
//   UART driver module/class responsible for generating UART transactions
//   according to the configured baud rate and frame format. Used for driving
//   stimulus to the DUT in simulation.
//
//  Copyright (c) [2026] [Abdelrahman Mohamed Yassien]. All Rights Reserved.
//==============================================================================

`ifndef UART_DRV
`define UART_DRV

class uart_driver extends uart_base_driver;

  // Registering Component within Factory
  `uvm_component_utils(uart_driver)
  
  // ======================================================== Constructor
  function new(string name = "uart_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction 

  // Task that does the driving, it changes the packed type data array to unpacked type
  // which allows scalability, meaning, TX Data, Start, Stop, or Parity bits widths can change
  // and the Driver would still behave according to protocol
  virtual task drive_transaction();
    uart_transaction trans;
    forever begin
      seq_item_port.get_next_item(trans);
      driven_pkts++;
      `uvm_info(get_type_name(), $sformatf("Driving Item Number %0d: %s", driven_pkts, trans.convert2string()), UVM_LOW)

      // Send start bit
      vif.header_view = START;
      vif.state_view  = state_e'(trans.start_bit[0]);
      uart_bits_sender({ << { trans.start_bit } });

      // Send data bits (LSB first)
      vif.header_view = TX_ON;
      vif.state_view  = TX;
      uart_bits_sender({ << { trans.data } });

      // Send parity bit
      uart_bits_sender({ << { trans.parity_bit } });
      
      // Send stop bits
      vif.header_view = STOP;
      vif.state_view  = state_e'(~trans.stop_bit[0]);
      uart_bits_sender({ << { trans.stop_bit } });

      seq_item_port.item_done();

      // No delay between transmissions as per requirement
    end
  endtask
  
  // A task that sends the bits over the TX wire using the virtual interface
  // Using Dynamic Arrays allows scalability
  task uart_bits_sender (bit uart_tx[]);
    foreach(uart_tx[i]) begin
      vif.tx <= uart_tx[i];
      #bit_time;
    end
  endtask : uart_bits_sender

endclass

`endif // UART_DRV