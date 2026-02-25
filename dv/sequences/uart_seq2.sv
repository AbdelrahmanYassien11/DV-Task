//==============================================================================
// File Name   : uart_seq2.sv
// Author      : Abdelrahman Yassien
// Email       : Abdelrahman.Yassien11@gmail.com
// Created On  : 2026-02-13
//
// Description :
//   UART sequence definitions for generating UART transaction stimulus,
//   including random and directed test scenarios.
//
// Notes:
//   - Contains base sequence and derived sequences
//   - Used by UART driver through sequence items
//
// Copyright (c) [2026] [Abdelrahman Mohamed Yassien]. All Rights Reserved.
//==============================================================================
`ifndef UART_SEQ2
`define UART_SEQ2
class uart_seq2 extends uvm_sequence#(uart_transaction);
  
  `uvm_object_utils(uart_seq2)
  
  function new(string name = "uart_seq2");
    super.new(name);
  endfunction
  
  task body();
    uart_transaction trans;
    bit v;
    
    repeat(10) begin
      trans = uart_transaction::type_id::create("trans");
      start_item(trans);
      
      // Randomize with constraints disabled to allow errors
      assert(trans.randomize());
          
      randcase
        1: begin
            v = $urandom_range(0,1);
            trans.start_bit = '{default: v};
        end

        1: begin
            v = $urandom_range(0,1);
            foreach (trans.stop_bit[i]) begin
              trans.stop_bit[i] = v;
            end
        end
      endcase

      finish_item(trans);
      `uvm_info(get_type_name(), $sformatf("Sent error transaction: %s", trans.convert2string()), UVM_MEDIUM)
    end

    `uvm_info(get_type_name(), "Error Injection Sequence - Finished", UVM_LOW)

  endtask
  
endclass
`endif