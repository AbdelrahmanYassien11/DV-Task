// Register Adapter
class uart_reg_adapter extends uvm_reg_adapter;
  
  `uvm_object_utils(uart_reg_adapter)
  
  function new(string name = "uart_reg_adapter");
    super.new(name);
  endfunction
  
  // Convert register transaction to bus (UART) transaction
  virtual function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
    uart_transaction trans = uart_transaction::type_id::create("trans");
    
    // Encode register operation into UART data byte
    // Bit 0: operation (0=read, 1=write)
    // Bits [3:1]: address
    // Bits [7:4]: data
    trans.is_write = (rw.kind == UVM_WRITE);
    trans.addr = rw.addr[2:0];
    trans.reg_data = rw.data[3:0];
    trans.encode_reg_fields();
    
    // Set valid UART framing
    trans.start_bit = 1'b0;
    trans.stop_bit = 1'b1;
    trans.parity_bit = ^trans.data;
    
    `uvm_info(get_type_name(), $sformatf("REG2BUS: %s Addr=0x%0h Data=0x%0h -> UART byte=0x%02h", 
              rw.kind == UVM_WRITE ? "WRITE" : "READ", rw.addr, rw.data[3:0], trans.data), UVM_HIGH)
    
    return trans;
  endfunction
  
  // Convert bus (UART) transaction to register transaction
  virtual function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
    uart_transaction trans;
    
    if (!$cast(trans, bus_item)) begin
      `uvm_fatal(get_type_name(), "Failed to cast bus_item to uart_transaction")
    end
    
    // Decode UART byte into register operation
    trans.decode_reg_fields();
    
    rw.kind = trans.is_write ? UVM_WRITE : UVM_READ;
    rw.addr = trans.addr;
    rw.data = trans.reg_data;
    rw.status = UVM_IS_OK;
    
    `uvm_info(get_type_name(), $sformatf("BUS2REG: UART byte=0x%02h -> %s Addr=0x%0h Data=0x%0h", 
              trans.data, rw.kind == UVM_WRITE ? "WRITE" : "READ", rw.addr, rw.data), UVM_HIGH)
  endfunction
  
endclass