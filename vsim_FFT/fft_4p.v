// FSM controller for r4_unit
module fft_4p_unit_ctl (clk, rst_n, enable, by_pass, ld0, ld1, ld2);
	input clk;
	input rst_n;
	input enable;
	output reg by_pass, ld0, ld1, ld2;
	
	reg [1 : 0] state;
	
	always @(posedge clk) begin
		if (rst_n == 0) begin
			state <= 0;
		end
		else if (enable == 1) begin
			if (state == 0) state <= 1;
			else if (state == 1) state <= 2;
			else if (state == 2) state <= 3;
			else state <= 0;
		end
	end
	
	always @(state) begin
		if (state == 0) begin
			by_pass <= 1;
			ld0 <= 1;
			ld1 <= 0;
			ld2 <= 0;
		end
		else if (state == 1) begin
			by_pass <= 1;
			ld0 <= 0;
			ld1 <= 1;
			ld2 <= 0;
		end
		else if (state == 2) begin
			by_pass <= 1;
			ld0 <= 0;
			ld1 <= 0;
			ld2 <= 1;
		end
		else begin
			by_pass <= 0;
			ld0 <= 1;
			ld1 <= 1;
			ld2 <= 1;
		end
	end
endmodule

module fft_4pt_stage (clk, rst_n, enable, data_in_r, data_in_i, data_out_r, data_out_i);
	input clk;
	input rst_n;
	input enable;
	
	input signed [15 : 0] data_in_r;
	input signed [15 : 0] data_in_i;
	output reg signed [15 : 0] data_out_r;
	output reg signed [15 : 0] data_out_i;

	// Control signals
	wire by_pass;
	wire ld0, ld1, ld2;

	// Data registers
	reg signed [15 : 0] data_0_r;
	reg signed [15 : 0] data_0_i;
	reg signed [15 : 0] data_1_r;
	reg signed [15 : 0] data_1_i;
	reg signed [15 : 0] data_2_r;
	reg signed [15 : 0] data_2_i;
	
	// radix-4 FFT butterfly
	wire signed [15 : 0] f0_r;
	wire signed [15 : 0] f0_i;
	wire signed [15 : 0] f1_r;
	wire signed [15 : 0] f1_i;
	wire signed [15 : 0] f2_r;
	wire signed [15 : 0] f2_i;
	wire signed [15 : 0] f3_r;
	wire signed [15 : 0] f3_i;

	r4_bf butterfly (
		.x0_r(data_0_r),
		.x0_i(data_0_i),
		.x1_r(data_1_r),
		.x1_i(data_1_i),
		.x2_r(data_2_r),
		.x2_i(data_2_i),
		.x3_r(data_in_r),
		.x3_i(data_in_i),
		.f0_r(f0_r),
		.f0_i(f0_i),
		.f1_r(f1_r),
		.f1_i(f1_i),
		.f2_r(f2_r),
		.f2_i(f2_i),
		.f3_r(f3_r),
		.f3_i(f3_i));

	fft_4p_unit_ctl controller (
		.clk(clk),
		.rst_n(rst_n),
		.enable(enable),
		.ld0(ld0),
		.ld1(ld1),
		.ld2(ld2),
		.by_pass(by_pass));

	// Load data into registers
	always @(posedge clk) begin
		if (rst_n == 0) begin
			data_0_r <= 15'b0;
			data_0_i <= 15'b0;
			data_1_r <= 15'b0;
			data_1_i <= 15'b0;
			data_2_r <= 15'b0;
			data_2_i <= 15'b0;
		end
		else if (enable) begin
			// Load regist 0
			if (ld0 == 1) begin
				if (by_pass == 1) begin
					data_0_r <= data_in_r;
					data_0_i <= data_in_i;
				end
				else begin
					data_0_r <= f1_r;
					data_0_i <= f1_i;
				end
			end
			// Load register 1
			if (ld1 == 1) begin
				if (by_pass == 1) begin
					data_1_r <= data_in_r;
					data_1_i <= data_in_i;
				end
				else begin
					data_1_r <= f2_r;
					data_1_i <= f2_i;
				end
			end
			// Load register 2
			if (ld2 == 1) begin
				if (by_pass == 1) begin
					data_2_r <= data_in_r;
					data_2_i <= data_in_i; 
				end
				else begin
					data_2_r <= f3_r;
					data_2_i <= f3_i;
				end
			end
		end
	end
	// Assign output data
	always @(by_pass or ld0 or ld1 or ld2 or data_0_r or data_0_i or data_1_r or data_1_i or data_2_r or data_2_i or f0_r or f0_i) begin
		if (by_pass == 1) begin
			if (ld0 == 1) begin
				data_out_r <= data_0_r;
				data_out_i <= data_0_i;
			end
			else if (ld1 == 1) begin
				data_out_r <= data_1_r;
				data_out_i <= data_1_i;
			end
			else if (ld2 == 1) begin
				data_out_r <= data_2_r;
				data_out_i <= data_2_i;
			end
		end
		else begin
			data_out_r <= f0_r;
			data_out_i <= f0_i;
		end
	end
endmodule
