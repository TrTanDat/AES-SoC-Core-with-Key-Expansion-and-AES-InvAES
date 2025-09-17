module sbox(
  input  logic       i_clk,
  input  logic [7:0] i_sb_data,
  output logic [7:0] o_sb_data
);

  logic [7:0] sbox [0:255];
  initial $readmemh("sbox_table.hex", sbox);

  always_ff @(posedge i_clk) begin
    o_sb_data <= sbox[i_sb_data];
  end
  
endmodule

module inv_sbox(
  input  logic       i_clk,
  input  logic [7:0] i_sb_data,
  output logic [7:0] o_sb_data
);

  logic [7:0] sbox [0:255];
  initial $readmemh("inv_sbox_table.hex", sbox);

  always_ff @(posedge i_clk) begin
    o_sb_data <= sbox[i_sb_data];
  end
  
endmodule