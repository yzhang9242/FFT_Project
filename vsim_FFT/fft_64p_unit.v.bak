module SR_16 (clk, rst_n, en, data_in, data_out);
	input clk;
	input rst_n;
	input en;
	input signed [15 : 0] data_in;
	output signed [15 : 0] data_out;

	wire signed [15 : 0] data_wire[16 : 0];
	
	assign data_wire[0] = data_in;
	genvar i;
	generate 
		for (i = 0; i < 16; i = i + 1) begin : shift_reg
			reg_16 sr(
				.clk(clk),
				.rst_n(rst_n),
				.en(en),
				.data_in(data_wire[i]),
				.data_out(data_wire[i + 1]));
		end
	endgenerate
	assign data_out = data_wire[16];
endmodule

// FSM controller for 64 point fft
module fft_64p_unit_ctl (clk, rst_n, enable, by_pass, ld0, ld1, ld2);
	input clk;
	input rst_n;
	input enable;

	output reg by_pass, ld0, ld1, ld2;
	
	reg [5 : 0] state;
	
	always @(posedge clk) begin
		if (rst_n == 0) begin
			state <= 0;
		end
		else if (enable) begin
			if (state == 63) state <= 0;
			else state <= state + 1;
		end
	end
	
	always @(state) begin
		if (state[5] == 0 && state[4] == 0) begin
			by_pass <= 1;
			ld0 <= 1;
			ld1 <= 0;
			ld2 <= 0;
		end
		else if (state[5] == 0 && state[4] == 1) begin
			by_pass <= 1;
			ld0 <= 0;
			ld1 <= 1;
			ld2 <= 0;
		end
		else if (state[5] == 1 && state[4] == 0) begin
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

module fft_64p_unit (clk, rst_n, enable, data_in_r, data_in_i, data_out_r, data_out_i);
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
	
	// Data wires
	wire signed [15 : 0] data_0_r_en;
	wire signed [15 : 0] data_0_r_de;
	wire signed [15 : 0] data_0_i_en;
	wire signed [15 : 0] data_0_i_de;
	wire signed [15 : 0] data_1_r_en;
	wire signed [15 : 0] data_1_r_de;
	wire signed [15 : 0] data_1_i_en;
	wire signed [15 : 0] data_1_i_de;
	wire signed [15 : 0] data_2_r_en;
	wire signed [15 : 0] data_2_r_de;
	wire signed [15 : 0] data_2_i_en;
	wire signed [15 : 0] data_2_i_de;
	
	// Data registers
	SR_16 data_0_r (clk, rst_n, ld0, data_0_r_en, data_0_r_de);
	SR_16 data_0_i (clk, rst_n, ld0, data_0_i_en, data_0_i_de);
	SR_16 data_1_r (clk, rst_n, ld1, data_1_r_en, data_1_r_de);
	SR_16 data_1_i (clk, rst_n, ld1, data_1_i_en, data_1_i_de);
	SR_16 data_2_r (clk, rst_n, ld2, data_2_r_en, data_2_r_de);
	SR_16 data_2_i (clk, rst_n, ld2, data_2_i_en, data_2_i_de);
	
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
		.x0_r(data_0_r_de),
		.x0_i(data_0_i_de),
		.x1_r(data_1_r_de),
		.x1_i(data_1_i_de),
		.x2_r(data_2_r_de),
		.x2_i(data_2_i_de),
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

	fft_64p_unit_ctl controller (
		.clk(clk),
		.rst_n(rst_n),
		.enable(enable),
		.ld0(ld0),
		.ld1(ld1),
		.ld2(ld2),
		.by_pass(by_pass));

	// Select data load to registers
	assign data_0_r_en = by_pass ? data_in_r : f1_r;
	assign data_0_i_en = by_pass ? data_in_i : f1_i;
	assign data_1_r_en = by_pass ? data_in_r : f2_r;
	assign data_1_i_en = by_pass ? data_in_i : f2_i;
	assign data_2_r_en = by_pass ? data_in_r : f3_r;
	assign data_2_i_en = by_pass ? data_in_i : f3_i;

	// Assign output data
	always @(by_pass or ld0 or ld1 or ld2 or data_0_r_de or data_0_i_de or data_1_r_de or data_1_i_de or data_2_r_de or data_2_i_de or f0_r or f0_i) begin
		if (by_pass == 1) begin
			if (ld0 == 1) begin
				data_out_r <= data_0_r_de;
				data_out_i <= data_0_i_de;
			end
			else if (ld1 == 1) begin
				data_out_r <= data_1_r_de;
				data_out_i <= data_1_i_de;
			end
			else if (ld2 == 1) begin
				data_out_r <= data_2_r_de;
				data_out_i <= data_2_i_de;
			end
		end
		else begin
			data_out_r <= f0_r;
			data_out_i <= f0_i;
		end
	end
endmodule

// Controller for 64point fft to generate rotate angles
module fft_64pt_rotate_ctl (clk, rst_n, enable, phase_out, pls90_out, min90_out);
	input clk;
	input rst_n;
	input enable;
	output signed [15 : 0] phase_out;
	output pls90_out;
	output min90_out;
	
	reg [5 : 0] state;
	reg signed [15 : 0] phase;
	reg pls90;
	reg min90;

	always @(posedge clk) begin
		if (rst_n == 0)
			state <= 0;
		else if (enable) begin
			if (state == 63)
				state <= 0;
			else
				state <= state + 1;
		end
	end

	always @(state) begin
		case (state)
			48 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			49 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			50 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			51 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			52 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			53 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			54 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			55 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			56 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			57 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			58 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			59 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			60 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			61 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			62 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			63 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			0 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			1 : begin pls90 <= 0; min90 <= 0; phase <= -1440; end
			2 : begin pls90 <= 0; min90 <= 0; phase <= -2880; end
			3 : begin pls90 <= 0; min90 <= 0; phase <= -4320; end
			4 : begin pls90 <= 0; min90 <= 0; phase <= -5760; end
			5 : begin pls90 <= 0; min90 <= 0; phase <= -7200; end
			6 : begin pls90 <= 0; min90 <= 0; phase <= -8640; end
			7 : begin pls90 <= 0; min90 <= 0; phase <= -10080; end
			8 : begin pls90 <= 0; min90 <= 0; phase <= -11520; end
			9 : begin pls90 <= 0; min90 <= 0; phase <= -12960; end
			10 : begin pls90 <= 0; min90 <= 0; phase <= -14400; end
			11 : begin pls90 <= 0; min90 <= 0; phase <= -15840; end
			12 : begin pls90 <= 0; min90 <= 0; phase <= -17280; end
			13 : begin pls90 <= 0; min90 <= 0; phase <= -18720; end
			14 : begin pls90 <= 0; min90 <= 0; phase <= -20160; end
			15 : begin pls90 <= 0; min90 <= 0; phase <= -21600; end
			16 : begin pls90 <= 0; min90 <= 0; phase <= -0; end
			17 : begin pls90 <= 0; min90 <= 0; phase <= -2880; end
			18 : begin pls90 <= 0; min90 <= 0; phase <= -5760; end
			19 : begin pls90 <= 0; min90 <= 0; phase <= -8640; end
			20 : begin pls90 <= 0; min90 <= 0; phase <= -11520; end
			21 : begin pls90 <= 0; min90 <= 0; phase <= -14400; end
			22 : begin pls90 <= 0; min90 <= 0; phase <= -17280; end
			23 : begin pls90 <= 0; min90 <= 0; phase <= -20160; end
			24 : begin pls90 <= 0; min90 <= 0; phase <= -23040; end
			25 : begin pls90 <= 0; min90 <= 1; phase <= -2880; end
			26 : begin pls90 <= 0; min90 <= 1; phase <= -5760; end
			27 : begin pls90 <= 0; min90 <= 1; phase <= -8640; end
			28 : begin pls90 <= 0; min90 <= 1; phase <= -11520; end
			29 : begin pls90 <= 0; min90 <= 1; phase <= -14400; end
			30 : begin pls90 <= 0; min90 <= 1; phase <= -17280; end
			31 : begin pls90 <= 0; min90 <= 1; phase <= -20160; end
			32 : begin pls90 <= 0; min90 <= 0; phase <= -0; end
			33 : begin pls90 <= 0; min90 <= 0; phase <= -4320; end
			34 : begin pls90 <= 0; min90 <= 0; phase <= -8640; end
			35 : begin pls90 <= 0; min90 <= 0; phase <= -12960; end
			36 : begin pls90 <= 0; min90 <= 0; phase <= -17280; end
			37 : begin pls90 <= 0; min90 <= 0; phase <= -21600; end
			38 : begin pls90 <= 0; min90 <= 1; phase <= -2880; end
			39 : begin pls90 <= 0; min90 <= 1; phase <= -7200; end
			40 : begin pls90 <= 0; min90 <= 1; phase <= -11520; end
			41 : begin pls90 <= 0; min90 <= 1; phase <= -15840; end
			42 : begin pls90 <= 0; min90 <= 1; phase <= -20160; end
			43 : begin pls90 <= 1; min90 <= 0; phase <= 21600; end
			44 : begin pls90 <= 1; min90 <= 0; phase <= 17280; end
			45 : begin pls90 <= 1; min90 <= 0; phase <= 12960; end
			46 : begin pls90 <= 1; min90 <= 0; phase <= 8640; end
			47 : begin pls90 <= 1; min90 <= 0; phase <= 4320; end
		endcase
	end

	// Assign output signals
	assign phase_out = phase;
	assign pls90_out = pls90;
	assign min90_out = min90;
endmodule

// fft 64 point stage module
module fft_64pt_stage (clk, rst_n, enable, data_r_in, data_i_in, data_r_out, data_i_out);
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

	// Data from 64pt butterfly
	wire signed [15 : 0] data_r_64;
	wire signed [15 : 0] data_i_64;

	fft_64p_unit fft_64pt_stage_bf (
				.clk(clk),
				.rst_n(rst_n),
				.enable(enable),
				.data_in_r(data_r_in),
				.data_in_i(data_i_in),
				.data_out_r(real_imd),
				.data_out_i(img_imd));

	fft_64pt_rotate_ctl rotate_64pt_stage_ctl(
				.clk(clk),
				.rst_n(rst_n),
				.enable(enable),
				.phase_out(phase_imd),
				.pls90_out(pls90_imd),
				.min90_out(min90_imd));

	// Connections are based on pls90 and min90
	always @(posedge clk or rst_n) begin
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
	
	cordic_nppl cordic_64pt_stage (
				.real_in(real_part),
				.img_in(img_part),
				.z_in(phase),
				.real_out(data_r_out),
				.img_out(data_i_out));

endmodule
