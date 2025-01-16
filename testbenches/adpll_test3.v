`timescale 1ns/1ps
`include "adpll_top.v"

module adpll_test3;
  reg clk ;
  reg rst ;
  reg clk_ref;
  reg clr;
  reg program;
  reg out_sel;
  reg [2:0]param_sel; 
  wire fb_clk;
  wire nco_out;
  reg [4:0]pgm_value;
  wire [4:0] dout;
  wire sign;
  real delay;
  wire [4:0]value;
  
  
      adpll_top u0( .clk(clk), .rst(rst), .clk_ref(clk_ref),.clr(clr),.program(program), .out_sel(out_sel),.param_sel(param_sel),.fb_clk(fb_clk),.nco_out(nco_out),.pgm_value(value),.dout(dout),.sign(sign));
     
     assign value = pgm_value;
     
     
     always begin
       #10 clk = ~clk;
     end
     
     always begin
       #(delay) clk_ref = ~clk_ref;
     end
     
     initial begin
       $dumpfile("adpll_test3.vcd");
       $dumpvars(0,adpll_test3);
       clk = 1'b0;
       clk_ref =1'b0;
       clr = 1'b0;
       out_sel = 1'b0;
       delay = 250;
  
       #0;
       clr = 1'b1;
       rst = 1'b1;
       #1;
       clr = 1'b0;
       //Ndiv
       program = 1'b1;
       param_sel = 3'd0;
       pgm_value = 5'd1;
       #1;
       //alpha_var
       param_sel = 3'd1;
       pgm_value = 5'd4;
       #1;
       //beta_var
       param_sel = 3'd2;
       pgm_value = 5'd4;
       #1;
       //nco_offset
       param_sel = 3'd3;
       pgm_value = 5'd8;
       #1;
       //nco_threshold
       param_sel = 3'd4;
       pgm_value = 5'd10;
       #1;
       //knco (nco gain)
       param_sel = 3'd5;
       pgm_value = 5'd1;     
       rst = 1'b0;
     
       
       #100000;
       param_sel = 3'd1;
       pgm_value = 5'd3; 
       #100000;
       param_sel = 3'd3;
       pgm_value = 5'd10; 
       #100000;
       $finish;
     end
     
     
 endmodule         
