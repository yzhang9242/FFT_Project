// Addition for complex numbers
module complex_add (x_r, x_i, y_r, y_i, result_r, result_i);
	input signed [15 : 0] x_r;
	input signed [15 : 0] x_i;
	input signed [15 : 0] y_r;
	input signed [15 : 0] y_i;
	output signed [15 : 0] result_r;
	output signed [15 : 0] result_i;

	assign result_r = x_r + y_r;
	assign result_i = x_i + y_i;
endmodule

// Subtraction for complex numbers
module complex_sub (x_r, x_i, y_r, y_i, result_r, result_i);
	input signed [15 : 0] x_r;
	input signed [15 : 0] x_i;
	input signed [15 : 0] y_r;
	input signed [15 : 0] y_i;
	output signed [15 : 0] result_r;
	output signed [15 : 0] result_i;

	assign result_r = x_r - y_r;
	assign result_i = x_i - y_i;
endmodule

// Multiple a complex number by i
module complex_i (x_r, x_i, result_r, result_i);
	input signed [15 : 0] x_r;
	input signed [15 : 0] x_i;
	output signed [15 : 0] result_r;
	output signed [15 : 0] result_i;

	assign result_r = -x_i;
	assign result_i = x_r;
endmodule
