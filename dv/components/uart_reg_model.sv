////////////////////////////////////////////////////////////////////////////////
// UART UVM Testbench - Task 2.1 NEW COMPONENTS ONLY
// Add these to your existing Task 1 testbench
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// FILE 1: uart_reg_model.sv
// UVM Register Definitions and Adapter
////////////////////////////////////////////////////////////////////////////////

// Register R1: 4-bit, RW, Address 0x0, Reset 0x0
class reg_r1 extends uvm_reg;
  
  rand uvm_reg_field R1;
  
  `uvm_object_utils(reg_r1)
  
  function new(string name = "reg_r1");
    super.new(name, 4, UVM_NO_COVERAGE);
  endfunction
  
  virtual function void build();
    R1 = uvm_reg_field::type_id::create("R1");
    R1.configure(this, 4, 0, "RW", 0, 4'h0, 1, 1, 1);
  endfunction
  
endclass

// Register R2: 4-bit, RO, Address 0x1, Reset 0xA
class reg_r2 extends uvm_reg;
  
  rand uvm_reg_field R2;
  
  `uvm_object_utils(reg_r2)
  
  function new(string name = "reg_r2");
    super.new(name, 4, UVM_NO_COVERAGE);
  endfunction
  
  virtual function void build();
    R2 = uvm_reg_field::type_id::create("R2");
    R2.configure(this, 4, 0, "RO", 0, 4'hA, 1, 1, 1);
  endfunction
  
endclass

// Register Block
class uart_reg_block extends uvm_reg_block;
  
  rand reg_r1 R1;
  rand reg_r2 R2;
  
  `uvm_object_utils(uart_reg_block)
  
  function new(string name = "uart_reg_block");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
  
  virtual function void build();
    // Create register instances
    R1 = reg_r1::type_id::create("R1");
    R1.configure(this, null, "");
    R1.build();
    
    R2 = reg_r2::type_id::create("R2");
    R2.configure(this, null, "");
    R2.build();
    
    // Create address map
    default_map = create_map("default_map", 'h0, 1, UVM_LITTLE_ENDIAN);
    
    // Add registers to map
    default_map.add_reg(R1, 'h0, "RW");
    default_map.add_reg(R2, 'h1, "RO");
    
    lock_model();
  endfunction
  
endclass

// Top Level class: SFR Reg Model
class RegModel_SFR extends uvm_reg_block;
  rand uart_reg_block uart_reg_blk;
  
  uvm_reg_map uart_map;
  `uvm_object_utils(RegModel_SFR)
  
  function new(string name = "RegModel_SFR");
    super.new(name, .has_coverage(UVM_NO_COVERAGE));
  endfunction
  
  virtual function void build();
    default_map = create_map("uart_map", 'h0, 4, UVM_LITTLE_ENDIAN, 0);
    
    this.add_hdl_path("tb_top.DUT");

    uart_reg_blk = uart_reg_block::type_id::create("uart_reg_blk");
    uart_reg_blk.configure(this);
    uart_reg_blk.build();
    default_map.add_submap(this.uart_reg_blk.default_map, 0);
  endfunction
endclass
