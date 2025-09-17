module MixColumns(
  input  logic [127:0] i_mc_din,
  output logic [127:0] o_mc_dout
);

  logic [7:0] mb2 [0:15];
  logic [7:0] mb3 [0:15];
  logic [127:0] w_mc_dout;
  
  mb mb_u1  (.i_byte(i_mc_din[127:120]),.mb2(mb2[ 0]),.mb3(mb3[ 0]));
  mb mb_u2  (.i_byte(i_mc_din[119:112]),.mb2(mb2[ 1]),.mb3(mb3[ 1]));
  mb mb_u3  (.i_byte(i_mc_din[111:104]),.mb2(mb2[ 2]),.mb3(mb3[ 2]));
  mb mb_u4  (.i_byte(i_mc_din[103: 96]),.mb2(mb2[ 3]),.mb3(mb3[ 3]));
  mb mb_u5  (.i_byte(i_mc_din[ 95: 88]),.mb2(mb2[ 4]),.mb3(mb3[ 4]));
  mb mb_u6  (.i_byte(i_mc_din[ 87: 80]),.mb2(mb2[ 5]),.mb3(mb3[ 5]));
  mb mb_u7  (.i_byte(i_mc_din[ 79: 72]),.mb2(mb2[ 6]),.mb3(mb3[ 6]));
  mb mb_u8  (.i_byte(i_mc_din[ 71: 64]),.mb2(mb2[ 7]),.mb3(mb3[ 7]));
  mb mb_u9  (.i_byte(i_mc_din[ 63: 56]),.mb2(mb2[ 8]),.mb3(mb3[ 8]));
  mb mb_u10 (.i_byte(i_mc_din[ 55: 48]),.mb2(mb2[ 9]),.mb3(mb3[ 9]));
  mb mb_u11 (.i_byte(i_mc_din[ 47: 40]),.mb2(mb2[10]),.mb3(mb3[10]));
  mb mb_u12 (.i_byte(i_mc_din[ 39: 32]),.mb2(mb2[11]),.mb3(mb3[11]));
  mb mb_u13 (.i_byte(i_mc_din[ 31: 24]),.mb2(mb2[12]),.mb3(mb3[12]));
  mb mb_u14 (.i_byte(i_mc_din[ 23: 16]),.mb2(mb2[13]),.mb3(mb3[13]));
  mb mb_u15 (.i_byte(i_mc_din[ 15:  8]),.mb2(mb2[14]),.mb3(mb3[14]));
  mb mb_u16 (.i_byte(i_mc_din[  7:  0]),.mb2(mb2[15]),.mb3(mb3[15]));
  
  assign w_mc_dout[127:120] = mb2[ 0] ^ mb3[ 1] ^ i_mc_din[111:104] ^ i_mc_din[103: 96];
  assign w_mc_dout[119:112] = mb2[ 1] ^ mb3[ 2] ^ i_mc_din[103: 96] ^ i_mc_din[127:120];
  assign w_mc_dout[111:104] = mb2[ 2] ^ mb3[ 3] ^ i_mc_din[127:120] ^ i_mc_din[119:112];
  assign w_mc_dout[103: 96] = mb2[ 3] ^ mb3[ 0] ^ i_mc_din[119:112] ^ i_mc_din[111:104];
  assign w_mc_dout[ 95: 88] = mb2[ 4] ^ mb3[ 5] ^ i_mc_din[ 79: 72] ^ i_mc_din[ 71: 64];
  assign w_mc_dout[ 87: 80] = mb2[ 5] ^ mb3[ 6] ^ i_mc_din[ 71: 64] ^ i_mc_din[ 95: 88];
  assign w_mc_dout[ 79: 72] = mb2[ 6] ^ mb3[ 7] ^ i_mc_din[ 95: 88] ^ i_mc_din[ 87: 80];
  assign w_mc_dout[ 71: 64] = mb2[ 7] ^ mb3[ 4] ^ i_mc_din[ 87: 80] ^ i_mc_din[ 79: 72];
  assign w_mc_dout[ 63: 56] = mb2[ 8] ^ mb3[ 9] ^ i_mc_din[ 47: 40] ^ i_mc_din[ 39: 32];
  assign w_mc_dout[ 55: 48] = mb2[ 9] ^ mb3[10] ^ i_mc_din[ 39: 32] ^ i_mc_din[ 63: 56];
  assign w_mc_dout[ 47: 40] = mb2[10] ^ mb3[11] ^ i_mc_din[ 63: 56] ^ i_mc_din[ 55: 48];
  assign w_mc_dout[ 39: 32] = mb2[11] ^ mb3[ 8] ^ i_mc_din[ 55: 48] ^ i_mc_din[ 47: 40];
  assign w_mc_dout[ 31: 24] = mb2[12] ^ mb3[13] ^ i_mc_din[ 15:  8] ^ i_mc_din[  7:  0];
  assign w_mc_dout[ 23: 16] = mb2[13] ^ mb3[14] ^ i_mc_din[  7:  0] ^ i_mc_din[ 31: 24];
  assign w_mc_dout[ 15:  8] = mb2[14] ^ mb3[15] ^ i_mc_din[ 31: 24] ^ i_mc_din[ 23: 16];
  assign w_mc_dout[  7:  0] = mb2[15] ^ mb3[12] ^ i_mc_din[ 23: 16] ^ i_mc_din[ 15:  8];
  
  assign o_mc_dout = w_mc_dout;
  
endmodule

module InvMixColumns(
  input  logic [127:0] i_mc_din,
  output logic [127:0] o_mc_dout
);

  logic [7:0] mb9 [0:15];
  logic [7:0] mbb [0:15];
  logic [7:0] mbd [0:15];
  logic [7:0] mbe [0:15];
  
  logic [127:0] w_mc_dout;
  
  mb mb_u1  (.i_byte(i_mc_din[127:120]),.mb9(mb9[ 0]),.mbb(mbb[ 0]),.mbd(mbd[ 0]),.mbe(mbe[ 0]));
  mb mb_u2  (.i_byte(i_mc_din[119:112]),.mb9(mb9[ 1]),.mbb(mbb[ 1]),.mbd(mbd[ 1]),.mbe(mbe[ 1]));
  mb mb_u3  (.i_byte(i_mc_din[111:104]),.mb9(mb9[ 2]),.mbb(mbb[ 2]),.mbd(mbd[ 2]),.mbe(mbe[ 2]));
  mb mb_u4  (.i_byte(i_mc_din[103: 96]),.mb9(mb9[ 3]),.mbb(mbb[ 3]),.mbd(mbd[ 3]),.mbe(mbe[ 3]));
  mb mb_u5  (.i_byte(i_mc_din[ 95: 88]),.mb9(mb9[ 4]),.mbb(mbb[ 4]),.mbd(mbd[ 4]),.mbe(mbe[ 4]));
  mb mb_u6  (.i_byte(i_mc_din[ 87: 80]),.mb9(mb9[ 5]),.mbb(mbb[ 5]),.mbd(mbd[ 5]),.mbe(mbe[ 5]));
  mb mb_u7  (.i_byte(i_mc_din[ 79: 72]),.mb9(mb9[ 6]),.mbb(mbb[ 6]),.mbd(mbd[ 6]),.mbe(mbe[ 6]));
  mb mb_u8  (.i_byte(i_mc_din[ 71: 64]),.mb9(mb9[ 7]),.mbb(mbb[ 7]),.mbd(mbd[ 7]),.mbe(mbe[ 7]));
  mb mb_u9  (.i_byte(i_mc_din[ 63: 56]),.mb9(mb9[ 8]),.mbb(mbb[ 8]),.mbd(mbd[ 8]),.mbe(mbe[ 8]));
  mb mb_u10 (.i_byte(i_mc_din[ 55: 48]),.mb9(mb9[ 9]),.mbb(mbb[ 9]),.mbd(mbd[ 9]),.mbe(mbe[ 9]));
  mb mb_u11 (.i_byte(i_mc_din[ 47: 40]),.mb9(mb9[10]),.mbb(mbb[10]),.mbd(mbd[10]),.mbe(mbe[10]));
  mb mb_u12 (.i_byte(i_mc_din[ 39: 32]),.mb9(mb9[11]),.mbb(mbb[11]),.mbd(mbd[11]),.mbe(mbe[11]));
  mb mb_u13 (.i_byte(i_mc_din[ 31: 24]),.mb9(mb9[12]),.mbb(mbb[12]),.mbd(mbd[12]),.mbe(mbe[12]));
  mb mb_u14 (.i_byte(i_mc_din[ 23: 16]),.mb9(mb9[13]),.mbb(mbb[13]),.mbd(mbd[13]),.mbe(mbe[13]));
  mb mb_u15 (.i_byte(i_mc_din[ 15:  8]),.mb9(mb9[14]),.mbb(mbb[14]),.mbd(mbd[14]),.mbe(mbe[14]));
  mb mb_u16 (.i_byte(i_mc_din[  7:  0]),.mb9(mb9[15]),.mbb(mbb[15]),.mbd(mbd[15]),.mbe(mbe[15]));
  
  assign w_mc_dout[127:120] = mbe[ 0] ^ mbb[ 1] ^ mbd[ 2] ^ mb9[ 3];
  assign w_mc_dout[119:112] = mbe[ 1] ^ mbb[ 2] ^ mbd[ 3] ^ mb9[ 0];
  assign w_mc_dout[111:104] = mbe[ 2] ^ mbb[ 3] ^ mbd[ 0] ^ mb9[ 1];
  assign w_mc_dout[103: 96] = mbe[ 3] ^ mbb[ 0] ^ mbd[ 1] ^ mb9[ 2];
  
  assign w_mc_dout[ 95: 88] = mbe[ 4] ^ mbb[ 5] ^ mbd[ 6] ^ mb9[ 7];
  assign w_mc_dout[ 87: 80] = mbe[ 5] ^ mbb[ 6] ^ mbd[ 7] ^ mb9[ 4];
  assign w_mc_dout[ 79: 72] = mbe[ 6] ^ mbb[ 7] ^ mbd[ 4] ^ mb9[ 5];
  assign w_mc_dout[ 71: 64] = mbe[ 7] ^ mbb[ 4] ^ mbd[ 5] ^ mb9[ 6];
  
  assign w_mc_dout[ 63: 56] = mbe[ 8] ^ mbb[ 9] ^ mbd[10] ^ mb9[11];
  assign w_mc_dout[ 55: 48] = mbe[ 9] ^ mbb[10] ^ mbd[11] ^ mb9[ 8];
  assign w_mc_dout[ 47: 40] = mbe[10] ^ mbb[11] ^ mbd[ 8] ^ mb9[ 9];
  assign w_mc_dout[ 39: 32] = mbe[11] ^ mbb[ 8] ^ mbd[ 9] ^ mb9[10];
  
  assign w_mc_dout[ 31: 24] = mbe[12] ^ mbb[13] ^ mbd[14] ^ mb9[15];
  assign w_mc_dout[ 23: 16] = mbe[13] ^ mbb[14] ^ mbd[15] ^ mb9[12];
  assign w_mc_dout[ 15:  8] = mbe[14] ^ mbb[15] ^ mbd[12] ^ mb9[13];
  assign w_mc_dout[  7:  0] = mbe[15] ^ mbb[12] ^ mbd[13] ^ mb9[14];
 
  assign o_mc_dout = w_mc_dout;
  
endmodule

module mb(
  input  logic [7:0] i_byte,
  output logic [7:0] mb2,
  output logic [7:0] mb3,
  output logic [7:0] mb9,
  output logic [7:0] mbb,
  output logic [7:0] mbd,
  output logic [7:0] mbe
);
  logic [7:0] mb1,mb4,mb8;
  
  assign mb1 = i_byte;
  
  assign mb2 = mb1[7] ? (mb1 << 1) ^ 8'h1b : mb1 << 1;
  assign mb4 = mb2[7] ? (mb2 << 1) ^ 8'h1b : mb2 << 1;
  assign mb8 = mb4[7] ? (mb4 << 1) ^ 8'h1b : mb4 << 1;
  
  assign mb3 = mb2 ^ mb1;
  
  assign mb9 = mb8 ^ mb1;
  assign mbb = mb8 ^ mb2 ^ mb1;
  assign mbd = mb8 ^ mb4 ^ mb1;
  assign mbe = mb8 ^ mb4 ^ mb2;
  
endmodule