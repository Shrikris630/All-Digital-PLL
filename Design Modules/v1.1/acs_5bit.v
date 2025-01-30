
// 5-bit Adder cum subtractor (ACS)
// Inputs are 5-bit data and their signs 
// Output is addition/subtraction result with sign
module acs_5bit(
  input wire sign_in1,      // Sign bit for input 1
  input wire [4:0] in1,     // 5-bit input 1
  input wire sign_in2,      // Sign bit for input 2
  input wire [4:0] in2,     // 5-bit input 2
  output wire [4:0] sum,    // 5-bit output sum/result
  output wire sign_out      // Sign of the output result
);

  wire [4:0] in1_buf, in2_buf; // Buffers for the inputs, possibly in 2's complement form
  wire [4:0] sbuf;             // Sum buffer (output of addition/subtraction)
  wire [4:0] result;           // Result buffer for 6-bit sum (including sign)
  wire [4:0] min1, min2;
  wire comp;

  // Convert inputs to 2's complement if the sign bit is 1 (negative)
  assign min1 = ~in1 + 1;
  assign min2 = ~in2 + 1;
  assign in1_buf = (sign_in1) ?  min1 : in1; // Adding sign bit (1'b1 or 0)
  assign in2_buf = (sign_in2) ?  min2 : in2; // Adding sign bit (1'b1 or 0)
  
  // Addition or subtraction (result depends on the signs)
  // If we want subtraction, we can invert the second input and add 1 (2's complement form of subtraction)
  assign result = in1_buf + in2_buf; // Subtract if sign_in2 is 1
  
  // Extract the 5-bit sum (ignoring the overflow from 6th bit)
  assign sbuf = result; 
  
  // Sign logic
  assign comp = (in1 > in2) ? 1'b1:1'b0;
  assign sign_out = (sign_in1 & sign_in2)|(sign_in2 & (~comp))|(sign_in1 & comp); 

  // Output the sum, in 2's complement if the result is negative (sign_out = 1)
  assign sum = (sign_out) ? ~sbuf + 1 : sbuf;

endmodule
