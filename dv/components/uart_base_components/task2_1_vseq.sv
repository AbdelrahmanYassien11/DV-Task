//==============================================================================
// File Name   : task2_1_vseq.sv
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

`ifndef TASK2_1_VSEQ
`define TASK2_1_VSEQ
class task2_1_vseq extends base_vseq;

    // Registering Object within Factory
    `uvm_object_utils(task2_1_vseq)

    // ======================================================== Constructor
    function new (string name = "task2_1_vseq");
        super.new(name);
    endfunction

    // ======================================================== Body Task
    task body();
        // Sequences Handles
        uart_reg_write_seq uart_reg_write_s;

        `uvm_info(get_type_name(), "Inside Body", UVM_LOW);

        // Creating the sequence objects using factory
        uart_reg_write_s = uart_reg_write_seq::type_id::create("uart_reg_write_s");

        // Run Reg Write Sequence  (2 Writes, 1 Valid and 1 Invalid)
        `uvm_info(get_type_name(), "Starting Reg Write Sequence - 2 Writes", UVM_LOW)
        uart_reg_write_s.start(p_sequencer.UART_seqr);
    endtask

endclass : task2_1_vseq

`endif