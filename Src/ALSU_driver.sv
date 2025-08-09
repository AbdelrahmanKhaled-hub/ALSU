package ALSU_driver_pkg;
import ALSU_config_pkg::*;
import ALSU_sequenceitem_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class ALSU_driver extends uvm_driver #(MySequenceItem);

    `uvm_component_utils(ALSU_driver)

    virtual ALSU_if ALSU_driver_vif;
    ALSU_config ALSU_config_obj_driver;
    MySequenceItem item_driver;

    function new(string name ="ALSU_driver", uvm_component parent= null);
        super.new(name,parent);
    endfunction
    
    task run_phase(uvm_phase phase);
        super.run_phase(phase);
    
        forever begin
            item_driver = MySequenceItem::type_id::create("item_driver");
            seq_item_port.get_next_item(item_driver);

            ALSU_driver_vif.rst=item_driver.rst; 
            ALSU_driver_vif.cin=item_driver.cin;
            ALSU_driver_vif.red_op_A=item_driver.red_op_A;
            ALSU_driver_vif.red_op_B=item_driver.red_op_B;
            ALSU_driver_vif.bypass_A=item_driver.bypass_A;
            ALSU_driver_vif.bypass_B=item_driver.bypass_B;
            ALSU_driver_vif.direction=item_driver.direction;
            ALSU_driver_vif.serial_in=item_driver.serial_in;
            ALSU_driver_vif.opcode=item_driver.opcode;
            ALSU_driver_vif.A=item_driver.A;
            ALSU_driver_vif.B=item_driver.B;

            @(negedge ALSU_driver_vif.clk);   
            seq_item_port.item_done();
            `uvm_info("run_phase",item_driver.convert2string_stimulus(),UVM_HIGH); 
    end
    endtask
endclass
endpackage
