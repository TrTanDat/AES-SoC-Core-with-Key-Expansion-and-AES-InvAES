module aes(
  input  logic         i_clk,
  input  logic         i_rst,
  
  input  logic [  2:0] i_start, // bit0 - keygen, bit1 - encr, bit2 - decr 
  output logic         o_busy,
  
  output logic [127:0] o_result,
  output logic         o_done
);

//tb
  logic [127:0] i_key;
  logic [127:0] i_plain;
  logic [127:0] i_cipher;
  
  assign i_key    = 128'h2b7e151628aed2a6abf7158809cf4f3c;
  assign i_plain  = 128'h3243f6a8885a308d313198a2e0370734;
  assign i_cipher = 128'h3925841d02dc09fbdc118597196a0b32;
  
//FSM State  
  localparam IDLE = 3'd0;
  localparam KEYG = 3'd1;
  localparam ENCR = 3'd2;
  localparam DECR = 3'd3;
  
  logic [2:0] fsm_state;

// handshake signals
  logic ke_start,  ke_done,  ke_busy;
  logic enc_start, enc_done, enc_busy;
  logic dec_start, dec_done, dec_busy;
  logic decenc;
  logic [2:0] start;

// Wires
  logic [127:0] enc_out, dec_out;
  logic [127:0] roundkey;
  logic [  3:0] round_cnt;
  logic [127:0] o_cipher;
  logic [127:0] o_plain;

//=== Key Expansion Core ===
KeyExpansion u0(
  .i_clk     (i_clk),
  .i_rst     (i_rst),
  .i_init    (start[0]),
  .o_done    (ke_done),
  .o_busy    (ke_busy),
  .i_key     (i_key),
  .i_round   (round_cnt),
  .i_decrypt (decenc),        // chỉ cần encrypt mode, decrypt dùng key đảo
  .o_roundkey(roundkey)
  );

//=== Encryption Core ===
Encipher u1(
  .i_clk(i_clk),
  .i_rst(i_rst),
  .i_init(start[1]),
  .o_done(enc_done),
  .o_busy(enc_busy),
  .i_key(roundkey),
  .i_plain(i_plain),
  .i_round(round_cnt),
  .o_cipher(o_cipher)
);

//=== Decryptinng Core===
InvCipher u2(
  .i_clk(i_clk),
  .i_rst(i_rst),
  .i_init(start[2]),
  .o_done(dec_done),
  .o_busy(dec_busy),
  .i_key(roundkey),
  .i_cipher(i_cipher),
  .i_round(round_cnt),
  .o_plain(o_plain)
);
//FSM
  always_ff @(posedge i_clk or negedge i_rst) begin
    if (!i_rst) begin
          fsm_state <= IDLE;
    end else begin
      case (fsm_state)
        IDLE: begin
          case (i_start)
            3'b001:  fsm_state <= KEYG;
            3'b010:  fsm_state <= ENCR;
            3'b100:  fsm_state <= DECR;
            default: fsm_state <= IDLE;
          endcase
        end
        KEYG: begin
          fsm_state <= ke_done  ? IDLE : KEYG;
        end
        ENCR: begin
          fsm_state <= enc_done ? IDLE : ENCR;
        end
        DECR: begin
          fsm_state <= dec_done ? IDLE : DECR;
        end
        default: fsm_state <= IDLE;
      endcase
    end
  end

  always_ff @(posedge i_clk or negedge i_rst) begin
    if (!i_rst) begin
          o_done     <= 1'b0;
          round_cnt  <= 4'd0;
          start      <= 'd0;
    end else begin
      case (fsm_state)
        IDLE: begin
          o_done     <= 1'b0;
          round_cnt  <= 4'd0;
          start      <= {dec_start,enc_start,ke_start};
        end
        KEYG: begin
          o_done     <= ke_done;
          round_cnt  <= round_cnt + 1;
          start      <= 'd0;
        end
        ENCR: begin
          o_done     <= enc_done;
          round_cnt  <= round_cnt + 1;
          start      <= 'd0;
          o_result   <= o_cipher;
        end
        DECR: begin
          o_done     <= dec_done;
          round_cnt  <= round_cnt + 1;
          start      <= 'd0;
          o_result   <= o_plain;
        end
        default: begin
          o_done     <= 1'b0;
          round_cnt  <= 4'd0;
          start      <= 'd0;
        end
      endcase
    end
  end

  
  assign o_busy = ke_busy | enc_busy | dec_busy;
  assign decenc     = dec_start || (fsm_state == DECR);
  assign ke_start  =  i_start[0] & ~i_start[1] & ~i_start[2];
  assign enc_start = ~i_start[0] &  i_start[1] & ~i_start[2];
  assign dec_start = ~i_start[0] & ~i_start[1] &  i_start[2];

endmodule 
/* 
  localparam ARK  = 3'd2;
  localparam SUBB = 3'd3;
  localparam SROW = 3'd4;
  localparam MIXC = 3'd5;
  localparam DONE = 3'd6;
  
// Wires
  logic [127:0] aes_roundkey; // Key register
  logic [127:0] aes_state;    // Current AES matrix
  logic [127:0] r_plain;      // Plaintext register
  logic [  3:0] aes_round;
  logic [  2:0] fsm_state; 
  logic [127:0] o_roundkey;
  logic [127:0] o_ark, o_sb, o_sr, o_mc;

KeyExpansion u0(
  .i_clk(i_clk),
  .i_key(aes_roundkey),
  .i_round(aes_round),
  .o_roundkey(o_roundkey)
);

AddRoundKey u1(
  .i_clk(i_clk),
  .i_ark_din(aes_state),
  .i_roundkey(o_roundkey),
  .o_ark_dout(o_ark)
);

SubBytes u2(
  .i_clk(i_clk),
  .i_sb_din(aes_state),
  .o_sb_dout(o_sb)
);

ShiftRows u3(
  .i_clk(i_clk),
  .i_sr_din(aes_state),
  .o_sr_dout(o_sr)
);

MixColumns u4(
  .i_clk(i_clk),
  .i_mc_din(aes_state),
  .o_mc_dout(o_mc)
);

//FSM  
  always_ff @(posedge i_clk or negedge i_rst) begin
    if(!i_rst)  fsm_state <= IDLE;
    else begin
      case(fsm_state)
        IDLE: fsm_state <= i_start              ? ARK  : IDLE;
        ARK:  fsm_state <= (aes_round == 4'd10) ? DONE : SUBB;
        SUBB: fsm_state <= SROW;
        SROW: fsm_state <= (aes_round == 4'd10) ? ARK  : MIXC;
        MIXC: fsm_state <= ARK;
        DONE: fsm_state <= IDLE;
      endcase
    end
  end
  
  always_ff @(posedge i_clk or negedge i_rst) begin
    if(!i_rst) begin
          aes_roundkey <= 'd0;
          aes_round    <= 'd0;
          r_plain      <= 'd0;
          o_cipher     <= 'd0;
          o_done       <= 'd0;
          o_busy       <= 'd0;
    end else begin
      case(fsm_state)
        IDLE: begin
          aes_roundkey <= i_start ? i_key   : 'd0;
          aes_round    <= 4'd0;
          r_plain      <= i_start ? i_plain : 'd0;
          o_cipher     <= i_start ? 128'd0  : o_cipher;
          o_done       <= 1'b0;
          o_busy       <= i_start ? 1'b1    : 1'b0;
        end
        ARK: begin
          aes_roundkey <= o_roundkey;
          aes_round    <= aes_round + 1;
        end
        DONE: begin
          o_cipher     <= aes_state;
          o_done       <= 1'b1;
          o_busy       <= 1'b0;
        end
        default: begin
          aes_roundkey <= aes_roundkey;
          aes_round    <= aes_round;
          r_plain      <= r_plain;
          o_cipher     <= o_cipher;
          o_done       <= o_done;
          o_busy       <= o_busy;
        end
      endcase
    end
  end
  
  always_comb begin
    aes_state = 'd0;
    case(fsm_state)
      IDLE: aes_state = 'd0;
      ARK:  aes_state = (aes_round == 4'd0) ? r_plain : (aes_round == 4'd10) ? o_sr : o_mc;
      SUBB: aes_state = o_ark;
      SROW: aes_state = o_sb;
      MIXC: aes_state = o_sr;
      DONE: aes_state = o_ark;
    endcase
  end
  
endmodule*/