class v_seq extends base_v_seq;
  uart_seq1 uart_s1;
  uart_seq2 uart_s2;  

  `uvm_object_utils(v_seq)

  function new (string name = "v_seq");
    super.new(name);
  endfunction

  task body();
    `uvm_info(get_type_name(), "Inside Body", UVM_LOW);
    do begin
      uart_s1 = uart_seq1::type_id::create("uart_s1");
      uart_s2 = uart_seq2::type_id::create("uart_s2");
      fork
        begin
          rst_seq.start(p_sequencer.seqr_RST);
          `uvm_info(get_name, $sformatf("seqr_RST Arbitration mode = %s", seqr_RST.get_arbitration()), UVM_LOW)
        end
        begin
        uart_s1.start(p_sequencer.UART_seqr);
        uart_s2.start(p_sequencer.UART_seqr);
        end
      join_any
            disable fork;
    end while ((!alu_seq_item::cov_target) || (!rst_seq_item::resets_done));
  endtask

endclass