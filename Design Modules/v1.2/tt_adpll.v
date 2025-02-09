/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */
`include "adpll_top.v"
`default_nettype none

module tt_adpll (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  // All output pins must be assigned. If not used, assign to 0.
  wire samp_clk;
  wire rst; 
  wire clk90;
  wire clk_ref;
  wire clr;
  wire program;
  wire out_sel;
  wire [2:0]param_sel; 
  wire fb_clk;
  wire dco_out;
  wire  [4:0]pgm_value;
  wire [4:0] dout;
  wire sign;
  
  assign samp_clk = clk;                  // 50MHz clock
  assign rst = rst_n;                    // Reset
  assign clk90 = ui_in[0];               // 50MHz with 90 degree phase-shift
  assign clk_ref = ui_in[1];             // Input reference clock
  assign clr = ui_in[2];                 // Clear command : set 1 to clear all the programmed values else keep 0
  assign program = ui_in[3];             // Program : set 1 to program values else keep 0
  assign out_sel= ui_in[4] ;             // Output selector: set 0 to get filter output and 1 to get integral path output
  assign param_sel = ui_in[7:5];         // Parameter selector : Select the parameter to be programmed
  assign pgm_value = uio_in[6:2];         // Program value
  assign uio_out[0] = fb_clk;            // Feedback clock output
  assign uio_out[1] = dco_out;           // DCO output
  
  // adpll top-level block
  adpll_top u0( .clk(samp_clk), .rst(rst),.clk90(clk90),.clk_ref(clk_ref),.clr(clr),.program(program), .out_sel(out_sel),.param_sel(param_sel),.fb_clk(fb_clk),.dco_out(dco_out),.pgm_value(pgm_value),.dout(dout),.sign(sign));
  
 

  // List all unused inputs to prevent warnings

endmodule
