module InvCipher(
  input  logic         i_clk,
  input  logic         i_rst,
  
  input  logic         i_init,
  output logic         o_done,
  output logic         o_busy,
  
  output logic [127:0] tb_ark, tb_sb, tb_sr, tb_mc,
  
  input  logic [127:0] i_key,
  input  logic [127:0] i_cipher,
  input  logic [  3:0] i_round,
  output logic [127:0] o_plain
);

  assign tb_ark = o_ark;
  assign tb_sb  = o_sb;
  assign tb_sr  = o_sr;
  assign tb_mc  = o_mc;

  localparam IDLE = 1'b0;
  localparam COMP = 1'b1;
  logic         fsm_state;

  logic [127:0] i_ark, o_ark;
  logic [127:0] i_sb,  o_sb;
  logic [127:0] i_sr,  o_sr;
  logic [127:0] i_mc,  o_mc;

AddRoundKey u0(
  .i_ark_din(i_ark),
  .i_roundkey(i_key),
  .o_ark_dout(o_ark)
);  

InvSubBytes u1(
  .i_clk(i_clk),
  .i_sb_din(i_sb),
  .o_sb_dout(o_sb)
);

InvShiftRows u2(
  .i_sr_din(i_sr),
  .o_sr_dout(o_sr)
);

InvMixColumns u3(
  .i_mc_din(i_mc),
  .o_mc_dout(o_mc)
);

  always_ff @(posedge i_clk or negedge i_rst) begin
    if(!i_rst) begin
                 fsm_state <= IDLE;
    end else begin
      case (fsm_state)
        IDLE:    fsm_state <= i_init             ? COMP : IDLE;
        COMP:    fsm_state <= (i_round == 4'd10) ? IDLE : COMP; 
        default: fsm_state <= IDLE;
      endcase
    end
  end
  
  always_ff @(posedge i_clk or negedge i_rst) begin
    if( !i_rst) begin
          o_plain <= 'd0;
    end else begin
      case (fsm_state)
        IDLE: begin
          o_plain <= o_plain;
          o_done  <= 1'b0;
          o_busy  <= i_init;
        end
        COMP: begin
          o_plain <= (i_round == 4'd10) ? o_ark : o_plain;
          o_done  <= (i_round == 4'd10) ? 1'b1  : 1'b0;
          o_busy  <= (i_round == 4'd10) ? 1'b0  : 1'b1;
        end
        default: begin
          o_plain <= o_plain;
        
        end
      endcase
    end
  end
  
  always_comb begin
    case (fsm_state)
      IDLE: begin
        i_ark = i_cipher;
        i_sb  = o_sr;
        i_sr  = o_ark;
        i_mc  = 'd0;
      end
      COMP: begin
        i_ark = o_sb;
        i_sb  = o_sr;
        i_sr  = o_mc;
        i_mc  = o_ark;
      end
    endcase
  end
  
endmodule