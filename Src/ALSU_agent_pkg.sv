package ALSU_agent_pkg;
import ALSU_sequenceitem_pkg::*;
import ALSU_sequencer_pkg::*;
import ALSU_driver_pkg::*;
import ALSU_monitor_pkg::*;
import ALSU_config_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class ALSU_agent extends uvm_agent;
`uvm_component_utils(ALSU_agent);

ALSU_config config_agent;
ALSU_sequencer sequencer_agent;
ALSU_driver driver_agent;
ALSU_monitor monitor_agent;

uvm_analysis_port #(MySequenceItem) agent_ap;

function new(string name = "ALSU_agent",uvm_component parent = null);
    super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #(ALSU_config)::get(this,"","CFG",config_agent))
        `uvm_fatal("build_phase","Unable to get configruation object");

    sequencer_agent=ALSU_sequencer::type_id::create("sequencer_agent",this);
    driver_agent=ALSU_driver::type_id::create("driver_agent",this);
    monitor_agent=ALSU_monitor::type_id::create("monitor_agent",this);
    agent_ap= new("agent_ap",this);
endfunction

function void connect_phase(uvm_phase phase);
    driver_agent.ALSU_driver_vif =  config_agent.ALSU_config_vif;
    monitor_agent.ALSU_monitor_vif = config_agent.ALSU_config_vif;
    driver_agent.seq_item_port.connect(sequencer_agent.seq_item_export);
    monitor_agent.monitor_ap.connect(agent_ap);
endfunction
endclass   
endpackage
