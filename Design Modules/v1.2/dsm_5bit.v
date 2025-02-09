
module dsm(
input wire clk,
input wire reset,
input wire [4:0] dsm_thresh,
input wire sign,
output qe);

reg [4:0] frac_reg;

always@(posedge clk or posedge reset) begin
  if(reset) begin
      qe <= 0;
      frac_reg <= 5'd0;
    end
    else begin
      if(frac_reg >= dsm_thresh) begin
        qe <= 1'b1;
        frac_reg <= 5'd0;
      end
      else begin
        frac_reg <= frac_reg + 1;
        qe <=1'b0;
      end
    end
  end
endmodule  

