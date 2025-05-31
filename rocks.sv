/*
Name: Maryam Imran and Evan Craft
Project: Dino Game --- rocks module
*/

module rocks (
    input        MAX10_CLK1_50,
    input        ADC_CLK_10,    // unused, but kept for symmetry
    input        KEY0,          // unused here
    output reg [34:0] data_flat // {row7, row6, …, row1}, each 5 bits
);

  // slow frame clock
  wire slow_clk;
  counter CO (MAX10_CLK1_50, slow_clk);

  wire reset = 1'b0;

  // which of 7 sub-frames we’re in, and which rock type
  reg [2:0] frame      = 3'd1;
  reg [1:0] rock_type  = 2'd0;  // 0 = small, 1 = wide, 2 = tall

  // advance frame & rock_type on slow_clk
  always @(posedge slow_clk or posedge reset) begin
    if (reset) begin
      frame     <= 3'd1;
      rock_type <= 2'd0;
    end else begin
      // next frame (1→2→…→7→1)
      frame <= (frame == 3'd7) ? 3'd1 : frame + 3'd1;
      // after finishing frame 7, rotate rock_type
      if (frame == 3'd7)
        rock_type <= (rock_type == 2) ? 2'd0 : rock_type + 2'd1;
    end
  end

  // combinational: pick the 7 rows based on rock_type & frame
  always @(*) begin
    case (rock_type)

      // ── small rock (1-pixel wide, walks right) ───────────────────────────
      2'd0: case (frame)
        3'd1: data_flat = {
                  ~(5'b11111), ~(5'b11111),
                  ~(5'b11111), ~(5'b11111),
                  ~(5'b11111), ~(5'b11111),
                  ~(5'b11110)
                };
        3'd2: data_flat = {
                  ~(5'b11111), ~(5'b11111),
                  ~(5'b11111), ~(5'b11111),
                  ~(5'b11111), ~(5'b11110),
                  ~(5'b11111)
                };
        3'd3: data_flat = {
                  ~(5'b11111), ~(5'b11111),
                  ~(5'b11111), ~(5'b11111),
                  ~(5'b11110), ~(5'b11111),
                  ~(5'b11111)
                };
        3'd4: data_flat = {
                  ~(5'b11111), ~(5'b11111),
                  ~(5'b11111), ~(5'b11110),
                  ~(5'b11111), ~(5'b11111),
                  ~(5'b11111)
                };
        3'd5: data_flat = {
                  ~(5'b11111), ~(5'b11111),
                  ~(5'b11110), ~(5'b11111),
                  ~(5'b11111), ~(5'b11111),
                  ~(5'b11111)
                };
        3'd6: data_flat = {
                  ~(5'b11111), ~(5'b11110),
                  ~(5'b11111), ~(5'b11111),
                  ~(5'b11111), ~(5'b11111),
                  ~(5'b11111)
                };
        3'd7: data_flat = {
                  ~(5'b11110), ~(5'b11111),
                  ~(5'b11111), ~(5'b11111),
                  ~(5'b11111), ~(5'b11111),
                  ~(5'b11111)
                };
      endcase

      // ── wide rock (2-pixel wide) ────────────────────────────────────────
      2'd1: case (frame)
        3'd1: data_flat = {
                  ~(5'b11111), ~(5'b11111),
                  ~(5'b11111), ~(5'b11111),
                  ~(5'b11111), ~(5'b11110),
                  ~(5'b11110)
                };
        3'd2: data_flat = {
                  ~(5'b11111), ~(5'b11111),
                  ~(5'b11111), ~(5'b11111),
                  ~(5'b11110), ~(5'b11110),
                  ~(5'b11111)
                };
        3'd3: data_flat = {
                  ~(5'b11111), ~(5'b11111),
                  ~(5'b11111), ~(5'b11110),
                  ~(5'b11110), ~(5'b11111),
                  ~(5'b11111)
                };
        3'd4: data_flat = {
                  ~(5'b11111), ~(5'b11111),
                  ~(5'b11110), ~(5'b11110),
                  ~(5'b11111), ~(5'b11111),
                  ~(5'b11111)
                };
        3'd5: data_flat = {
                  ~(5'b11111), ~(5'b11110),
                  ~(5'b11110), ~(5'b11111),
                  ~(5'b11111), ~(5'b11111),
                  ~(5'b11111)
                };
        3'd6: data_flat = {
                  ~(5'b11110), ~(5'b11110),
                  ~(5'b11111), ~(5'b11111),
                  ~(5'b11111), ~(5'b11111),
                  ~(5'b11111)
                };
        3'd7: data_flat = {
                  ~(5'b11111), ~(5'b11111),
                  ~(5'b11111), ~(5'b11111),
                  ~(5'b11111), ~(5'b11111),
                  ~(5'b11110)
                };
      endcase

      // ── tall rock (1-column high, moves right) ───────────────────────────
      2'd2: case (frame)
        3'd1: data_flat = {
                  ~(5'b11111), ~(5'b11111),
                  ~(5'b11111), ~(5'b11111),
                  ~(5'b11111), ~(5'b11111),
                  ~(5'b11100)
                };
        3'd2: data_flat = {
                  ~(5'b11111), ~(5'b11111),
                  ~(5'b11111), ~(5'b11111),
                  ~(5'b11111), ~(5'b11100),
                  ~(5'b11111)
                };
        3'd3: data_flat = {
                  ~(5'b11111), ~(5'b11111),
                  ~(5'b11111), ~(5'b11111),
                  ~(5'b11100), ~(5'b11111),
                  ~(5'b11111)
                };
        3'd4: data_flat = {
                  ~(5'b11111), ~(5'b11111),
                  ~(5'b11111), ~(5'b11100),
                  ~(5'b11111), ~(5'b11111),
                  ~(5'b11111)
                };
        3'd5: data_flat = {
                  ~(5'b11111), ~(5'b11111),
                  ~(5'b11100), ~(5'b11111),
                  ~(5'b11111), ~(5'b11111),
                  ~(5'b11111)
                };
        3'd6: data_flat = {
                  ~(5'b11111), ~(5'b11100),
                  ~(5'b11111), ~(5'b11111),
                  ~(5'b11111), ~(5'b11111),
                  ~(5'b11111)
                };
        3'd7: data_flat = {
                  ~(5'b11100), ~(5'b11111),
                  ~(5'b11111), ~(5'b11111),
                  ~(5'b11111), ~(5'b11111),
                  ~(5'b11111)
                };
      endcase

    endcase
  end

endmodule