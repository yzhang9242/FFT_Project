module cordic_tb ();
	reg clk;
	reg rst_n;
	reg signed [15 : 0] real_in;
	reg signed [15 : 0] img_in;
	reg signed [15 : 0] z_in;
	wire signed [15 : 0] real_out;
	wire signed [15 : 0] img_out;

	initial begin
		clk = 1;
		repeat (20) begin
			#5
			clk = ~clk;
		end
	end
	initial begin
		rst_n = 0;
		#11
		rst_n = 1;
	end
	// Instantiate DUT
	cordic_nppl dut (
			.real_in(real_in),
			.img_in(img_in),
			.z_in(z_in),
			.real_out(real_out),
			.img_out(img_out));

	always @(posedge clk or rst_n) begin
		if (rst_n == 0) begin
			real_in <= '0;
			img_in <= '0;
			z_in <= '0;
		end
		else begin
			real_in <= 512;
			img_in <= 0;
			z_in <= 29184;
		end
	end
endmodule
