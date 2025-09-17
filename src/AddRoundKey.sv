module AddRoundKey(
  input  logic [127:0] i_ark_din,
  input  logic [127:0] i_roundkey,
  output logic [127:0] o_ark_dout
);

  assign o_ark_dout = i_ark_din ^ i_roundkey;
  
endmodule