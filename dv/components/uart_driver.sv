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

class uart_driver extends uart_base_driver;
  
  `uvm_component_utils(uart_driver)
  
  function new(string name = "uart_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction 

  task drive_transaction(uart_transaction trans);

    `uvm_info(get_type_name(), $sformatf("Driving: %s", trans.convert2string()), UVM_MEDIUM)

    // Send start bit
    vif.header_view = START;
    vif.state_view  = state_e'(trans.start_bit);
    uart_bits_sender({ << { trans.start_bit } });


    // Send data bits (LSB first)
    vif.header_view = TX_ON;
    vif.state_view  = TX;
    uart_bits_sender({ << { trans.data } });

    // Send parity bit
    uart_bits_sender({ << { trans.parity_bit } });
    #(bit_time);
    
    // Send stop bits
    vif.header_view = STOP;
    vif.state_view  = state_e'(~trans.stop_bit);
    uart_bits_sender({ << { trans.stop_bit } });

    // No delay between transmissions as per requirement
  endtask
  
  task uart_bits_sender (bit uart_tx[]);
    foreach(uart_tx[i]) begin
      vif.driver_cb.tx <= uart_tx[i];
      #bit_time;
    end
  endtask : uart_bits_sender

endclass

`endif // UART_DRV