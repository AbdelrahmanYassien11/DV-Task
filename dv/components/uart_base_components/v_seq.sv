//==============================================================================
// File Name   : v_seq.sv
// Author      : Abdelrahman Yassien
// Email       : Abdelrahman.Yassien11@gmail.com
// Created On  : 2026-02-13
//
// Description :
// Virtual Sequence that runs the other sequences on each prespective agent
// p_sequencer is also declared within it
//
// Copyright (c) [2026] [Abdelrahman Mohamed Yassien]. All Rights Reserved.
//==============================================================================

`ifndef V_SEQ
`define V_SEQ
class v_seq extends base_v_seq;

    // Registering Object within Factory
    `uvm_object_utils(v_seq)

    // ======================================================== Constructor
    function new (string name = "v_seq");
        super.new(name);
    endfunction

    // ======================================================== Body Task
    task body();
        // Sequences Handles
        uart_seq1 uart_s1;
        uart_seq2 uart_s2;

        `uvm_info(get_type_name(), "Inside Body", UVM_LOW);

        // Creating the sequence objects using factory
        uart_s1 = uart_seq1::type_id::create("uart_s1");
        uart_s2 = uart_seq2::type_id::create("uart_s2");

        // Run sequence 1 (10 valid transactions)
        `uvm_info(get_type_name(), "Starting Sequence 1 - Valid Transactions", UVM_LOW)
        uart_s1.start(p_sequencer.UART_seqr);

        #4080ns;

        // Pause for 10 microsecond
        `uvm_info(get_type_name(), "Pausing for 10 micro second", UVM_LOW)            
        p_sequencer.seq_change_detected_ap.write(1);

        #10000ns;

        p_sequencer.seq_change_detected_ap.write(1);

        // Run sequence 2 (10 transactions with errors)
        `uvm_info(get_type_name(), "Starting Sequence 2 - Error Transactions", UVM_LOW)
        uart_s2.start(p_sequencer.UART_seqr);
    endtask

endclass : v_seq

`endif