module ALSU(ALSU_if.DUT ALSUif);
parameter INPUT_PRIORITY = "A";
parameter FULL_ADDER = "ON";

logic clk,rst, cin, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in;
logic [2:0] opcode;
logic signed [2:0] A, B;
logic  [15:0] leds;
logic signed [5:0] out;

assign A=ALSUif.A ;
assign B=ALSUif.B ;
assign cin=ALSUif.cin ;
assign serial_in=ALSUif.serial_in ;
assign red_op_A=ALSUif.red_op_A;
assign red_op_B=ALSUif.red_op_B ;
assign opcode=ALSUif.opcode ;
assign bypass_A=ALSUif.bypass_A;
assign bypass_B=ALSUif.bypass_B ;
assign clk=ALSUif.clk;
assign rst=ALSUif.rst;
assign direction=ALSUif.direction;
assign ALSUif.out=out;
assign ALSUif.leds=leds;

logic  cin_reg,red_op_A_reg, red_op_B_reg, bypass_A_reg, bypass_B_reg, direction_reg, serial_in_reg;
logic [2:0] opcode_reg;
logic signed [2:0] A_reg, B_reg;
logic invalid_red_op, invalid_opcode, invalid;

//Invalid handling 
//Make leds adjustment to not blink if bypass (A or B) is high ignoring red_op and opcode 
assign invalid_red_op = (red_op_A_reg | red_op_B_reg) & (opcode_reg[1] | opcode_reg[2]);
assign invalid_opcode = opcode_reg[1] & opcode_reg[2];
assign invalid = ((bypass_A_reg||bypass_B_reg))?0:(invalid_red_op | invalid_opcode); 

//Registering input signals
always @(posedge clk or posedge rst) begin
  if(rst) begin
     cin_reg <= 0;
     red_op_B_reg <= 0;
     red_op_A_reg <= 0;
     bypass_B_reg <= 0;
     bypass_A_reg <= 0;
     direction_reg <= 0;
     serial_in_reg <= 0;
     opcode_reg <= 0;
     A_reg <= 0;
     B_reg <= 0;
  end else begin
     cin_reg <= cin;
     red_op_B_reg <= red_op_B;
     red_op_A_reg <= red_op_A;
     bypass_B_reg <= bypass_B;
     bypass_A_reg <= bypass_A;
     direction_reg <= direction;
     serial_in_reg <= serial_in;
     opcode_reg <= opcode;
     A_reg <= A;
     B_reg <= B;
  end
end

//leds output blinking 
always @(posedge clk or posedge rst) begin
  if(rst) begin
     leds <= 0;
  end else begin
      if (invalid)
        leds <= ~leds;
      else
        leds <= 0;
  end
end

//ALSU output processing
always @(posedge clk or posedge rst) begin
  if(rst) begin
    out <= 0;
  end
  else begin  //Make bypass priorities comes before the invalid operations
    if (bypass_A_reg && bypass_B_reg)
      out <= (INPUT_PRIORITY == "A")? A_reg: B_reg;
    else if (bypass_A_reg)
      out <= A_reg;
    else if (bypass_B_reg)
      out <= B_reg;
    else if (invalid) 
        out <= 0;
    else begin
        case (opcode_reg) //Adding The opcode_reg instead of opcode
          3'h0: begin  //BUG in design performing AND instead of OR
            if (red_op_A_reg && red_op_B_reg)
              out = (INPUT_PRIORITY == "A")? |A_reg: |B_reg;
            else if (red_op_A_reg) 
              out <= |A_reg;
            else if (red_op_B_reg)
              out <= |B_reg;
            else 
              out <= A_reg | B_reg;
          end
          3'h1: begin //BUG in design performing OR instead of XOR
            if (red_op_A_reg && red_op_B_reg)
              out <= (INPUT_PRIORITY == "A")? ^A_reg: ^B_reg;
            else if (red_op_A_reg) 
              out <= ^A_reg;
            else if (red_op_B_reg)
              out <= ^B_reg;
            else 
              out <= A_reg ^ B_reg;
          end
          3'h2:begin  //Adding FULL_ADDER condition for carry in
            if(FULL_ADDER) out <= A_reg + B_reg +cin_reg;
            else  out <= A_reg + B_reg;
          end
          3'h3: out <= A_reg * B_reg;
          3'h4: begin
            if (direction_reg)
              out <= {out[4:0], serial_in_reg};
            else
              out <= {serial_in_reg, out[5:1]};
          end
          3'h5: begin
            if (direction_reg)
              out <= {out[4:0], out[5]};
            else
              out <= {out[0], out[5:1]};
          end
        endcase
    end 
  end
end

endmodule
