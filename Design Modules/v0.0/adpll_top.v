// Top level module of adpll as a chip
// In tiny tapeout we can have 8 input, 8 output, 8 bidirectional, clk and rst pins

`include "adpll_5bit.v"
module adpll_top(
  input wire clk,
  input wire rst,  
  input wire clk_ref,
  input wire clr,
  input wire program,
  input wire out_sel,
  input wire [2:0]param_sel, 
  inout fb_clk,
  inout nco_out,
  inout  [4:0]pgm_value,
  output [4:0] dout,
  output sign);
  
  
 
  reg[4:0]alpha_var_buf;
  reg[4:0]beta_var_buf;
  reg[4:0]nco_offset_buf;
  reg[4:0]nco_thresh_buf;
  reg[4:0]knco_buf;
  reg[3:0]ndiv;
  wire[4:0]filter_out;
  wire[4:0]integ_out;
  wire filter_sign;
  wire integ_sign;
  wire alpha_en, beta_en,nco_offset_en,nco_thresh_en,knco_en,ndiv_ld;
  
  
  
 
   
   //Program mode : Program all PLL the parameters
   // Programming is done in cycle by cycle manner, where we can sequentially program below
   //  *** frequency divider ***
   //  1. frequency division for frequency divider block
   //  *** Loop Filter parameters ***
   //  2. alpha
   //  3. beta
   //  **** NCO parameters ***
   //  4. nco_offst
   //  5. nco_thresold
   //  6. nco_gain
   
   // Select the programming option
   assign ndiv_ld = (program) ? (param_sel==3'd0)?1:0:0;
   assign alpha_en = (program) ? (param_sel==3'd1)?1:0:0;
   assign beta_en = (program) ? (param_sel==3'd2)?1:0:0;
   assign nco_offset_en = (program) ? (param_sel==3'd3)?1:0:0;
   assign nco_thresh_en = (program) ? (param_sel==3'd4)?1:0:0;
   assign knco_en = (program) ? (param_sel==3'd5)?1:0:0;


   // outputs filter data or integrator's data based on out_sel variable 
   assign {sign, dout} = (out_sel) ?{integ_sign,integ_out}:{filter_sign, filter_out};

  adpll_5bit u0( .clk(clk), .reset(rst), .clk_ref(clk_ref),.ndiv(ndiv),.alpha_var(alpha_var_buf),.beta_var(beta_var_buf),.nco_offset(nco_offset_buf), .nco_thresh_val(nco_thresh_buf), .knco(knco_buf), .freq_div(fb_clk), .integ_out(integ_out), .integ_sign(integ_sign), .filter_out(filter_out),.filter_sign(filter_sign), .nco_out(nco_out));
       
       
  // Perform programming    
   always@(posedge ndiv_ld) begin
     if(~clr) 
       ndiv <= pgm_value[3:0];
   end
   
   always@(posedge alpha_en) begin
     if(~clr)
       alpha_var_buf <= pgm_value;
   end
   
   always@(posedge beta_en) begin
    if(~clr)
      beta_var_buf <= pgm_value;
   end
     
   always@(posedge nco_offset_en) begin
     if(~clr)
       nco_offset_buf <= pgm_value;
   end
         
   always@(posedge nco_thresh_en) begin
     if(~clr) 
       nco_thresh_buf <= pgm_value;
   end    
     
   always@(posedge knco_en) begin
     if(~clr)
       knco_buf <= pgm_value;
   end
   
   always@(posedge clr) begin
     alpha_var_buf <= 5'd0;
     beta_var_buf <= 5'd0;
     nco_offset_buf <= 5'd0;
     nco_thresh_buf <= 5'd0;
     knco_buf <= 5'd0;  
     ndiv <= 4'd0;  
   end
   
   
endmodule   
       
   
