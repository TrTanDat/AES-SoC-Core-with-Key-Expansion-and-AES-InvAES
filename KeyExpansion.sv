module KeyExpansion(
  input  logic         i_clk,
  input  logic         i_rst,
  
  input  logic         i_decrypt,
  input  logic         i_init,
  output logic         o_done,
  output logic         o_busy,  
  
  input  logic [127:0] i_key,
  input  logic [  3:0] i_round,
  output logic [127:0] o_roundkey
);

  localparam IDLE = 1'b0;
  localparam COMP = 1'b1;
  
  logic         ke_state;
  logic [  3:0] ke_round;
  
  logic [127:0] roundkey [0:10];
  logic [127:0] r_key, temp;
  logic [ 31:0] rotword;
  logic [ 31:0] subword;
  logic [ 31:0] rcon; 
  
// Rotword
  assign rotword = {temp[23:0],temp[31:24]};

// SubWord  
SubWords u0(.i_clk(i_clk),.i_sw_din(rotword),.o_sw_dout(subword));

// RoundConstant
  always_comb begin
    case(ke_round)
      4'd0:    rcon = 32'h00000000;
      4'd1:    rcon = 32'h01000000;
      4'd2:    rcon = 32'h02000000;
      4'd3:    rcon = 32'h04000000;
      4'd4:    rcon = 32'h08000000;
      4'd5:    rcon = 32'h10000000;
      4'd6:    rcon = 32'h20000000;
      4'd7:    rcon = 32'h40000000;
      4'd8:    rcon = 32'h80000000;
      4'd9:    rcon = 32'h1b000000;
      4'd10:   rcon = 32'h36000000;
      default: rcon = 32'h00000000;
    endcase
  end
  
  always_ff @(posedge i_clk or negedge i_rst) begin
    if (!i_rst) begin
              ke_state  <= IDLE;
    end else begin
      case (ke_state)
        IDLE: ke_state <= i_init           ? COMP : IDLE;
        COMP: ke_state <= (ke_round == 10) ? IDLE : COMP;
      endcase
    end
  end
  
  always_ff @(posedge i_clk or negedge i_rst) begin
    if (!i_rst) begin
          roundkey           <= '{default:'0};
          ke_round           <= 'd0;
          o_busy             <= 'd0;
          o_done             <= 'd0;
    end else begin
      case (ke_state)
        IDLE: begin
          ke_round           <= 'd0;
          r_key              <= i_init ? i_key : 'd0;
          o_busy             <= i_init;
          o_done             <= 1'b0;
        end
        COMP: begin
          roundkey[ke_round] <= temp;
          ke_round           <= ke_round + 1;
          r_key              <= temp;
          o_busy             <= (ke_round != 10);
          o_done             <= (ke_round == 10);
        end
      endcase
    end
  end
  
  always_comb begin
    case(ke_round)
      4'd0: temp = r_key;
      default: begin
        temp[127:96] = r_key[127:96] ^ subword ^ rcon;
        temp[ 95:64] = r_key[ 95:64] ^ temp[127:96];
        temp[ 63:32] = r_key[ 63:32] ^ temp[ 95:64];
        temp[ 31: 0] = r_key[ 31: 0] ^ temp[ 63:32];
      end
    endcase
  end
  
  always_comb begin
    if(ke_state == IDLE) begin
      case(i_round)
        4'd0 : o_roundkey = i_decrypt ? roundkey[10] : roundkey[ 0];
        4'd1 : o_roundkey = i_decrypt ? roundkey[ 9] : roundkey[ 1];
        4'd2 : o_roundkey = i_decrypt ? roundkey[ 8] : roundkey[ 2];
        4'd3 : o_roundkey = i_decrypt ? roundkey[ 7] : roundkey[ 3];
        4'd4 : o_roundkey = i_decrypt ? roundkey[ 6] : roundkey[ 4];
        4'd5 : o_roundkey = i_decrypt ? roundkey[ 5] : roundkey[ 5];
        4'd6 : o_roundkey = i_decrypt ? roundkey[ 4] : roundkey[ 6];
        4'd7 : o_roundkey = i_decrypt ? roundkey[ 3] : roundkey[ 7];
        4'd8 : o_roundkey = i_decrypt ? roundkey[ 2] : roundkey[ 8];
        4'd9 : o_roundkey = i_decrypt ? roundkey[ 1] : roundkey[ 9];
        4'd10: o_roundkey = i_decrypt ? roundkey[ 0] : roundkey[10];
        default: o_roundkey = 'd0;
      endcase
    end else begin
      o_roundkey = 'd0;
    end
  end
  
endmodule