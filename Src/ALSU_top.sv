import ALSU_test_pkg::*;
import ALSU_env_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
module ALSU_top();
logic clk;
initial begin
    clk=0;
    forever begin
        #1 clk=~clk;
    end
end
ALSU_if ALSUif(clk);
ALSU ALSU_DUT(ALSUif);
bind ALSU_DUT ALSU_assertions ALSU_assertions_inst(ALSUif);

initial begin
    uvm_config_db#(virtual ALSU_if)::set(null,"uvm_test_top","ALSU_IF",ALSUif);
    run_test("ALSU_test");
end

endmodule
