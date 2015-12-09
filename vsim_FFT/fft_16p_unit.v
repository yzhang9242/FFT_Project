// FSM controller for 16 point fft
module fft_16p_unit_ctl (clk, rst_n, enable, by_pass, ld0, ld1, ld2);
	input clk;
	input rst_n;
	input enable;
	output reg by_pass, ld0, ld1, ld2;
	
	reg [3 : 0] state;
	
	always @(posedge clk) begin
		if (rst_n == 0) begin
			state <= 0;
		end
		else if (enable) begin
			if (state == 15) state <= 0;
			else state <= state + 1;
		end
	end
	
	always @(state) begin
		case (state)
			0 : begin
				by_pass <= 1;
				ld0 <= 1;
				ld1 <= 0;
				ld2 <= 0;
			end
			1 : begin
				by_pass <= 1;
				ld0 <= 1;
				ld1 <= 0;
				ld2 <= 0;
			end
			2 : begin
				by_pass <= 1;
				ld0 <= 1;
				ld1 <= 0;
				ld2 <= 0;
			end
			3 : begin
				by_pass <= 1;
				ld0 <= 1;
				ld1 <= 0;
				ld2 <= 0;
			end
			4 : begin
				by_pass <= 1;
				ld0 <= 0;
				ld1 <= 1;
				ld2 <= 0;
			end
			5 : begin
				by_pass <= 1;
				ld0 <= 0;
				ld1 <= 1;
				ld2 <= 0;
			end
			6 : begin
				by_pass <= 1;
				ld0 <= 0;
				ld1 <= 1;
				ld2 <= 0;
			end
			7 : begin
				by_pass <= 1;
				ld0 <= 0;
				ld1 <= 1;
				ld2 <= 0;
			end
			8 : begin
				by_pass <= 1;
				ld0 <= 0;
				ld1 <= 0;
				ld2 <= 1;
			end
			9 : begin
				by_pass <= 1;
				ld0 <= 0;
				ld1 <= 0;
				ld2 <= 1;
			end
			10 : begin
				by_pass <= 1;
				ld0 <= 0;
				ld1 <= 0;
				ld2 <= 1;
			end
			11 : begin
				by_pass <= 1;
				ld0 <= 0;
				ld1 <= 0;
				ld2 <= 1;
			end
			12 : begin
				by_pass <= 0;
				ld0 <= 1;
				ld1 <= 1;
				ld2 <= 1;
			end
			13 : begin
				by_pass <= 0;
				ld0 <= 1;
				ld1 <= 1;
				ld2 <= 1;
			end
			14 : begin
				by_pass <= 0;
				ld0 <= 1;
				ld1 <= 1;
				ld2 <= 1;
			end
			15 : begin
				by_pass <= 0;
				ld0 <= 1;
				ld1 <= 1;
				ld2 <= 1;
			end
			default : begin
				by_pass <= 0;
				ld0 <= 0;
				ld1 <= 0;
				ld2 <= 0;
			end
		endcase
	end
endmodule

module fft_16p_unit (clk, rst_n, enable, data_in_r, data_in_i, data_out_r, data_out_i);
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
	reg signed [15 : 0] data_0_r [3 : 0];
	reg signed [15 : 0] data_0_i [3 : 0];
	reg signed [15 : 0] data_1_r [3 : 0];
	reg signed [15 : 0] data_1_i [3 : 0];
	reg signed [15 : 0] data_2_r [3 : 0];
	reg signed [15 : 0] data_2_i [3 : 0];
	
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
		.x0_r(data_0_r[3]),
		.x0_i(data_0_i[3]),
		.x1_r(data_1_r[3]),
		.x1_i(data_1_i[3]),
		.x2_r(data_2_r[3]),
		.x2_i(data_2_i[3]),
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

	fft_16p_unit_ctl controller (
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
			data_0_r[0] <= '0;
			data_0_i[0] <= '0;
			data_1_r[0] <= '0;
			data_1_i[0] <= '0;
			data_2_r[0] <= '0;
			data_2_i[0] <= '0;
		end
		else begin
			// Load regist 0
			if (ld0 == 1) begin
				data_0_r[3] <= data_0_r[2];
				data_0_i[3] <= data_0_i[2];
				data_0_r[2] <= data_0_r[1];
				data_0_i[2] <= data_0_i[1];
				data_0_r[1] <= data_0_r[0];
				data_0_i[1] <= data_0_i[0];
				if (by_pass == 1) begin
					data_0_r[0] <= data_in_r;
					data_0_i[0] <= data_in_i;
				end
				else begin
					data_0_r[0] <= f1_r;
					data_0_i[0] <= f1_i;
				end
			end
			// Load register 1
			if (ld1 == 1) begin
				data_1_r[3] <= data_1_r[2];
				data_1_i[3] <= data_1_i[2];
				data_1_r[2] <= data_1_r[1];
				data_1_i[2] <= data_1_i[1];
				data_1_r[1] <= data_1_r[0];
				data_1_i[1] <= data_1_i[0];
				if (by_pass == 1) begin
					data_1_r[0] <= data_in_r;
					data_1_i[0] <= data_in_i;
				end
				else begin
					data_1_r[0] <= f2_r;
					data_1_i[0] <= f2_i;
				end
			end
			// Load register 2
			if (ld2 == 1) begin
				data_2_r[3] <= data_2_r[2];
				data_2_i[3] <= data_2_i[2];
				data_2_r[2] <= data_2_r[1];
				data_2_i[2] <= data_2_i[1];
				data_2_r[1] <= data_2_r[0];
				data_2_i[1] <= data_2_i[0];
				if (by_pass == 1) begin
					data_2_r[0] <= data_in_r;
					data_2_i[0] <= data_in_i; 
				end
				else begin
					data_2_r[0] <= f3_r;
					data_2_i[0] <= f3_i;
				end
			end
		end
	end
	// Assign output data
	always @(by_pass or ld0 or ld1 or ld2 or data_0_r[3] or data_0_i[3] or data_1_r[3] or data_1_i[3] or data_2_r[3] or data_2_i[3] or f0_r or f0_i) begin
		if (by_pass == 1) begin
			if (ld0 == 1) begin
				data_out_r <= data_0_r[3];
				data_out_i <= data_0_i[3];
			end
			else if (ld1 == 1) begin
				data_out_r <= data_1_r[3];
				data_out_i <= data_1_i[3];
			end
			else if (ld2 == 1) begin
				data_out_r <= data_2_r[3];
				data_out_i <= data_2_i[3];
			end
		end
		else begin
			data_out_r <= f0_r;
			data_out_i <= f0_i;
		end
	end
endmodule

// Controller for 16point fft to generate rotate angles
module fft_16pt_rotate_ctl (clk, rst_n, enable, phase_out, pls90_out, min90_out);
	input clk;
	input rst_n;
	input enable;
	output signed [15 : 0] phase_out;
	output pls90_out;
	output min90_out;
	
	reg [3 : 0] state;
	reg signed [15 : 0] phase;
	reg pls90;
	reg min90;

	always @(posedge clk) begin
		if (rst_n == 0)
			state <= 0;
		else if (enable) begin
			if (state == 15)
				state <= 0;
			else
				state <= state + 1;
		end
	end

	always @(state) begin
		if (state == 0 || state == 4 || state == 8 || state == 12 || state == 13 || state == 14 || state == 15) begin
			pls90 <= 0;
			min90 <= 0;
			phase <= 0;
		end
		if (state == 1) begin
			pls90 <= 0;
			min90 <= 0;
			phase <= -5760;
		end
		if (state == 2 || state == 5) begin
			pls90 <= 0;
			min90 <= 0;
			phase <= -11520;
		end
		if (state == 3 || state == 9) begin
			pls90 <= 0;
			min90 <= 0;
			phase <= -17280;
		end
		if (state == 6) begin
			pls90 <= 0;
			min90 <= 1;
			phase <= 0;
		end
		if (state == 10 || state == 7) begin
			pls90 <= 0;
			min90 <= 1;
			phase <= -11520;
		end
		if (state == 11) begin
			pls90 <= 1;
			min90 <= 0;
			phase <= 17280;
		end
	end

	// Assign output signals
	assign phase_out = phase;
	assign pls90_out = pls90;
	assign min90_out = min90;
endmodule

// fft 16 point stage module
module fft_16pt_stage (clk, rst_n, enable, data_r_in, data_i_in, data_r_out, data_i_out);
	input clk;
	input rst_n;
	input enable;

	input signed [15 : 0] data_r_in;
	input signed [15 : 0] data_i_in;
	output signed [15 : 0] data_r_out;
	output signed [15 : 0] data_i_out;


	// Data from butterfly unit
	wire signed [15 : 0] real_imd;
	wire signed [15 : 0] img_imd;
	wire signed [15 : 0] phase_imd;
	wire pls90_imd;
	wire min90_imd;

	// Input data for rotater
	reg signed [15 : 0] real_part;
	reg signed [15 : 0] img_part;
	reg signed [15 : 0] phase;

	// Data from 16pt stage
	wire signed [15 : 0] data_r_16;
	wire signed [15 : 0] data_i_16;

	fft_16p_unit fft_16pt_stage_bf (
				.clk(clk),
				.rst_n(rst_n),
				.enable(enable),
				.data_in_r(data_r_in),
				.data_in_i(data_i_in),
				.data_out_r(real_imd),
				.data_out_i(img_imd));

	fft_16pt_rotate_ctl rotate_16pt_stage_ctl(
				.clk(clk),
				.rst_n(rst_n),
				.enable(enable),
				.phase_out(phase_imd),
				.pls90_out(pls90_imd),
				.min90_out(min90_imd));

	// Connections are based on pls90 and min90
	always @(posedge clk) begin
		if (rst_n == 0) begin
			real_part <= 0;
			img_part <= 0;
			phase <= 0;
		end
		else begin
			phase <= phase_imd;
			if (pls90_imd == 0 && min90_imd == 0) begin
				real_part <= real_imd;
				img_part <= img_imd;
			end
			if (pls90_imd == 1) begin
				real_part <= -img_imd;
				img_part <= real_imd;
			end
			if (min90_imd == 1) begin
				real_part <= img_imd;
				img_part <= -real_imd;
			end
		end
	end
	
	cordic_nppl cordic_16pt_stage (
				.real_in(real_part),
				.img_in(img_part),
				.z_in(phase),
				.real_out(data_r_out),
				.img_out(data_i_out));

endmodule
