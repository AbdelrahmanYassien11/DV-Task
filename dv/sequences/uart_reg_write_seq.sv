//==============================================================================
// File Name   : uart_sequences.sv
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
class uart_reg_write_seq extends uvm_sequence;
  
  `uvm_object_utils(uart_reg_write_seq)
  `uvm_declare_p_sequencer(uvm_sequencer#(uart_transaction))
  
  uart_reg_block reg_model;
  
  function new(string name = "uart_reg_write_seq");
    super.new(name);
  endfunction
  
  task body();
    uvm_status_e status;
    bit [3:0] write_data_r1;
    bit [3:0] write_data_r2;
    bit [3:0] mirror_data_r1;
    bit [3:0] mirror_data_r2;
    
    // Get register model
    if (!uvm_config_db#(uart_reg_block)::get(null, "", "reg_model", reg_model)) begin
      `uvm_fatal(get_type_name(), "Cannot get register model from config_db")
    end
    
    // Generate random data
    write_data_r1 = $urandom_range(0, 15);
    write_data_r2 = $urandom_range(0, 15);
    
    `uvm_info(get_type_name(), "=== Starting Register Write Test ===", UVM_LOW)
    
    // Write to R1 (address 0x0)
    `uvm_info(get_type_name(), $sformatf("Writing 0x%0h to R1 (addr=0x0)", write_data_r1), UVM_LOW)
    reg_model.R1.write(status, write_data_r1);
    
    if (status != UVM_IS_OK) begin
      `uvm_error(get_type_name(), "R1 write failed")
    end
    
    // Small delay between writes
    #10000s;
    
    // Write to R2 (address 0x1) - should fail since it's RO
    `uvm_info(get_type_name(), $sformatf("Writing 0x%0h to R2 (addr=0x1) [RO - should not change]", write_data_r2), UVM_LOW)
    reg_model.R2.write(status, write_data_r2);
    
    if (status != UVM_IS_OK) begin
      `uvm_error(get_type_name(), "R2 write failed")
    end
    
    // Wait for transactions to complete
    #20000;
    
    // Verify mirrored values
    mirror_data_r1 = reg_model.R1.get_mirrored_value();
    mirror_data_r2 = reg_model.R2.get_mirrored_value();
    
    `uvm_info(get_type_name(), "=== Verification Results ===", UVM_LOW)
    `uvm_info(get_type_name(), $sformatf("R1: Wrote=0x%0h, Mirrored=0x%0h, %s", 
              write_data_r1, mirror_data_r1, 
              (write_data_r1 == mirror_data_r1) ? "PASS" : "FAIL"), UVM_LOW)
    
    `uvm_info(get_type_name(), $sformatf("R2: Wrote=0x%0h, Mirrored=0x%0h (Reset=0xA), %s", 
              write_data_r2, mirror_data_r2,
              (mirror_data_r2 == 4'hA) ? "PASS (RO protected)" : "FAIL"), UVM_LOW)
    
    // Check results
    if (write_data_r1 != mirror_data_r1) begin
      `uvm_error(get_type_name(), "R1 mirrored value mismatch!")
    end else begin
      `uvm_info(get_type_name(), "✓ R1 verification PASSED", UVM_LOW)
    end
    
    if (mirror_data_r2 != 4'hA) begin
      `uvm_error(get_type_name(), "R2 should remain at reset value 0xA (RO register)")
    end else begin
      `uvm_info(get_type_name(), "✓ R2 verification PASSED (RO protection working)", UVM_LOW)
    end
    
  endtask
  
endclass