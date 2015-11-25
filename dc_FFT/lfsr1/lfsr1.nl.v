
module lfsr1 ( clk, resetn, seed, lfsr_out );
  input [15:0] seed;
  output [15:0] lfsr_out;
  input clk, resetn;
  wire   n49, N4, N5, N6, N7, N8, N9, N10, N11, N12, N13, N14, N16, N17, N18,
         N19, n50, n60, n70, n80, n90, n100, n110, n120, n130, n140, n15, n160,
         n170, n180, n190, n20, n21, n22, n23, n24, n25, n26, n27, n28, n29,
         n30, n31, n32, n33, n34, n35, n36, n37, n38, n39, n40, n41, n42, n43,
         n44, n45, n46, n47;

  DFFHQX4TS lfsr_out_reg_5_ ( .D(N9), .CK(clk), .Q(lfsr_out[5]) );
  DFFHQX4TS lfsr_out_reg_12_ ( .D(N16), .CK(clk), .Q(n49) );
  DFFHQX4TS lfsr_out_reg_15_ ( .D(N19), .CK(clk), .Q(lfsr_out[15]) );
  DFFHQX1TS lfsr_out_reg_1_ ( .D(N5), .CK(clk), .Q(lfsr_out[1]) );
  DFFHQX1TS lfsr_out_reg_2_ ( .D(N6), .CK(clk), .Q(lfsr_out[2]) );
  DFFHQX1TS lfsr_out_reg_3_ ( .D(N7), .CK(clk), .Q(lfsr_out[3]) );
  DFFHQX1TS lfsr_out_reg_4_ ( .D(N8), .CK(clk), .Q(lfsr_out[4]) );
  DFFHQX1TS lfsr_out_reg_6_ ( .D(N10), .CK(clk), .Q(lfsr_out[6]) );
  DFFHQX1TS lfsr_out_reg_7_ ( .D(N11), .CK(clk), .Q(lfsr_out[7]) );
  DFFHQX1TS lfsr_out_reg_9_ ( .D(N13), .CK(clk), .Q(lfsr_out[9]) );
  DFFHQX1TS lfsr_out_reg_10_ ( .D(N14), .CK(clk), .Q(lfsr_out[10]) );
  DFFHQX1TS lfsr_out_reg_14_ ( .D(N18), .CK(clk), .Q(lfsr_out[14]) );
  DFFHQX4TS lfsr_out_reg_13_ ( .D(N17), .CK(clk), .Q(lfsr_out[13]) );
  DFFHQX4TS lfsr_out_reg_0_ ( .D(N4), .CK(clk), .Q(lfsr_out[0]) );
  MDFFHQX1TS lfsr_out_reg_11_ ( .D0(seed[11]), .D1(lfsr_out[10]), .S0(n50), 
        .CK(clk), .Q(lfsr_out[11]) );
  DFFHQX4TS lfsr_out_reg_8_ ( .D(N12), .CK(clk), .Q(lfsr_out[8]) );
  NAND2BX1TS U23 ( .AN(n31), .B(seed[0]), .Y(n90) );
  OAI21X1TS U24 ( .A0(n47), .A1(n46), .B0(n45), .Y(N17) );
  OAI21X1TS U25 ( .A0(n15), .A1(n180), .B0(n140), .Y(N13) );
  NAND2X1TS U26 ( .A(lfsr_out[13]), .B(n44), .Y(n110) );
  INVX2TS U27 ( .A(n130), .Y(n31) );
  INVX1TS U28 ( .A(n80), .Y(n50) );
  BUFX3TS U29 ( .A(n80), .Y(n130) );
  XNOR2X4TS U30 ( .A(lfsr_out[5]), .B(lfsr_out[0]), .Y(n70) );
  XOR2X4TS U31 ( .A(lfsr_out[15]), .B(n49), .Y(n60) );
  XOR2X4TS U32 ( .A(n70), .B(n60), .Y(n100) );
  INVX2TS U33 ( .A(resetn), .Y(n80) );
  OAI21X2TS U34 ( .A0(n100), .A1(n130), .B0(n90), .Y(N4) );
  INVX2TS U35 ( .A(seed[14]), .Y(n120) );
  INVX2TS U36 ( .A(n130), .Y(n46) );
  BUFX4TS U37 ( .A(n80), .Y(n27) );
  INVX2TS U38 ( .A(n27), .Y(n44) );
  OAI21X1TS U39 ( .A0(n120), .A1(n46), .B0(n110), .Y(N18) );
  CLKBUFX2TS U40 ( .A(n49), .Y(lfsr_out[12]) );
  INVX2TS U41 ( .A(seed[9]), .Y(n15) );
  INVX2TS U42 ( .A(n80), .Y(n180) );
  NAND2X1TS U43 ( .A(lfsr_out[8]), .B(n180), .Y(n140) );
  INVX2TS U44 ( .A(seed[10]), .Y(n170) );
  NAND2X1TS U45 ( .A(lfsr_out[9]), .B(n180), .Y(n160) );
  OAI21X1TS U46 ( .A0(n170), .A1(n50), .B0(n160), .Y(N14) );
  INVX2TS U47 ( .A(seed[8]), .Y(n20) );
  INVX2TS U48 ( .A(n27), .Y(n37) );
  NAND2X1TS U49 ( .A(lfsr_out[7]), .B(n180), .Y(n190) );
  OAI21X1TS U50 ( .A0(n20), .A1(n37), .B0(n190), .Y(N12) );
  INVX2TS U51 ( .A(seed[5]), .Y(n22) );
  INVX2TS U52 ( .A(n27), .Y(n33) );
  NAND2X1TS U53 ( .A(lfsr_out[4]), .B(n33), .Y(n21) );
  OAI21X1TS U54 ( .A0(n22), .A1(n37), .B0(n21), .Y(N9) );
  INVX2TS U55 ( .A(seed[15]), .Y(n24) );
  NAND2X1TS U56 ( .A(lfsr_out[14]), .B(n44), .Y(n23) );
  OAI21X1TS U57 ( .A0(n24), .A1(n31), .B0(n23), .Y(N19) );
  INVX2TS U58 ( .A(seed[12]), .Y(n26) );
  NAND2X1TS U59 ( .A(lfsr_out[11]), .B(n44), .Y(n25) );
  OAI21X1TS U60 ( .A0(n26), .A1(n46), .B0(n25), .Y(N16) );
  INVX2TS U61 ( .A(seed[6]), .Y(n29) );
  INVX2TS U62 ( .A(n27), .Y(n41) );
  NAND2X1TS U63 ( .A(lfsr_out[5]), .B(n33), .Y(n28) );
  OAI21X1TS U64 ( .A0(n29), .A1(n41), .B0(n28), .Y(N10) );
  INVX2TS U65 ( .A(seed[1]), .Y(n32) );
  NAND2X1TS U66 ( .A(lfsr_out[0]), .B(n33), .Y(n30) );
  OAI21X1TS U67 ( .A0(n32), .A1(n31), .B0(n30), .Y(N5) );
  INVX2TS U68 ( .A(seed[7]), .Y(n35) );
  NAND2X1TS U69 ( .A(lfsr_out[6]), .B(n33), .Y(n34) );
  OAI21X1TS U70 ( .A0(n35), .A1(n37), .B0(n34), .Y(N11) );
  INVX2TS U71 ( .A(seed[4]), .Y(n38) );
  NAND2X1TS U72 ( .A(lfsr_out[3]), .B(n41), .Y(n36) );
  OAI21X1TS U73 ( .A0(n38), .A1(n37), .B0(n36), .Y(N8) );
  INVX2TS U74 ( .A(seed[3]), .Y(n40) );
  NAND2X1TS U75 ( .A(lfsr_out[2]), .B(n41), .Y(n39) );
  OAI21X1TS U76 ( .A0(n40), .A1(n50), .B0(n39), .Y(N7) );
  INVX2TS U77 ( .A(seed[2]), .Y(n43) );
  NAND2X1TS U78 ( .A(lfsr_out[1]), .B(n41), .Y(n42) );
  OAI21X1TS U79 ( .A0(n43), .A1(n46), .B0(n42), .Y(N6) );
  INVX2TS U80 ( .A(seed[13]), .Y(n47) );
  NAND2X1TS U81 ( .A(lfsr_out[12]), .B(n44), .Y(n45) );
endmodule

