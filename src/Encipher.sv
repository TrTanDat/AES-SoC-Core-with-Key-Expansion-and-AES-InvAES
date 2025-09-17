module Encipher(
  input  logic         i_clk,
  input  logic         i_rst,
  
  input  logic         i_init,
  output logic         o_done,
  output logic         o_busy,
  
  input  logic [127:0] i_key,
  input  logic [127:0] i_plain,
  input  logic [  3:0] i_round,
  output logic [127:0] o_cipher
);

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

SubBytes u1(
  .i_clk(i_clk),
  .i_sb_din(i_sb),
  .o_sb_dout(o_sb)
);

ShiftRows u2(
  .i_sr_din(i_sr),
  .o_sr_dout(o_sr)
);

MixColumns u3(
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
          o_cipher <= 'd0;
    end else begin
      case (fsm_state)
        IDLE: begin
          o_cipher <= o_cipher;
          o_done   <= 1'b0;
          o_busy   <= i_init;
        end
        COMP: begin
          o_cipher <= (i_round == 4'd10) ? o_ark : o_cipher;
          o_done   <= (i_round == 4'd10) ? 1'b1  : 1'b0;
          o_busy   <= (i_round == 4'd10) ? 1'b0  : 1'b1;
        end
        default: begin
          o_cipher <= o_cipher;
        
        end
      endcase
    end
  end
  
  always_comb begin
    case (fsm_state)
      IDLE: begin
        i_ark = i_plain;
        i_sb  = o_ark;
        i_sr  = 'd0;
        i_mc  = 'd0;
      end
      COMP: begin
        i_ark = (i_round == 4'd10) ? o_sr : o_mc;
        i_sb  = o_ark;
        i_sr  = o_sb;
        i_mc  = (i_round == 4'd10) ? 'd0  : o_sr;
      end
    endcase
  end
  
endmodule