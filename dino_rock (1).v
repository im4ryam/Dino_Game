/*
Name: Maryam Imran and Evan Craft
Project: Dino Game --- dino_rock (collision detector)
*/

module dino_rock (
    input         MAX10_CLK1_50,
    input         ADC_CLK_10,
    input         KEY0,
    inout         Arduino_IO2,
    input         Arduino_IO0,  // fast clock
    output [35:0] GPIO
);

  // ── grab both 35-bit bitmaps ─────────────────────────────────────────────
  wire [34:0] dino_flat, rock_flat;
  dino  d_inst (
    .MAX10_CLK1_50(MAX10_CLK1_50),
    .ADC_CLK_10  (ADC_CLK_10),
    .Arduino_IO0 (Arduino_IO0),
    .Arduino_IO2 (Arduino_IO2),
    .data_flat   (dino_flat)
  );
  rocks r_inst (
    .MAX10_CLK1_50(MAX10_CLK1_50),
    .ADC_CLK_10  (ADC_CLK_10),
    .KEY0        (KEY0),
    .data_flat   (rock_flat)
  );

  // ── scan FSM state, rows & columns ──────────────────────────────────────
  reg  [2:0] fs_state    = 3'd1;
  reg  [6:0] row;
  reg  [4:0] col_d, col_r, col_and, col;

  // collision flag: once high, stays high
  reg collided = 1'b0;

  always @(posedge Arduino_IO0) begin
    if (!collided) begin
      // 1) advance row index
      fs_state <= (fs_state == 3'd7) ? 3'd1 : fs_state + 3'd1;

      // 2) slice this row’s 5 bits from each flat bus
      case (fs_state)
        3'd1: begin row = 7'b0000001; col_d = dino_flat[ 4: 0]; col_r = rock_flat[ 4: 0]; end
        3'd2: begin row = 7'b0000010; col_d = dino_flat[ 9: 5]; col_r = rock_flat[ 9: 5]; end
        3'd3: begin row = 7'b0000100; col_d = dino_flat[14:10]; col_r = rock_flat[14:10]; end
        3'd4: begin row = 7'b0001000; col_d = dino_flat[19:15]; col_r = rock_flat[19:15]; end
        3'd5: begin row = 7'b0010000; col_d = dino_flat[24:20]; col_r = rock_flat[24:20]; end
        3'd6: begin row = 7'b0100000; col_d = dino_flat[29:25]; col_r = rock_flat[29:25]; end
        3'd7: begin row = 7'b1000000; col_d = dino_flat[34:30]; col_r = rock_flat[34:30]; end
      endcase

      // 3) AND for collision test
      col_and   = col_d & col_r;
      collided  <= |col_and;         // latch if any bit overlaps

      // 4) if still no collision, display both
      col        = col_d | col_r;
    end
    else begin
      // on collision: blank out
      row <= 7'b0000000;
      col <= 5'b00000;
      // fs_state & collided hold their values, so we stay blank forever
    end
  end

  // ── drive 36 GPIO pins ──────────────────────────────────────────────────
  assign GPIO[23] = row[0];
  assign GPIO[25] = row[1];
  assign GPIO[27] = row[2];
  assign GPIO[29] = row[3];
  assign GPIO[31] = row[4];
  assign GPIO[33] = row[5];
  assign GPIO[35] = row[6];

  assign GPIO[1]  = col[0];
  assign GPIO[2]  = col[1];
  assign GPIO[5]  = col[2];
  assign GPIO[0]  = col[3];
  assign GPIO[3]  = col[4];

endmodule
