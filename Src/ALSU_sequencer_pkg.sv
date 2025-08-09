package ALSU_sequencer_pkg;

import ALSU_sequenceitem_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class ALSU_sequencer extends uvm_sequencer #(MySequenceItem);

`uvm_component_utils(ALSU_sequencer);

function new(string name = "ALSU_sequencer",uvm_component parent =null);
    super.new(name, parent);
endfunction

endclass
endpackage
