package ALSU_sequenceitem_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"

typedef enum {OR,XOR,ADD,MUL,SHIFT,ROTATE,INVALID_6,INVALID_7} opcode_e;
parameter MAX_POS = 3;
parameter ZERO=0;
parameter MAX_NEG = -4;

class MySequenceItem extends uvm_sequence_item;
`uvm_object_utils(MySequenceItem)

//Signals Declarations
rand bit rst, cin, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in;
rand opcode_e opcode;
rand opcode_e opcode_valid[6];
rand logic signed [2:0] A,B;
logic  [15:0] leds;
logic signed [5:0] out;
int i;

//Constructor for the sequence item
function new(string name = "MySequenceItem");
super.new(name);
endfunction

function string convert2string();
    return $sformatf("rst=0b%0b,serial_in=0b%0b,direction=0b%0b,cin=0b%0b,bypassA=0b%0b,bypassB=0b%0b,\
redopA=0b%0b,redopB=0b%0b,opcode=0b%0b,A=0b%0b,B=0b%0b,out=0b%0b,leds=0b%0b", 
    rst, serial_in, direction, cin, bypass_A, bypass_B,
    red_op_A, red_op_B, opcode, A, B, out, leds);
endfunction

function string convert2string_stimulus();
    return $sformatf("rst=0b%0b,serial_in=0b%0b,direction=0b%0b,cin=0b%0b,bypassA=0b%0b,bypassB=0b%0b,\
redopA=0b%0b,redopB=0b%0b,opcode=0b%0b,A=0b%0b,B=0b%0b", 
    rst, serial_in, direction, cin, bypass_A, bypass_B,
    red_op_A, red_op_B, opcode, A, B);
endfunction

//Constraint blocks
constraint all{
    if(((opcode==OR)||(opcode==XOR))&&red_op_A) {
            A dist{[1:2]:=20,-1:=20,-2:=20,-4:=20,0:=5,3:=5,-1:=5,-3:=5};
            B dist{0:=90,1:=10};
         }   
    else if (((opcode==OR)||(opcode==XOR))&&red_op_B) {
            B dist{[1:2]:=20,-1:=20,-2:=20,-4:=20,0:=5,3:=5,-1:=5,-3:=5};
            A dist{0:=90,1:=10};
    } 
    else if((opcode==ADD)||(opcode==MUL)) {
            A dist {MAX_NEG:=50,ZERO:=50,MAX_POS:=50, [1:2]:=10,[-3:-1]:=10};
            B dist {MAX_NEG:=50,ZERO:=50,MAX_POS:=50, [1:2]:=10,[-3:-1]:=10};
    }
    else if((opcode==SHIFT)||(opcode==ROTATE)){
        red_op_A dist {0:=90,1:=10};
        red_op_B dist {0:=90,1:=10};
    }
    rst dist {0:=95,1:=5};
    bypass_A dist{0:=90,1:=10};
    bypass_B dist{0:=90,1:=10};
}
constraint opcode_c1{opcode dist {OR:=40,XOR:=40,ADD:=40,MUL:=40,SHIFT:=40,ROTATE:=40,INVALID_6:=20,INVALID_7:=20};}

endclass    
endpackage
