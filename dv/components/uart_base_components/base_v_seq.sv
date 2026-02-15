`ifndef BASE_V_SEQ
`define BASE_V_SEQ
class base_v_seq extends uvm_sequence;
  // reset_sequence rst_seq;
    
  uart_sequencer		  UART_seqr;
  //rst_sequencer     seqr_RST;
  test_config test_cfg;
  //int test_timeout;

  `uvm_object_utils(base_v_seq)
  `uvm_declare_p_sequencer(virtual_sequencer)

  function new (string name = "base_v_seq");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), "base_v_seq: Inside Body", UVM_LOW);
  endtask

endclass

`endif