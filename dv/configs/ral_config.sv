//==============================================================================
// File Name   : ral_config.sv
// Author      : Abdelrahman Yassien
// Email       : Abdelrahman.Yassien11@gmail.com
// Created On  : 2026-02-13
//
// Description :
//   Configuration Component used to configure the UART Agent
//
// Notes:
//   - Extends uvm_component
//
// Copyright (c) [2026] [Abdelrahman Mohamed Yassien]. All Rights Reserved.
//==============================================================================
`ifndef RAL_CFG
`define RAL_CFG

class ral_config extends uvm_component;
    `uvm_component_utils(ral_config)

    local uart_vif vif;
    local int unsigned reg_model_num;
    local int unsigned regs_num [$];
    local int unsigned reg_fields_num[$];

    //constructor
    //------------------------------------------
    // Construc tor for the monironment component
    //------------------------------------------
    function new(string name = "", uvm_component parent);
        uvm_cmdline_processor clp = uvm_cmdline_processor::get_inst();

        int unsigned reg_model_num_str;
        int unsigned tx_data_width;
        int unsigned stop_bits_width;

        start_bits_width  = START_BITS_WIDTH;
        tx_data_width     = TX_DATA_WIDTH;
        stop_bits_width   = STOP_BITS_WIDTH;


        if(clp.get_arg_value("+REG_M_NUM=", reg_m_num_str)) begin // How many Models
            reg_m_num = reg_m_num_str.atoi();
        end
        for(int i = 0; i < reg_m_num; i++) begin // Parse Through Each Model
            reg_m_num_q = $sformatf("reg_model_%0d", i);
            foreach(reg_m_num_q[i]) begin
                if(clp.get_arg_value($sformatf("+REG_NUM_%0d=", i), reg_num_str)) begin
                    reg_num_q.push_back(reg_num_str.atoi());
                    for( int i = 0; i < reg_num_str.atoi; i++) begin
                        if(clp.get_arg_value($sformatf("+REG_FIELD_NUM_FOR_REG_NUM_%0d=", i), reg_field_num_str)) begin
                            reg_field_num_q.push_back(reg_field_num_str.atoi());
                            for( int i = 0; i < reg_field_num_str.atoi(); i++) begin
                                if(clp.get_arg_value($sformatf("+REG_FIELD_NUM_WIDTH_FOR_REG_NUM_%0d=", i), reg_field_num_width_str)) begin
                                    reg_field_width_num_q.push_back(reg_field_num_width_str.atoi());
                                end
                            end                         
                        end
                    end                    
                end
            end
        end
        if(clp.get_arg_value("+TX_DATA_WIDTH=", tx_data_width_str)) begin
        tx_data_width = tx_data_width_str.atoi();
        end

        if(clp.get_arg_value("+STOP_BITS_WIDTH=", stop_bits_width_str)) begin
        stop_bits_width = stop_bits_width_str.atoi();
        end 

    endfunction


    //------------------------------------------
    // Construc tor for the monironment component
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

endclass : ral_config

`endif