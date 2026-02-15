`ifndef V_SEQ
`define V_SEQ
class virtual_sequencer extends uvm_sequencer;
  `uvm_component_utils(virtual_sequencer)
  uart_sequencer		  UART_seqr;
  //rst_sequencer 	    RST_seqr;

  uvm_analysis_port #(bit) seq_change_detected_ap;

  function new(string name = "virtual_sequencer", uvm_component parent = null);
    super.new(name, parent);
    seq_change_detected_ap = new("seq_change_detected_ap", this);
  endfunction
endclass 

`endif