module ShiftRows(
  input  logic [127:0] i_sr_din,
  output logic [127:0] o_sr_dout
);
  
  logic [127:0] w_sr_dout;

  assign w_sr_dout[127:96] = {i_sr_din[127:120],i_sr_din[ 87: 80],i_sr_din[ 47: 40],i_sr_din[  7:  0]};
  assign w_sr_dout[ 95:64] = {i_sr_din[ 95: 88],i_sr_din[ 55: 48],i_sr_din[ 15:  8],i_sr_din[103: 96]};
  assign w_sr_dout[ 63:32] = {i_sr_din[ 63: 56],i_sr_din[ 23: 16],i_sr_din[111:104],i_sr_din[ 71: 64]};
  assign w_sr_dout[ 31: 0] = {i_sr_din[ 31: 24],i_sr_din[119:112],i_sr_din[ 79: 72],i_sr_din[ 39: 32]};

  assign o_sr_dout = w_sr_dout;
  
endmodule

module InvShiftRows(
  input  logic [127:0] i_sr_din,
  output logic [127:0] o_sr_dout
);
  
  logic [127:0] w_sr_dout;

  assign w_sr_dout[127:96] = {i_sr_din[127:120],i_sr_din[ 23: 16],i_sr_din[ 47: 40],i_sr_din[ 71: 64]};
  assign w_sr_dout[ 95:64] = {i_sr_din[ 95: 88],i_sr_din[119:112],i_sr_din[ 15:  8],i_sr_din[ 39: 32]};
  assign w_sr_dout[ 63:32] = {i_sr_din[ 63: 56],i_sr_din[ 87: 80],i_sr_din[111:104],i_sr_din[  7:  0]};
  assign w_sr_dout[ 31: 0] = {i_sr_din[ 31: 24],i_sr_din[ 55: 48],i_sr_din[ 79: 72],i_sr_din[103: 96]};

  assign o_sr_dout = w_sr_dout;
  
endmodule