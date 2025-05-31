/*
Name: Maryam Imran and Evan Craft
Project: Dino Game --- (jumping) dino module
*/


module dino (
    input       MAX10_CLK1_50,
    input       ADC_CLK_10,
    input       Arduino_IO0,    // fast clock (not used here)
    input       Arduino_IO2,    // jump signal
    output reg [34:0] data_flat // 7 rows × 5 bits = 35 bits
);

  // slow frame clock
  wire slow_clk;
  counter2 CO (MAX10_CLK1_50, slow_clk);

  // active-low jump reset
  wire jump = Arduino_IO2;  

  reg [2:0] frame;

  always @(posedge slow_clk or negedge jump) begin
    if (!jump) begin
      frame <= 3'd1;
    end else begin
      frame <= (frame == 3'd7) ? 3'd7 : frame + 3'd1;
    end
  end

  // On each new frame, load the 7 rows all at once into data_flat.
  // Bit‐packing:  { row7, row6, ..., row1 }, each row is 5 bits wide
  always @(*) begin
    case (frame)
      3'd1: data_flat = { 5'd1, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0 }; // ~(11110) = 1, rest ~(11111)=0
      3'd2: data_flat = { 5'd2, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0 }; // ~(11101) = 2
      3'd3: data_flat = { 5'd4, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0 }; // ~(11011) = 4
      3'd4: data_flat = { 5'd8, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0 }; // ~(11011) = 8
      3'd5: data_flat = { 5'd4, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0 }; // ~(11011) = 4
      3'd6: data_flat = { 5'd2, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0 }; // ~(11101) = 2
      3'd7: data_flat = { 5'd1, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0, 5'd0 }; // ~(11110) = 1
      default: data_flat = 35'd0;
    endcase
  end

endmodule
