package ALSU_sequence_pkg;
import ALSU_sequenceitem_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class ALSU_sequence extends uvm_sequence #(MySequenceItem);

`uvm_object_utils(ALSU_sequence);
MySequenceItem item;

//Constructor for the sequence
function new(string name = "MySequence");
    super.new(name);    
endfunction

//Main task for the sequence
virtual task body();

    //Reset initialization
    item = MySequenceItem::type_id::create("item"); //Create a sequence item
    start_item(item);
    item.rst=1; item.cin=0; item.red_op_A=0; item.red_op_B=0; item.bypass_A=0; item.bypass_B=0;
    item.direction=0; item.serial_in=0; item.A=0; item.B=0;
    item.opcode = opcode_e'(0);
    finish_item(item);
    

    repeat(10000) begin
        item = MySequenceItem::type_id::create("item"); //Create a sequence item
        start_item(item);
        assert (item.randomize());
        finish_item(item);
    end
endtask
endclass    
endpackage
