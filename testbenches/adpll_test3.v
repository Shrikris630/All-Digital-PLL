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
  wire dco_out;
  reg [4:0]pgm_value;
  wire [4:0] dout;
  wire sign;
  real delay;
  real ts;
  wire jittered_clk;
  reg  jittered_clk_in;
  wire [4:0]value;
  integer fd1;  
  integer i;
  
  jitter_clock u1(.clk(clk), .jittered_clk(jittered_clk));
  
     adpll_top u0( .clk(jittered_clk_in), .rst(rst), .clk_ref(clk_ref),.clr(clr),.program(program), .out_sel(out_sel),.param_sel(param_sel),.fb_clk(fb_clk),.dco_out(dco_out),.pgm_value(value),.dout(dout),.sign(sign));
     
     
       
     assign value = pgm_value;
     
     always begin
       #(5) clk = (~clk);
        jittered_clk_in = jittered_clk;     
     end
     
     always begin
       #(delay + $random%10) clk_ref = ~clk_ref;
     end
     
     initial begin
       fd1 = $fopen("jitter_output.csv","w");
       $dumpfile("adpll_test3.vcd");
       $dumpvars(0,adpll_test3);
       clk = 1'b0;
       clk_ref =1'b0;
       clr = 1'b0;
       out_sel = 1'b0;
       delay = 250;
       
       #1000;
       clr = 1'b1;
       rst = 1'b1;
       #10;
       clr = 1'b0;
       //Ndiv
       program = 1'b1;
       param_sel = 3'd0;
       pgm_value = 5'd0;
       #10;
       //alpha_var
       param_sel = 3'd1;
       pgm_value = 5'd2;
       #10;
       //beta_var
       param_sel = 3'd2;
       pgm_value = 5'd3;
       #10;
       //dco_offset
       param_sel = 3'd3;
       pgm_value = 5'd8;
       #10;
       //dco_threshold
       param_sel = 3'd4;
       pgm_value = 5'd12;
       #10;
       //kdco (dco gain)
       param_sel = 3'd5;
       pgm_value = 5'd1;     
       rst = 1'b0;  
       #300000;
     
       

       $fclose(fd1);
       $finish;
     end
     
    always@(posedge clk) begin
       $fwrite(fd1,"%t,%b,%b,%b\n",$time,jittered_clk,clk_ref,fb_clk);
     end   
     
 endmodule
 
 
 module jitter_clock(
    input wire clk,  // Original clock input
    output reg jittered_clk  // Output clock with jitter
);

    reg [15:0] jitter_value;  // Jitter amplitude range

    initial begin
       jittered_clk = 0;
    end
       
    always @(posedge clk) begin
        // Introduce random jitter (within a range, for example, +/- 5ns)
        jitter_value = $urandom_range(1,0);  // Random value between 0 and 1 (for jitter in ns)
        
        // Apply jitter by varying the output clock with a random delay
        #(jitter_value) jittered_clk = ~jittered_clk;  // Invert clock after random delay
    end

endmodule

         
