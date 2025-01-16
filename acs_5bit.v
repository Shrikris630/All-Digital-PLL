
// 5-bit Adder cum subtractor (ACS)
// Inputs are 5-bit data and their signs 
// Output is addition/subtraction result with sign
module acs_5bit(
  input wire sign_in1,
  input wire [4:0]in1,
  input wire sign_in2,
  input wire [4:0]in2,
  output   [4:0]sum,
  output   sign_out);

   wire[4:0] in1_buf;
   wire[4:0] in2_buf;
   wire[4:0] sbuf;
  
  // Check if No is positive or negative - if negative use 2's complement
  assign in1_buf = (sign_in1) ?  ~in1 + 1:in1 ;
  assign in2_buf = (sign_in2) ?  ~in2 + 1:in2 ;
  // Addition
  assign {sbuf} = in1_buf + in2_buf;
  // Check for the sign of the output
  assign sign_out = (in1 > in2) ? sign_in1:sign_in2;
  assign sum = (sign_out) ? ~sbuf + 1 : sbuf ;
 

endmodule
