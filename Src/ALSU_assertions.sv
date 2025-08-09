module ALSU_assertions(ALSU_if.DUT ALSUif);

logic invalid_red_op, invalid_opcode, invalid;
assign invalid_red_op = (ALSUif.red_op_A | ALSUif.red_op_B) & (ALSUif.opcode[1] | ALSUif.opcode[2]);
assign invalid_opcode = ALSUif.opcode[1] & ALSUif.opcode[2];


property rst_p;
    @(posedge ALSUif.clk)
    ALSUif.rst |-> ALSUif.out==0 && ALSUif.leds==0;
endproperty

property bypass_A_p;
    @(posedge ALSUif.clk)
    disable iff (ALSUif.rst)
    (ALSUif.bypass_A) |-> ##2 ALSUif.out==$past(ALSUif.A,2);
endproperty

property bypass_B_p;
    @(posedge ALSUif.clk)
    disable iff (ALSUif.rst || ALSUif.bypass_A)
    ALSUif.bypass_B |-> ##2 ALSUif.out==$past(ALSUif.B,2);
endproperty

property invalid_p;
    @(posedge ALSUif.clk)
    disable iff (ALSUif.rst || ALSUif.bypass_A || ALSUif.bypass_B)
    (invalid_opcode || invalid_red_op) |-> ##2 (ALSUif.out==0&& ALSUif.leds==~$past(ALSUif.leds,1));
endproperty

property red_or_A_p;
    @(posedge ALSUif.clk)
    disable iff (ALSUif.rst || ALSUif.bypass_A || ALSUif.bypass_B || invalid_opcode || invalid_red_op)
    (ALSUif.opcode==0 && ALSUif.red_op_A) |-> ##2 (ALSUif.out==|$past(ALSUif.A,2));    
endproperty

property red_or_B_p;
    @(posedge ALSUif.clk)
    disable iff (ALSUif.rst || ALSUif.bypass_A || ALSUif.bypass_B || invalid_opcode || invalid_red_op) 
    (ALSUif.opcode==0 && !ALSUif.red_op_A && ALSUif.red_op_B) |-> ##2 (ALSUif.out==$past(|ALSUif.B,2));    
endproperty

property or_p;
    @(posedge ALSUif.clk)
    disable iff (ALSUif.rst || ALSUif.bypass_A || ALSUif.bypass_B || invalid_opcode || invalid_red_op) 
    (ALSUif.opcode==0 && !ALSUif.red_op_A && !ALSUif.red_op_B) |-> ##2 (ALSUif.out==$past(ALSUif.A,2)|$past(ALSUif.B,2));    
endproperty

property red_xor_A_p;
    @(posedge ALSUif.clk)
    disable iff (ALSUif.rst || ALSUif.bypass_A || ALSUif.bypass_B || invalid_opcode || invalid_red_op) 
    (ALSUif.opcode==1 && ALSUif.red_op_A) |-> ##2 (ALSUif.out==$past(^ALSUif.A,2));    
endproperty

property red_xor_B_p;
    @(posedge ALSUif.clk)
    disable iff (ALSUif.rst || ALSUif.bypass_A || ALSUif.bypass_B || invalid_opcode || invalid_red_op) 
    (ALSUif.opcode==1 && !ALSUif.red_op_A && ALSUif.red_op_B) |-> ##2 (ALSUif.out==$past(^ALSUif.B,2));    
endproperty

property xor_p;
    @(posedge ALSUif.clk)
    disable iff (ALSUif.rst || ALSUif.bypass_A || ALSUif.bypass_B || invalid_opcode || invalid_red_op) 
    (ALSUif.opcode==1 && !ALSUif.red_op_A && !ALSUif.red_op_B) |-> ##2 (ALSUif.out==$past(ALSUif.A,2)^$past(ALSUif.B,2));    
endproperty

property Add_p;
    @(posedge ALSUif.clk)
    disable iff (ALSUif.rst || ALSUif.bypass_A || ALSUif.bypass_B || invalid_opcode || invalid_red_op) 
    (ALSUif.opcode==2) |-> ##2 (ALSUif.out==$past(ALSUif.A,2)+$past(ALSUif.B,2)+$past(ALSUif.cin,2));
endproperty

property mul_p;
    @(posedge ALSUif.clk)
    disable iff (ALSUif.rst || ALSUif.bypass_A || ALSUif.bypass_B || invalid_opcode || invalid_red_op) 
    (ALSUif.opcode==3) |-> ##2 (ALSUif.out==$past(ALSUif.A,2)*$past(ALSUif.B,2));
endproperty

property shift_left_p;
    @(posedge ALSUif.clk)
    disable iff (ALSUif.rst || ALSUif.bypass_A || ALSUif.bypass_B || invalid_opcode || invalid_red_op) 
    (ALSUif.opcode==4 && ALSUif.direction) |-> ##2 (ALSUif.out=={$past(ALSUif.out[4:0],1),$past(ALSUif.serial_in,2)}); 
endproperty

property shift_right_p;
    @(posedge ALSUif.clk)
    disable iff (ALSUif.rst || ALSUif.bypass_A || ALSUif.bypass_B || invalid_opcode || invalid_red_op) 
    (ALSUif.opcode==4 && !ALSUif.direction) |-> ##2 (ALSUif.out=={$past(ALSUif.serial_in,2), $past(ALSUif.out[5:1],1)}); 
endproperty

property rotate_left_p;
    @(posedge ALSUif.clk)
    disable iff (ALSUif.rst || ALSUif.bypass_A || ALSUif.bypass_B || invalid_opcode || invalid_red_op) 
    (ALSUif.opcode==5 && ALSUif.direction) |-> ##2 (ALSUif.out=={$past(ALSUif.out[4:0],1), $past(ALSUif.out[5],1)}); 
endproperty

property rotate_right_p;
    @(posedge ALSUif.clk)
    disable iff (ALSUif.rst || ALSUif.bypass_A || ALSUif.bypass_B || invalid_opcode || invalid_red_op) 
    (ALSUif.opcode==5 && !ALSUif.direction) |-> ##2 (ALSUif.out=={$past(ALSUif.out[0],1), $past(ALSUif.out[5:1],1)});
endproperty


rst_p_assertion: assert property(rst_p);
bypass_A_p_assertion: assert property(bypass_A_p);
bypass_B_p_assertion: assert property(bypass_B_p);
red_or_A_p_assertion: assert property(red_or_A_p);
red_or_B_p_assertion: assert property(red_or_B_p);
or_p_assertion: assert property(or_p);
red_xor_A_p_assertion: assert property(red_xor_A_p);
red_xor_B_p_assertion: assert property(red_xor_B_p);
xor_p_assertion: assert property(xor_p);
Add_p_assertion: assert property(Add_p);
mul_p_assertion: assert property(mul_p);
shift_left_p_assertion: assert property(shift_left_p);
shift_right_p_assertion: assert property(shift_right_p);
rotate_left_p_assertion: assert property(rotate_left_p);
rotate_right_p_assertion: assert property(rotate_right_p);

rst_p_coverage: cover property(rst_p);
bypass_A_p_coverage: cover property(bypass_A_p);
bypass_B_p_coverage: cover property(bypass_B_p);
red_or_A_p_coverage: cover property(red_or_A_p);
red_or_B_p_coverage: cover property(red_or_B_p);
or_p_coverage: cover property(or_p);
red_xor_A_p_coverage: cover property(red_xor_A_p);
red_xor_B_p_coverage: cover property(red_xor_B_p);
xor_p_coverage: cover property(xor_p);
Add_p_coverage: cover property(Add_p);
mul_p_coverage: cover property(mul_p);
shift_left_p_coverage: cover property(shift_left_p);
shift_right_p_coverage: cover property(shift_right_p);
rotate_left_p_coverage: cover property(rotate_left_p);
rotate_right_p_coverage: cover property(rotate_right_p);

endmodule
