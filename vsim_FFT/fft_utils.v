module r4_bf (x0_r, x0_i, x1_r, x1_i, x2_r, x2_i, x3_r, x3_i, f0_r, f0_i, f1_r, f1_i, f2_r, f2_i, f3_r, f3_i);
	input signed [15 : 0] x0_r;
	input signed [15 : 0] x0_i;
	input signed [15 : 0] x1_r;
	input signed [15 : 0] x1_i;
	input signed [15 : 0] x2_r;
	input signed [15 : 0] x2_i;
	input signed [15 : 0] x3_r;
	input signed [15 : 0] x3_i;
	output signed [15 : 0] f0_r;
	output signed [15 : 0] f0_i;
	output signed [15 : 0] f1_r;
	output signed [15 : 0] f1_i;
	output signed [15 : 0] f2_r;
	output signed [15 : 0] f2_i;
	output signed [15 : 0] f3_r;
	output signed [15 : 0] f3_i;

	wire signed [15 : 0] x1i_r;
	wire signed [15 : 0] x1i_i;
	wire signed [15 : 0] x3i_r;
	wire signed [15 : 0] x3i_i;

	// Internal wires
	wire signed [15 : 0] m0_r [3 : 0];
	wire signed [15 : 0] m0_i [3 : 0];
	wire signed [15 : 0] m1_r [3 : 0];
	wire signed [15 : 0] m1_i [3 : 0];
	
	// x1 multipled by i
	complex_i bf_1i (
		.x_r(x1_r),
		.x_i(x1_i),
		.result_r(x1i_r),
		.result_i(x1i_i));
	
	// x3 multipled by i
	complex_i bf_3i (
		.x_r(x3_r),
		.x_i(x3_i),
		.result_r(x3i_r),
		.result_i(x3i_i));
	
	// f0 = x0 + x1 + x2 + x3
	complex_add bf_00(
		.x_r(x0_r),
		.x_i(x0_i),
		.y_r(x1_r),
		.y_i(x1_i),
		.result_r(m0_r[0]),
		.result_i(m0_i[0]));
	complex_add bf_01 (
		.x_r(m0_r[0]),
		.x_i(m0_i[0]),
		.y_r(x2_r),
		.y_i(x2_i),
		.result_r(m1_r[0]),
		.result_i(m1_i[0]));
	complex_add bf_02 (
		.x_r(m1_r[0]),
		.x_i(m1_i[0]),
		.y_r(x3_r),
		.y_i(x3_i),
		.result_r(f0_r),
		.result_i(f0_i));
	// f1 = x0 - i * x1 - x2 + i * x3
	complex_sub bf_10(
		.x_r(x0_r),
		.x_i(x0_i),
		.y_r(x1i_r),
		.y_i(x1i_i),
		.result_r(m0_r[1]),
		.result_i(m0_i[1]));
	complex_sub bf_11 (
		.x_r(m0_r[1]),
		.x_i(m0_i[1]),
		.y_r(x2_r),
		.y_i(x2_i),
		.result_r(m1_r[1]),
		.result_i(m1_i[1]));
	complex_add bf_12 (
		.x_r(m1_r[1]),
		.x_i(m1_i[1]),
		.y_r(x3i_r),
		.y_i(x3i_i),
		.result_r(f1_r),
		.result_i(f1_i));
	// f2 = x0 -x1 + x2 - x3
	complex_sub bf_20(
		.x_r(x0_r),
		.x_i(x0_i),
		.y_r(x1_r),
		.y_i(x1_i),
		.result_r(m0_r[2]),
		.result_i(m0_i[2]));
	complex_add bf_21 (
		.x_r(m0_r[2]),
		.x_i(m0_i[2]),
		.y_r(x2_r),
		.y_i(x2_i),
		.result_r(m1_r[2]),
		.result_i(m1_i[2]));
	complex_sub bf_22 (
		.x_r(m1_r[2]),
		.x_i(m1_i[2]),
		.y_r(x3_r),
		.y_i(x3_i),
		.result_r(f2_r),
		.result_i(f2_i));
	// f3 = x0 + i * x1 - x2 - i * x3
	complex_add bf_30(
		.x_r(x0_r),
		.x_i(x0_i),
		.y_r(x1i_r),
		.y_i(x1i_i),
		.result_r(m0_r[3]),
		.result_i(m0_i[3]));
	complex_sub bf_31 (
		.x_r(m0_r[3]),
		.x_i(m0_i[3]),
		.y_r(x2_r),
		.y_i(x2_i),
		.result_r(m1_r[3]),
		.result_i(m1_i[3]));
	complex_sub bf_32 (
		.x_r(m1_r[3]),
		.x_i(m1_i[3]),
		.y_r(x3i_r),
		.y_i(x3i_i),
		.result_r(f3_r),
		.result_i(f3_i));
endmodule