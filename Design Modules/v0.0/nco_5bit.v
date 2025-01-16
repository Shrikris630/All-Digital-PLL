// NCO module
// Receives the filter output and generates the proportional time-period
module nco_5bit(
  input wire clk,
  input wire reset,
  input wire[4:0] knco,
  input wire ctrl_sign,
  input wire [4:0]ctrl,
  input wire [4:0]nco_offset,
  input wire [4:0]thresh_val,
  output reg nco_clk);
  
  wire [4:0]ctrl_buf;
  wire ctrl_sign_buf;
  reg [4:0]thresh;
  wire [4:0] thresh_buf;
  reg [31:0]counter;
  wire [4:0] phase;
  
  // Buffer the control input
  assign ctrl_buf = (reset) ? 8'd0:ctrl;
  assign ctrl_sign_buf = (reset) ?1'b0:ctrl_sign_buf;
  
  // Calculate Phase
  assign phase = ctrl_buf*knco;
  
  // Modulate the NCO threshold based on phase. This alters the time-period of NCO
  // Offset is added to prevent the threshold moving to negative values, this avoids threhold < 0 during large phase errors, especially during startup
  assign thresh_buf = (reset) ? thresh_val + nco_offset:(ctrl_sign_buf) ? thresh_val + phase + nco_offset:thresh_val - phase + nco_offset;

  
 // If counter > threshold, flip the nco output
 // threshold will detemine the time-period of NCO
  always@(posedge clk or posedge reset) begin
    if(reset) begin
      nco_clk <= 1'b0;
      counter <= 32'd0;
    end
    else begin
      thresh <= thresh_buf;
      if(counter >= thresh-1) begin
        nco_clk <= ~nco_clk;
        counter <= {24'd0,nco_offset};
      end  
      else begin
        counter <= counter + 1;
      end
    end
  end
   
 // When reset is pulled down, threshould and counter values are reset 
  always@(negedge reset) begin
    thresh <= nco_offset;
    counter <= {24'd0,nco_offset};
  end  
 endmodule
