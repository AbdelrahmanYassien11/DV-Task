////////////////////////////////////////////////////////////////////////////////
// UART UVM Testbench - Task 2.1 NEW COMPONENTS ONLY
// Add these to your existing Task 1 testbench
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// FILE 1: uart_reg_model.sv
// UVM Register Definitions and Adapter
////////////////////////////////////////////////////////////////////////////////

// Register R1: 4-bit, RW, Address 0x0, Reset 0x0
// Register R2: 4-bit, RO, Address 0x1, Reset 0xA
// class register extends uvm_reg;
    
//   `uvm_object_utils(register)
  
//   function new(string name = "register", int unsigned size = 1, uvm_coverage_model_e cov = UVM_NO_COVERAGE);
//     super.new(name, size, cov);
//   endfunction

//   virtual function void build(uvm_reg_field x[], int unsigned size, int unsigned lsb_pos, string access, bit volatile,
//                               uvm_reg_data_t reset, bit has_reset, bit is_rand, bit individually_accessible);
//     x.configure(this, size, lsb_pos, access, volatile, reset, has_reset, is_rand, individually_accessible);
//   endfunction : build
// endclass

class reg_r1#(
    int unsigned N            = 2,
    int unsigned size         = 4,
    uvm_coverage_model_e cov  = UVM_NO_COVERAGE
)extends uvm_reg;

  `uvm_object_utils(reg_r1# (N, size, cov))

  rand uvm_reg_field R1[N];

  function new(string name = "reg_r1");
    super.new(name, size, cov);
  endfunction

  virtual function void build(int unsigned size, int unsigned lsb_pos, string access, bit volatile,
                              uvm_reg_data_t reset, bit has_reset, bit is_rand, bit individually_accessible);
    foreach (R1[i]) begin
      R1[i] = uvm_reg_field::type_id::create($sformatf("R1[%0d]", i));
      // super.build(R1[i], size, lsb_pos, access, volatile, reset, has_reset, is_rand, individually_accessible);
      R1[i].configure(this, size, lsb_pos, access, volatile, reset, has_reset, is_rand, individually_accessible);
    end
  endfunction : build


endclass : reg_r1

class reg_r2#(
    int unsigned N            = 2,
    int unsigned size         = 4,
    uvm_coverage_model_e cov  = UVM_NO_COVERAGE
)extends uvm_reg;

  `uvm_object_utils(reg_r2# (N, size, cov))

  rand uvm_reg_field R2[N];

  function new(string name = "reg_r2");
    super.new(name, size, cov);
  endfunction

  virtual function void build(int unsigned size, int unsigned lsb_pos, string access, bit volatile,
                              uvm_reg_data_t reset, bit has_reset, bit is_rand, bit individually_accessible);
    foreach (R2[i]) begin
      R2[i] = uvm_reg_field::type_id::create($sformatf("R2[%0d]", i));
      //R2[i].configure( R2[i], size, lsb_pos, access, volatile, reset, has_reset, is_rand, individually_accessible);
      R2[i].configure(this, size, lsb_pos, access, volatile, reset, has_reset, is_rand, individually_accessible);    
    end
  endfunction : build

endclass : reg_r2


// Register Block
class uart_reg_block extends uvm_reg_block;
  
  rand reg_r1#(1, 4, UVM_NO_COVERAGE) R1;
  rand reg_r2#(1, 4, UVM_NO_COVERAGE) R2;
  
  `uvm_object_utils(uart_reg_block)
  
  function new(string name = "uart_reg_block");
    super.new(name, UVM_NO_COVERAGE);
  endfunction
  
  virtual function void build();
    // Create register instances
    R1 = reg_r1#(1, 4, UVM_NO_COVERAGE)::type_id::create("R1");
    R1.configure(this, null, "");
    R1.build(4, 0, "RW", 0, 4'h0, 1, 1, 1);
    
    R2 = reg_r2#(1, 4, UVM_NO_COVERAGE)::type_id::create("R2");
    R2.configure(this, null, "");
    R2.build(4, 0, "RW", 0, 4'hA, 1, 1, 1);
    
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
  rand uart_reg_block reg_blk;
  
  uvm_reg_map uart_map;
  `uvm_object_utils(RegModel_SFR)
  
  function new(string name = "RegModel_SFR");
    super.new(name, .has_coverage(UVM_NO_COVERAGE));
  endfunction
  
  virtual function void build();
    default_map = create_map("uart_map", 'h0, 4, UVM_LITTLE_ENDIAN, 0);
    
    this.add_hdl_path("tb_top.DUT");

    reg_blk = uart_reg_block::type_id::create("reg_blk");
    reg_blk.configure(this);
    reg_blk.build();
    default_map.add_submap(this.reg_blk.default_map, 0);
  endfunction
endclass
