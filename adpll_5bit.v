// 5-bit ADPLL verilog-code
`include "tdc_sr_5bit.v"
`include "ones_counter_5bit.v"
`include "pi_filter_5bit.v"
`include "nco_5bit.v"
`include "freq_divider_5bit.v"

module adpll_5bit(
  input wire clk,
  input wire reset,
  input wire clk_ref,
  input wire [3:0]ndiv,
  input wire[4:0]alpha_var,
  input wire[4:0]beta_var,
  input wire[4:0]nco_offset,
  input wire[4:0]nco_thresh_val,
  input wire[4:0]knco,
  inout freq_div,
  output [4:0] integ_out,
  output integ_sign,
  inout  [4:0] filter_out,
  inout  filter_sign,
  inout nco_out);
  
  wire[31:0] up_error, dwn_error;
  wire[4:0] bin_up_error, bin_dwn_error, bin_error;
  wire error_sign;
  wire[4:0] prop_out;
  wire[4:0] cntrl;
  wire freq_div_buf;
  
  //1. Phase Detection
  tdc_sr_5bit i0_tdc( .clk(clk), .reset(reset), .clk_ref(clk_ref), .freq_div(freq_div), .up_error(up_error), .dwn_error(dwn_error));
  ones_counter_5bit i1_oc(.data_in(up_error), .data_out(bin_up_error));
  ones_counter_5bit i2_oc(.data_in(dwn_error), .data_out(bin_dwn_error));
  
  //2. Convert the thermometer code to binary
  assign bin_error = bin_up_error - bin_dwn_error ;
  assign error_sign = (bin_dwn_error > bin_up_error) ? 1:0;

  
  //3. Loop filter
  pi_filter_5bit i3_pi_filter( .clk(clk_ref), .reset(reset), .error_sign(error_sign), .error(bin_error), .alpha_var(alpha_var), .beta_var(beta_var), .integ_out(integ_out), .integ_sign(integ_sign), .filter_out(filter_out), .filter_sign(filter_sign));
  
  assign cntrl = filter_out;
  
  //4. nco
  nco_5bit i4_nco(.clk(clk), .reset(reset), .knco(knco), .ctrl_sign(filter_sign), .ctrl(cntrl),.nco_offset(nco_offset), .thresh_val(nco_thresh_val),.nco_clk(nco_out));
  
  //5. Frequency divider
  freq_divider_5bit i5_freq_div(.clk(nco_out), .reset(reset), .ndiv(ndiv), .freq_div_out(freq_div_buf));
  
  //6. Mux out the frequecy divider or nco output directly
  assign freq_div = (ndiv==4'd0)?nco_out:freq_div_buf;
  
endmodule
