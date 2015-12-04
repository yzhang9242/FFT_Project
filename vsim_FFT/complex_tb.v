module complex_tb ();
	reg signed [15 : 0] x0_r;
	reg signed [15 : 0] x0_i;
	reg signed [15 : 0] x1_r;
	reg signed [15 : 0] x1_i;
	reg signed [15 : 0] x2_r;
	reg signed [15 : 0] x2_i;
	reg signed [15 : 0] x3_r;
	reg signed [15 : 0] x3_i;
	wire signed [15 : 0] result0_r;
	wire signed [15 : 0] result0_i;
	wire signed [15 : 0] result1_r;
	wire signed [15 : 0] result1_i;
	wire signed [15 : 0] result2_r;
	wire signed [15 : 0] result2_i;
	wire signed [15 : 0] result3_r;
	wire signed [15 : 0] result3_i;
	
initial begin
	#5
	x0_r = 1;
	x0_i = 0;
	x1_r = 2;
	x1_i = 0;
	x2_r = 3;
	x2_i = 0;
	x3_r = 4;
	x3_i = 0;

end
	r4_bf bf_dut (
		.x0_r(x0_r),
		.x0_i(x0_i),
		.x1_r(x1_r),
		.x1_i(x1_i),
		.x2_r(x2_r),
		.x2_i(x2_i),
		.x3_r(x3_r),
		.x3_i(x3_i),
		.f0_r(result_r),
		.f0_i(result_i),
		.f1_r(result_r),
		.f1_i(result_i),
		.f2_r(result_r),
		.f2_i(result_i),
		.f3_r(result_r),
		.f3_i(result_i));

endmodule