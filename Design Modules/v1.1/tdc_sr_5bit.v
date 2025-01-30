//Thermometer coded TDC-based Phase Detector (PD)
// Sequential PD generates up and down signal which is converted to its binary equivalent by TDC
module tdc_sr_5bit(
input clk,
input wire reset,
input wire clk_ref,
input wire fb_clk,
output reg[31:0] up_error,
output reg[31:0] dwn_error);

reg start;
reg up,dwn;
wire reset_trig;

//*** Sequential PD  ***
assign reset_trig = reset | up & dwn;
//  Up detection
always@(posedge clk_ref or posedge reset_trig) begin  
  if(reset_trig) begin
    up <= 0; 
  end
  else begin
    up <=1'b1 & start;
  end
end
//  Down detection
always@(posedge fb_clk or posedge reset_trig) begin  
  if(reset_trig) begin
    dwn <= 0; 
  end
  else begin
    dwn <=1'b1 & start;
  end
end

//***  TDC ****
// Receives UP and DWN and convets to UP_ERROR and DWN_ERROR (Thermometer equivalent of UP and DWN signals)
always@(posedge clk or posedge reset_trig) begin
  if(reset_trig) begin
    up_error <= 32'd0;
    dwn_error <= 32'd0;
  end
  else begin
    up_error[0] <= up;
    up_error[31:1] <= up_error[30:0];
    dwn_error[0] <= dwn;
    dwn_error[31:1] <= dwn_error[30:0];
  end      
end    


always@(posedge clk_ref or posedge reset) begin
 if(reset)
  start <= 1'b0;
 else 
  start <= 1'b1;
end

endmodule
