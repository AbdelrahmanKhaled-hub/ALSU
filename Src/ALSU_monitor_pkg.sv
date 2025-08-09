package ALSU_monitor_pkg;

import ALSU_sequenceitem_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class ALSU_monitor extends uvm_monitor;

    `uvm_component_utils(ALSU_monitor);
    virtual ALSU_if ALSU_monitor_vif;
    MySequenceItem item_monitor;
    uvm_analysis_port #(MySequenceItem) monitor_ap;



    function new(string name = "ALSU_monitor", uvm_component parent = null);
        super.new(name , parent);    
    endfunction //new()

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        monitor_ap = new("monitor_ap",this);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            item_monitor = MySequenceItem::type_id::create("item_monitor");
            @(negedge ALSU_monitor_vif.clk);
            item_monitor.rst=ALSU_monitor_vif.rst; 
            item_monitor.cin=ALSU_monitor_vif.cin;
            item_monitor.red_op_A=ALSU_monitor_vif.red_op_A;
            item_monitor.red_op_B=ALSU_monitor_vif.red_op_B;
            item_monitor.bypass_A=ALSU_monitor_vif.bypass_A;
            item_monitor.bypass_B=ALSU_monitor_vif.bypass_B;
            item_monitor.direction=ALSU_monitor_vif.direction;
            item_monitor.serial_in=ALSU_monitor_vif.serial_in;
            item_monitor.opcode=opcode_e'(ALSU_monitor_vif.opcode);
            item_monitor.A=ALSU_monitor_vif.A;
            item_monitor.B=ALSU_monitor_vif.B;
            item_monitor.out=ALSU_monitor_vif.out;
            item_monitor.leds=ALSU_monitor_vif.leds;

            monitor_ap.write(item_monitor);
            `uvm_info("run_phase",item_monitor.convert2string(),UVM_HIGH)
        end
    endtask
endclass //ALSU_monitor extends superClass   
endpackage
