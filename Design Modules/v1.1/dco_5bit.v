// dco module
// Receives the filter output and generates the proportional time-period
module dco_5bit(
  input wire clk,
  input wire reset,
  input wire[4:0] kdco,
  input wire ctrl_sign,
  input wire [4:0]ctrl,
  input wire [4:0]dco_offset,
  input wire [4:0]thresh_val,
  output reg dco_clk);
  
  wire [4:0] ctrl_buf;
  wire ctrl_sign_buf;
  wire [4:0] thresh;
  wire [4:0]thresh_buf;
  wire [5:0] phase;             // Widen phase to 6 bits to avoid overflow
  reg [31:0] counter;           // 32-bit counter for counting cycles

   // Buffer the control input for reset logic
  assign ctrl_buf = (reset) ? 5'd0 : ctrl;
  assign ctrl_sign_buf = (reset) ? 1'b0 : ctrl_sign;

  // Calculate phase (widen to 6 bits to prevent overflow in phase calculation)
  assign phase = ctrl_buf * kdco;  // Multiply control value with DCO constant

  // Modulate the DCO threshold based on phase. Prevent negative threshold values.
  // Use saturation logic to constrain the threshold between valid values (0 to 31 for 5-bit).
  assign thresh_buf = (ctrl_sign_buf) ? (thresh_val + phase)+dco_offset : (thresh_val - phase)+dco_offset;

  // Saturating threshold handling (clamp between 0 and 31)
  assign thresh = (thresh_buf < 5'd0) ? 5'd0 : (thresh_buf > 5'd31) ? 5'd31 : thresh_buf;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      dco_clk <= 1'b0;
      counter <= 32'd0;
    end else begin
      // Update threshold and toggle DCO clock based on the counter
      if (counter >= thresh) begin
        dco_clk <= ~dco_clk;               // Flip the DCO output when threshold is crossed
        counter <= {27'd0, dco_offset};    // Reset counter using DCO offset (to keep within range)
      end else begin
        counter <= counter + 1;            // Increment counter otherwise
      end
    end
  end

endmodule
