/******************************************************************
 * File:   uart_agent_config.sv
 * Author: Abdelrahman Yassien
 * Email:  Abdelrahman.Yassien11@gmail.com
 * Date:   01/10/2025
 * Description: This file is the uart agent config, where the uart
 *              agent config's logic is implemented as well as needed 
 *              TLM connections.
 * 
 * Copyright (c) [2025] Abdelrahman Yassien. All Rights Reserved.
 * This file is part of the verification of AMBA uart Project.
  ******************************************************************/
`ifndef UART_AGT_CFG
`define UART_AGT_CFG

class uart_agent_config extends uvm_component;
    `uvm_component_utils(uart_agent_config)

    local uart_vif vif;
    local bit has_checks = 1;
    local int unsigned hang_threshold = 200;
    local uvm_active_passive_enum is_active = UVM_ACTIVE;
    local bit has_coverage = 1;

    //------------------------------------------
    // Constructor for the monironment component
    //------------------------------------------
    function new(string name = "", uvm_component parent);
        super.new(name, parent);
        has_checks = 1;
        hang_threshold = 200;
        is_active = UVM_ACTIVE;
        has_coverage = 1;
    endfunction : new

    //-------------------------------------------------------------
    // Build phase for component creation, initialization & Setters
    //-------------------------------------------------------------
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        //Getting Virtual Interface Instance
        if(!uvm_config_db#(virtual uart_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal(get_type_name(), $sformatf("Could not get from the database the UART virtual interface using name"))
        end
        else begin
            set_config();
        end
    endfunction : build_phase

    //Getter for the UART virtual interface
    virtual function uart_vif get_vif();
        return this.vif;
    endfunction
        
    //Setter for the UART virtual interface
    virtual function void set_config();
        if(this.vif != null) begin
            set_is_active(get_is_active());
            set_has_checks(get_has_checks());
            set_hang_threshold(get_hang_threshold());
            set_has_coverage(get_has_coverage());
        end
        else begin
            `uvm_fatal(get_type_name(), "Trying to set the uart virtual interface more than once")
        end
    endfunction : set_config

    // Getter for the agent type flag
    virtual function uvm_active_passive_enum get_is_active();
        return this.is_active;
    endfunction : get_is_active

    // Setter for the agent type flag
    virtual function void set_is_active(uvm_active_passive_enum is_active);
        this.is_active = is_active;
    endfunction : set_is_active

    // Getter for the checks enable flag
    virtual function int get_hang_threshold();
        return this.hang_threshold;
    endfunction : get_hang_threshold

    // Getter for the checks enable flag
    virtual function void set_hang_threshold(int hang_threshold);
        this.hang_threshold = hang_threshold;
        if(vif != null) vif.hang_threshold = hang_threshold;
        else `uvm_fatal(get_type_name(), "Virtual Interface Instance is equal to null!")
    endfunction : set_hang_threshold

    //Getter for the checks enable flag
    virtual function bit get_has_checks();
        return this.has_checks;
    endfunction : get_has_checks

    //Getter for the checks enable flag
    virtual function void set_has_checks(bit has_checks);
        this.has_checks = has_checks;
    endfunction : set_has_checks

    //Getter for the checks enable flag
    virtual function bit get_has_coverage();
        return this.has_coverage;
    endfunction : get_has_coverage

    //Getter for the checks enable flag
    virtual function void set_has_coverage(bit has_coverage);
        this.has_coverage = has_coverage;
    endfunction : set_has_coverage

    //-------------------------------------------------------------------------------------------------------------------------
    // Start of Simulation Phase to check if things that are gonna be used inside the run/main phase are working correctly
    //-------------------------------------------------------------------------------------------------------------------------
    virtual function void start_of_simulation_phase(uvm_phase phase);
        super.start_of_simulation_phase(phase);
        
        if(get_vif() == null) begin
            `uvm_fatal(get_type_name(), "The UART virtual interface is not configured at \"Start of simulation\" phase")
        end
        else begin
            `uvm_info(get_type_name(), "The UART virtual interface is configured at \"Start of simulation\" phase", UVM_DEBUG)
        end
    endfunction

endclass : uart_agent_config

`endif