package ALSU_coverage_pkg;
import ALSU_sequenceitem_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class ALSU_coverage extends uvm_component;
`uvm_component_utils(ALSU_coverage);

uvm_analysis_export #(MySequenceItem) cov_export;
uvm_tlm_analysis_fifo #(MySequenceItem) cov_fifo;
MySequenceItem item_cov;

//Covergroups
covergroup cov_gp();
A_cp: coverpoint item_cov.A
{
        bins A_data_0 = {ZERO};
        bins A_data_max={MAX_POS};
        bins A_data_min={MAX_NEG};
        bins A_data_default=default;
        bins A_data_walkingones[] ={1,2,-4} iff(item_cov.red_op_A) ;
}
B_cp: coverpoint item_cov.B
{
        bins B_data_0 = {ZERO};
        bins B_data_max={MAX_POS};
        bins B_data_min={MAX_NEG};
        bins B_data_default=default;
        bins B_data_walkingones[]={1,2,-4} iff((!item_cov.red_op_A) && (item_cov.red_op_B) );
}
ALU_cp: coverpoint item_cov.opcode
{
        bins Bins_shift[] = {SHIFT,ROTATE};
        bins Bins_arith[] = {ADD,MUL};
        bins Bins_bitwise[] = {OR,XOR};
        bins Bins_invalid = {INVALID_6,INVALID_7};
        bins Bins_trans = (0=>1),(1=>2),(3=>4),(4=>5);
}

//Cover points needed for the cross coverage
A_extremes: coverpoint item_cov.A
{
        bins A_extremes_VALUES={MAX_NEG,ZERO,MAX_POS};
        option.weight=0;
}
B_extremes: coverpoint item_cov.B
{
        bins B_extremes_VALUES={MAX_NEG,ZERO,MAX_POS};
        option.weight=0;
}
cross_cin:coverpoint item_cov.cin {
        bins C_in={0,1};
        option.weight=0;
        }
cross_serial_in:coverpoint item_cov.serial_in {
        bins serialin={0,1};
        option.weight=0;
        }
cross_redA:coverpoint item_cov.red_op_A{
        bins redA={0,1};
        option.weight=0;
        }
cross_redB:coverpoint item_cov.red_op_B{
        bins redB={0,1};
        option.weight=0;
        }
cross_direction:coverpoint item_cov.direction{
        bins crossdir ={0,1};
        option.weight=0;
        }

//Cross coverage
A_B_ADD_MUL: cross A_extremes, B_extremes ,ALU_cp
{
        bins Extreme_Add_mul = binsof (A_extremes) && binsof (B_extremes) && binsof (ALU_cp.Bins_arith);
}

CIN_ADD_cross: cross cross_cin, ALU_cp{

        bins CIN_ADD = binsof(ALU_cp) intersect {ADD} && binsof(cross_cin);
        option.cross_auto_bin_max = 0;
}
shifting_cross: cross ALU_cp,cross_serial_in
{
        bins serial_in_shift = binsof(ALU_cp) intersect {SHIFT} && binsof(cross_serial_in);
        option.cross_auto_bin_max = 0;
}
shifting_rotating_cross: cross ALU_cp,cross_direction
{
        bins serial_in_shift = binsof(ALU_cp.Bins_shift)  && binsof(cross_direction);
        option.cross_auto_bin_max = 0;
}
OR_XOR_redA_cross: cross ALU_cp, cross_redA, A_cp,B_cp
{
        bins OR_XOR_redA = binsof(ALU_cp.Bins_bitwise) && binsof(cross_redA) intersect{1} && binsof(A_cp.A_data_walkingones) && binsof(B_cp) intersect {ZERO};
        option.cross_auto_bin_max = 0;
}
OR_XOR_redB_cross: cross ALU_cp, cross_redB, A_cp,B_cp
{
        bins OR_XOR_redB = binsof(ALU_cp.Bins_bitwise) && binsof(cross_redB) intersect {1} && binsof(B_cp.B_data_walkingones)  && binsof(A_cp) intersect {ZERO};
        option.cross_auto_bin_max = 0;
}
INVALID_red_cross: cross ALU_cp,cross_redA, cross_redB
{
        bins invalid_red = !binsof(ALU_cp.Bins_bitwise)  && (binsof(cross_redB) intersect {1} || binsof(cross_redA) intersect{1});
        option.cross_auto_bin_max = 0;
}
endgroup

//Defining the new function and the covergroup inside it
function new(string name = "ALSU_coverage", uvm_component parent = null);
    super.new(name,parent);
    cov_gp=new();        
endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    cov_export = new("cov_export",this);
    cov_fifo = new("cov_fifo", this);
endfunction

function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    cov_export.connect(cov_fifo.analysis_export);
endfunction

task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
        cov_fifo.get(item_cov);
        if(item_cov.rst||item_cov.bypass_A||item_cov.bypass_B)
            cov_gp.stop();
        else begin
            cov_gp.start();
            cov_gp.sample();
        end     
    end
endtask
endclass
endpackage
