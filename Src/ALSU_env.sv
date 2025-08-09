package ALSU_env_pkg;
import ALSU_agent_pkg::*;
import ALSU_coverage_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
class ALSU_env extends uvm_env;
`uvm_component_utils(ALSU_env)

ALSU_agent agent_env;
ALSU_coverage coverage_env;

function new(string name= "ALSU_env",uvm_component parent =null);
    super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agent_env = ALSU_agent::type_id::create("agent_env",this);
    coverage_env = ALSU_coverage::type_id::create("coverage_env",this);
    
endfunction: build_phase

function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    agent_env.agent_ap.connect(coverage_env.cov_export);
endfunction

endclass
endpackage
