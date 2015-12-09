module cordic_iter (real_in, img_in, z_in, real_out, img_out, z_out, theta, sh);
	input signed [15 : 0] theta;
	input signed [15 : 0] real_in;
	input signed [15 : 0] img_in;
	input signed [15 : 0] z_in;
	input unsigned [3 : 0] sh;
	output reg signed [15 : 0] real_out;
	output reg signed [15 : 0] img_out; 
	output reg signed [15 : 0] z_out;

	wire signed [15 : 0] real_shd;
	wire signed [15 : 0] img_shd;
	wire u;

	assign u = z_in[15];
	assign real_shd = real_in >>> sh;
	assign img_shd = img_in >>> sh;

	always @(real_in or img_in or z_in) begin
		if (u == 0) begin
			real_out <= real_in - img_shd;
			img_out <= img_in + real_shd;
			z_out <= z_in - theta;
		end
		else begin
			real_out <= real_in + img_shd;
			img_out <= img_in - real_shd;
			z_out <= z_in + theta;
		end
	end
endmodule

module cordic_nppl (real_in, img_in, z_in, real_out, img_out);
	input signed [15 : 0] real_in;
	input signed [15 : 0] img_in;
	input signed [15 : 0] z_in;
	
	output signed [15 : 0] real_out;
	output signed [15 : 0] img_out;
	
	wire signed [15 : 0] x_real [0 : 16];
	wire signed [15 : 0] x_img [0 : 16];
	wire signed [15 : 0] z[0 : 16];

	localparam signed [15 : 0] theta [0 : 15] = '{11520, 6801, 3593, 1824, 915, 458, 229, 115, 57, 29, 14, 7, 4, 2, 1, 0}; 

	assign x_real[0] = real_in;
	assign x_img[0] = img_in;
	assign z[0] = z_in;

	genvar i;
	generate
		for (i = 0; i < 16; i = i + 1) begin : iterations
			cordic_iter u (
					.real_in(x_real[i]),
					.img_in(x_img[i]),
					.z_in(z[i]),
					.real_out(x_real[i + 1]),
					.img_out(x_img[i + 1]),
					.z_out(z[i + 1]),
					.theta(theta[i]),
					.sh(i));
		end
	endgenerate

	assign real_out = x_real[16];
	assign img_out = x_img[16];
endmodule
