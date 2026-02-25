//==============================================================================
// File Name   : uart_reg_write_seq.sv
// Author      : Abdelrahman Yassien
// Email       : Abdelrahman.Yassien11@gmail.com
// Created On  : 2026-02-13
//
// Description :
//   UART sequence definitions for register model writing
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
  
  RegModel_SFR reg_model;
  
  function new(string name = "uart_reg_write_seq");
    super.new(name);
  endfunction
  
  task body();
    uvm_status_e status;
    bit [3:0] write_data_r1;
    bit [3:0] write_data_r2;
    bit [3:0] mirror_data_r1;
    bit [3:0] mirror_data_r2;
    
    bit write_data_r1[];
    bit write_data_r2[];

    write_data_r1 = new(reg_data_idx_MSB-reg_data_idx_LSB+1);
    write_data_r2 = new(reg_data_idx_MSB-reg_data_idx_LSB+1);

 
    // Get register model
    if(!uvm_config_db#(RegModel_SFR) :: get(uvm_root::get(), "", "reg_model", reg_model))
      `uvm_fatal(get_type_name(), "reg_model is not set at top level");

    // Generate random data
    // Not including reset val for both
    assert(std::randomize(write_data_r1) with { write_data_r1 inside {[1:15]}; }); 
    assert(std::randomize(write_data_r2) with { write_data_r2 inside {[1:9], [11:15]}; });
    
    `uvm_info(get_type_name(), "=== Starting Register Write Test ===", UVM_LOW)
    
    // Write to R1 (address 0x0)
    `uvm_info(get_type_name(), $sformatf("Writing 0x%0h to R1 (addr=0x0)", write_data_r1), UVM_LOW)
    reg_model.reg_blk.R1.write(status, write_data_r1);
    
    if (status != UVM_IS_OK) begin
      `uvm_error(get_type_name(), "R1 write failed")
    end
    
    // Small delay between writes
    #10_000ns;

    // Write to R2 (address 0x1) - should fail since it's RO
    `uvm_info(get_type_name(), $sformatf("Writing 0x%0h to R2 (addr=0x1) [RO - should not change]", write_data_r2), UVM_LOW)
    reg_model.reg_blk.R2.write(status, write_data_r2);
    
    if (status != UVM_IS_OK) begin
      `uvm_error(get_type_name(), "R2 write failed")
    end
    
    // Verify mirrored values
    mirror_data_r1 = reg_model.reg_blk.R1.get_mirrored_value();
    mirror_data_r2 = reg_model.reg_blk.R2.get_mirrored_value();
    
    `uvm_info(get_type_name(), "=== Verification Results ===", UVM_LOW)
    `uvm_info(get_type_name(), $sformatf("R1: Wrote=0x%0h, Mirrored=0x%0h, %s", 
              write_data_r1, mirror_data_r1, 
              (write_data_r1 == mirror_data_r1) ? "PASS" : "FAIL"), UVM_LOW)
    
    `uvm_info(get_type_name(), $sformatf("R2: Wrote=0x%0h, Mirrored=0x%0h (Reset=0xA), %s", 
              write_data_r2, mirror_data_r2,
              (mirror_data_r2 != write_data_r2) ? "PASS (RO protected)" : "FAIL"), UVM_LOW)
    
    // Check results
    if (write_data_r1 != mirror_data_r1) begin
      `uvm_error(get_type_name(), "R1 mirrored value mismatch!")
    end else begin
      `uvm_info(get_type_name(), "R1 verification PASSED", UVM_LOW)
    end
    
    if (mirror_data_r2 == write_data_r2) begin
      `uvm_error(get_type_name(), "R2 should remain at reset value 0xA (RO register)")
    end else begin
      `uvm_info(get_type_name(), "R2 verification PASSED (RO protection working)", UVM_LOW)
    end
    
  endtask
  
endclass