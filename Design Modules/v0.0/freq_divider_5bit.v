// Programmable frequency divider
module freq_divider_5bit(
  input wire clk,
  input wire reset,
  input wire [3:0]ndiv,
  output reg freq_div_out);
  
  wire [3:0] thresh;
  reg [31:0] counter;
  
 
 // Threshold is programmable and decides the time-period of output
  assign thresh = ndiv;
  always@(posedge clk or posedge reset ) begin
    if(reset) begin
      counter <= 32'd0;
      freq_div_out <= 0;
    end
    else begin
      if(counter >= thresh-1) begin
        freq_div_out <= ~freq_div_out;
        counter <= 32'd0;
      end
      else begin
        counter <= counter + 1;
      end
    end
  end   
endmodule  
