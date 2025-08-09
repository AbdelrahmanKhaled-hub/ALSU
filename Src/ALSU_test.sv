package ALSU_test_pkg;
import ALSU_env_pkg::*;
import ALSU_config_pkg::*;
import ALSU_sequence_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
class ALSU_test extends uvm_test;

    `uvm_component_utils(ALSU_test)

    virtual ALSU_if ALSU_test_vif;
    ALSU_env env;
    ALSU_config ALSU_config_obj_test;
    ALSU_sequence ALSU_test_seq;

    function new(string name = "ALSU_test",uvm_component parent = null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ALSU_config_obj_test = ALSU_config::type_id::create("ALSU_config_obj_test");
        env = ALSU_env::type_id::create("env",this);
        ALSU_test_seq = ALSU_sequence::type_id::create("ALSU_test_seq",this);

        if(!uvm_config_db #(virtual ALSU_if)::get(this,"","ALSU_IF",ALSU_config_obj_test.ALSU_config_vif))
            `uvm_fatal("build_phase","Test - Unable to get the virtual interface of the ALSU from the uvm_config_db");
        uvm_config_db #(ALSU_config)::set(this,"*","CFG",ALSU_config_obj_test);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        phase.raise_objection(this);
        `uvm_info("run_phase","Stimulus Generation Started",UVM_LOW)
        ALSU_test_seq.start(env.agent_env.sequencer_agent);
        `uvm_info("run_phase","Stimulus Generation Ended",UVM_LOW)
        phase.drop_objection(this);
    endtask: run_phase

endclass: ALSU_test
endpackage
