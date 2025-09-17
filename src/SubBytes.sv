module SubBytes(
  input  logic         i_clk,
  input  logic [127:0] i_sb_din,
  output logic [127:0] o_sb_dout
);

SubWords SubWords_inst0(.i_sw_din(i_sb_din[127:96]),.i_clk(i_clk),.o_sw_dout(o_sb_dout[127:96]));
SubWords SubWords_inst1(.i_sw_din(i_sb_din[ 95:64]),.i_clk(i_clk),.o_sw_dout(o_sb_dout[ 95:64]));
SubWords SubWords_inst2(.i_sw_din(i_sb_din[ 63:32]),.i_clk(i_clk),.o_sw_dout(o_sb_dout[ 63:32]));
SubWords SubWords_inst3(.i_sw_din(i_sb_din[ 31: 0]),.i_clk(i_clk),.o_sw_dout(o_sb_dout[ 31: 0]));


endmodule

module SubWords(
  input  logic         i_clk,
  input  logic [31:0] i_sw_din,
  output logic [31:0] o_sw_dout
);

sbox sbox_inst0(.i_sb_data(i_sw_din[ 31: 24]),.i_clk(i_clk),.o_sb_data(o_sw_dout[ 31: 24]));
sbox sbox_inst1(.i_sb_data(i_sw_din[ 23: 16]),.i_clk(i_clk),.o_sb_data(o_sw_dout[ 23: 16]));
sbox sbox_inst2(.i_sb_data(i_sw_din[ 15:  8]),.i_clk(i_clk),.o_sb_data(o_sw_dout[ 15:  8]));
sbox sbox_inst3(.i_sb_data(i_sw_din[  7:  0]),.i_clk(i_clk),.o_sb_data(o_sw_dout[  7:  0]));

endmodule

module InvSubBytes(
  input  logic         i_clk,
  input  logic [127:0] i_sb_din,
  output logic [127:0] o_sb_dout
);

InvSubWords SubWords_inst0(.i_sw_din(i_sb_din[127:96]),.i_clk(i_clk),.o_sw_dout(o_sb_dout[127:96]));
InvSubWords SubWords_inst1(.i_sw_din(i_sb_din[ 95:64]),.i_clk(i_clk),.o_sw_dout(o_sb_dout[ 95:64]));
InvSubWords SubWords_inst2(.i_sw_din(i_sb_din[ 63:32]),.i_clk(i_clk),.o_sw_dout(o_sb_dout[ 63:32]));
InvSubWords SubWords_inst3(.i_sw_din(i_sb_din[ 31: 0]),.i_clk(i_clk),.o_sw_dout(o_sb_dout[ 31: 0]));


endmodule

module InvSubWords(
  input  logic         i_clk,
  input  logic [31:0] i_sw_din,
  output logic [31:0] o_sw_dout
);

inv_sbox sbox_inst0(.i_sb_data(i_sw_din[ 31: 24]),.i_clk(i_clk),.o_sb_data(o_sw_dout[ 31: 24]));
inv_sbox sbox_inst1(.i_sb_data(i_sw_din[ 23: 16]),.i_clk(i_clk),.o_sb_data(o_sw_dout[ 23: 16]));
inv_sbox sbox_inst2(.i_sb_data(i_sw_din[ 15:  8]),.i_clk(i_clk),.o_sb_data(o_sw_dout[ 15:  8]));
inv_sbox sbox_inst3(.i_sb_data(i_sw_din[  7:  0]),.i_clk(i_clk),.o_sb_data(o_sw_dout[  7:  0]));

endmodule