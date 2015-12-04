
module r4_unit_ctl ( clk, rst_n, by_pass, ld0, ld1, ld2 );
  input clk, rst_n;
  output by_pass, ld0, ld1, ld2;
  wire   n7, n8, N9, N10, n1, n2, n3, n4;

  DFFHQX4TS state_reg_0_ ( .D(N9), .CK(clk), .Q(n7) );
  DFFHQX4TS state_reg_1_ ( .D(N10), .CK(clk), .Q(n8) );
  INVX3TS U7 ( .A(n1), .Y(ld1) );
  INVX2TS U8 ( .A(n7), .Y(n1) );
  NAND2X1TS U9 ( .A(ld1), .B(n8), .Y(by_pass) );
  CLKINVX6TS U10 ( .A(n8), .Y(n3) );
  OAI2BB1X1TS U11 ( .A0N(n3), .A1N(n1), .B0(by_pass), .Y(ld0) );
  XOR2X4TS U12 ( .A(n3), .B(n7), .Y(n2) );
  INVX2TS U13 ( .A(rst_n), .Y(n4) );
  NOR2X2TS U14 ( .A(n2), .B(n4), .Y(N10) );
  CLKINVX1TS U15 ( .A(n3), .Y(ld2) );
  NOR2X1TS U16 ( .A(ld1), .B(n4), .Y(N9) );
endmodule

