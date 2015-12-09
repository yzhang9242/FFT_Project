
module SR_64 (clk, rst_n, en, data_in, data_out);
	input clk;
	input rst_n;
	input en;
	input signed [15 : 0] data_in;
	output signed [15 : 0] data_out;

	wire signed [15 : 0] data_wire[64 : 0];
	
	assign data_wire[0] = data_in;
	genvar i;
	generate 
		for (i = 0; i < 64; i = i + 1) begin : shift_reg
			reg_16 sr(
				.clk(clk),
				.rst_n(rst_n),
				.en(en),
				.data_in(data_wire[i]),
				.data_out(data_wire[i + 1]));
		end
	endgenerate
	assign data_out = data_wire[64];
endmodule

// FSM controller for 256 point fft
module fft_256p_unit_ctl (clk, rst_n, enable, by_pass, ld0, ld1, ld2);
	input clk;
	input rst_n;
	input enable;

	output reg by_pass, ld0, ld1, ld2;
	
	reg [7 : 0] state;
	
	always @(posedge clk) begin
		if (rst_n == 0) begin
			state <= 0;
		end
		else if (enable) begin
			if (state == 255) state <= 0;
			else state <= state + 1;
		end
	end
	
	always @(state) begin
		if (state[7] == 0 && state[6] == 0) begin
			by_pass <= 1;
			ld0 <= 1;
			ld1 <= 0;
			ld2 <= 0;
		end
		else if (state[7] == 0 && state[6] == 1) begin
			by_pass <= 1;
			ld0 <= 0;
			ld1 <= 1;
			ld2 <= 0;
		end
		else if (state[7] == 1 && state[6] == 0) begin
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

module fft_256p_unit (clk, rst_n, enable, data_in_r, data_in_i, data_out_r, data_out_i);
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
	SR_64 data_0_r (clk, rst_n, ld0, data_0_r_en, data_0_r_de);
	SR_64 data_0_i (clk, rst_n, ld0, data_0_i_en, data_0_i_de);
	SR_64 data_1_r (clk, rst_n, ld1, data_1_r_en, data_1_r_de);
	SR_64 data_1_i (clk, rst_n, ld1, data_1_i_en, data_1_i_de);
	SR_64 data_2_r (clk, rst_n, ld2, data_2_r_en, data_2_r_de);
	SR_64 data_2_i (clk, rst_n, ld2, data_2_i_en, data_2_i_de);
	
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

	fft_256p_unit_ctl controller (
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

// Controller for 256point fft to generate rotate angles
module fft_256pt_rotate_ctl (clk, rst_n, enable, phase_out, pls90_out, min90_out);
	input clk;
	input rst_n;
	input enable;
	output signed [15 : 0] phase_out;
	output pls90_out;
	output min90_out;
	
	reg [7 : 0] state;
	reg signed [15 : 0] phase;
	reg pls90;
	reg min90;

	always @(posedge clk) begin
		if (rst_n == 0)
			state <= 0;
		else if (enable) begin
			if (state == 255)
				state <= 0;
			else
				state <= state + 1;
		end
	end

	always @(state) begin
		case (state)
			192 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			193 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			194 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			195 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			196 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			197 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			198 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			199 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			200 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			201 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			202 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			203 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			204 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			205 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			206 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			207 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			208 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			209 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			210 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			211 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			212 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			213 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			214 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			215 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			216 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			217 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			218 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			219 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			220 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			221 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			222 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			223 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			224 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			225 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			226 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			227 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			228 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			229 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			230 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			231 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			232 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			233 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			234 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			235 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			236 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			237 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			238 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			239 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			240 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			241 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			242 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			243 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			244 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			245 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			246 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			247 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			248 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			249 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			250 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			251 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			252 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			253 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			254 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			255 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			0 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			1 : begin pls90 <= 0; min90 <= 0; phase <= -360; end
			2 : begin pls90 <= 0; min90 <= 0; phase <= -720; end
			3 : begin pls90 <= 0; min90 <= 0; phase <= -1080; end
			4 : begin pls90 <= 0; min90 <= 0; phase <= -1440; end
			5 : begin pls90 <= 0; min90 <= 0; phase <= -1800; end
			6 : begin pls90 <= 0; min90 <= 0; phase <= -2160; end
			7 : begin pls90 <= 0; min90 <= 0; phase <= -2520; end
			8 : begin pls90 <= 0; min90 <= 0; phase <= -2880; end
			9 : begin pls90 <= 0; min90 <= 0; phase <= -3240; end
			10 : begin pls90 <= 0; min90 <= 0; phase <= -3600; end
			11 : begin pls90 <= 0; min90 <= 0; phase <= -3960; end
			12 : begin pls90 <= 0; min90 <= 0; phase <= -4320; end
			13 : begin pls90 <= 0; min90 <= 0; phase <= -4680; end
			14 : begin pls90 <= 0; min90 <= 0; phase <= -5040; end
			15 : begin pls90 <= 0; min90 <= 0; phase <= -5400; end
			16 : begin pls90 <= 0; min90 <= 0; phase <= -5760; end
			17 : begin pls90 <= 0; min90 <= 0; phase <= -6120; end
			18 : begin pls90 <= 0; min90 <= 0; phase <= -6480; end
			19 : begin pls90 <= 0; min90 <= 0; phase <= -6840; end
			20 : begin pls90 <= 0; min90 <= 0; phase <= -7200; end
			21 : begin pls90 <= 0; min90 <= 0; phase <= -7560; end
			22 : begin pls90 <= 0; min90 <= 0; phase <= -7920; end
			23 : begin pls90 <= 0; min90 <= 0; phase <= -8280; end
			24 : begin pls90 <= 0; min90 <= 0; phase <= -8640; end
			25 : begin pls90 <= 0; min90 <= 0; phase <= -9000; end
			26 : begin pls90 <= 0; min90 <= 0; phase <= -9360; end
			27 : begin pls90 <= 0; min90 <= 0; phase <= -9720; end
			28 : begin pls90 <= 0; min90 <= 0; phase <= -10080; end
			29 : begin pls90 <= 0; min90 <= 0; phase <= -10440; end
			30 : begin pls90 <= 0; min90 <= 0; phase <= -10800; end
			31 : begin pls90 <= 0; min90 <= 0; phase <= -11160; end
			32 : begin pls90 <= 0; min90 <= 0; phase <= -11520; end
			33 : begin pls90 <= 0; min90 <= 0; phase <= -11880; end
			34 : begin pls90 <= 0; min90 <= 0; phase <= -12240; end
			35 : begin pls90 <= 0; min90 <= 0; phase <= -12600; end
			36 : begin pls90 <= 0; min90 <= 0; phase <= -12960; end
			37 : begin pls90 <= 0; min90 <= 0; phase <= -13320; end
			38 : begin pls90 <= 0; min90 <= 0; phase <= -13680; end
			39 : begin pls90 <= 0; min90 <= 0; phase <= -14040; end
			40 : begin pls90 <= 0; min90 <= 0; phase <= -14400; end
			41 : begin pls90 <= 0; min90 <= 0; phase <= -14760; end
			42 : begin pls90 <= 0; min90 <= 0; phase <= -15120; end
			43 : begin pls90 <= 0; min90 <= 0; phase <= -15480; end
			44 : begin pls90 <= 0; min90 <= 0; phase <= -15840; end
			45 : begin pls90 <= 0; min90 <= 0; phase <= -16200; end
			46 : begin pls90 <= 0; min90 <= 0; phase <= -16560; end
			47 : begin pls90 <= 0; min90 <= 0; phase <= -16920; end
			48 : begin pls90 <= 0; min90 <= 0; phase <= -17280; end
			49 : begin pls90 <= 0; min90 <= 0; phase <= -17640; end
			50 : begin pls90 <= 0; min90 <= 0; phase <= -18000; end
			51 : begin pls90 <= 0; min90 <= 0; phase <= -18360; end
			52 : begin pls90 <= 0; min90 <= 0; phase <= -18720; end
			53 : begin pls90 <= 0; min90 <= 0; phase <= -19080; end
			54 : begin pls90 <= 0; min90 <= 0; phase <= -19440; end
			55 : begin pls90 <= 0; min90 <= 0; phase <= -19800; end
			56 : begin pls90 <= 0; min90 <= 0; phase <= -20160; end
			57 : begin pls90 <= 0; min90 <= 0; phase <= -20520; end
			58 : begin pls90 <= 0; min90 <= 0; phase <= -20880; end
			59 : begin pls90 <= 0; min90 <= 0; phase <= -21240; end
			60 : begin pls90 <= 0; min90 <= 0; phase <= -21600; end
			61 : begin pls90 <= 0; min90 <= 0; phase <= -21960; end
			62 : begin pls90 <= 0; min90 <= 0; phase <= -22320; end
			63 : begin pls90 <= 0; min90 <= 0; phase <= -22680; end
			64 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			65 : begin pls90 <= 0; min90 <= 0; phase <= -720; end
			66 : begin pls90 <= 0; min90 <= 0; phase <= -1440; end
			67 : begin pls90 <= 0; min90 <= 0; phase <= -2160; end
			68 : begin pls90 <= 0; min90 <= 0; phase <= -2880; end
			69 : begin pls90 <= 0; min90 <= 0; phase <= -3600; end
			70 : begin pls90 <= 0; min90 <= 0; phase <= -4320; end
			71 : begin pls90 <= 0; min90 <= 0; phase <= -5040; end
			72 : begin pls90 <= 0; min90 <= 0; phase <= -5760; end
			73 : begin pls90 <= 0; min90 <= 0; phase <= -6480; end
			74 : begin pls90 <= 0; min90 <= 0; phase <= -7200; end
			75 : begin pls90 <= 0; min90 <= 0; phase <= -7920; end
			76 : begin pls90 <= 0; min90 <= 0; phase <= -8640; end
			77 : begin pls90 <= 0; min90 <= 0; phase <= -9360; end
			78 : begin pls90 <= 0; min90 <= 0; phase <= -10080; end
			79 : begin pls90 <= 0; min90 <= 0; phase <= -10800; end
			80 : begin pls90 <= 0; min90 <= 0; phase <= -11520; end
			81 : begin pls90 <= 0; min90 <= 0; phase <= -12240; end
			82 : begin pls90 <= 0; min90 <= 0; phase <= -12960; end
			83 : begin pls90 <= 0; min90 <= 0; phase <= -13680; end
			84 : begin pls90 <= 0; min90 <= 0; phase <= -14400; end
			85 : begin pls90 <= 0; min90 <= 0; phase <= -15120; end
			86 : begin pls90 <= 0; min90 <= 0; phase <= -15840; end
			87 : begin pls90 <= 0; min90 <= 0; phase <= -16560; end
			88 : begin pls90 <= 0; min90 <= 0; phase <= -17280; end
			89 : begin pls90 <= 0; min90 <= 0; phase <= -18000; end
			90 : begin pls90 <= 0; min90 <= 0; phase <= -18720; end
			91 : begin pls90 <= 0; min90 <= 0; phase <= -19440; end
			92 : begin pls90 <= 0; min90 <= 0; phase <= -20160; end
			93 : begin pls90 <= 0; min90 <= 0; phase <= -20880; end
			94 : begin pls90 <= 0; min90 <= 0; phase <= -21600; end
			95 : begin pls90 <= 0; min90 <= 0; phase <= -22320; end
			96 : begin pls90 <= 0; min90 <= 0; phase <= -23040; end
			97 : begin pls90 <= 0; min90 <= 1; phase <= -720; end
			98 : begin pls90 <= 0; min90 <= 1; phase <= -1440; end
			99 : begin pls90 <= 0; min90 <= 1; phase <= -2160; end
			100 : begin pls90 <= 0; min90 <= 1; phase <= -2880; end
			101 : begin pls90 <= 0; min90 <= 1; phase <= -3600; end
			102 : begin pls90 <= 0; min90 <= 1; phase <= -4320; end
			103 : begin pls90 <= 0; min90 <= 1; phase <= -5040; end
			104 : begin pls90 <= 0; min90 <= 1; phase <= -5760; end
			105 : begin pls90 <= 0; min90 <= 1; phase <= -6480; end
			106 : begin pls90 <= 0; min90 <= 1; phase <= -7200; end
			107 : begin pls90 <= 0; min90 <= 1; phase <= -7920; end
			108 : begin pls90 <= 0; min90 <= 1; phase <= -8640; end
			109 : begin pls90 <= 0; min90 <= 1; phase <= -9360; end
			110 : begin pls90 <= 0; min90 <= 1; phase <= -10080; end
			111 : begin pls90 <= 0; min90 <= 1; phase <= -10800; end
			112 : begin pls90 <= 0; min90 <= 1; phase <= -11520; end
			113 : begin pls90 <= 0; min90 <= 1; phase <= -12240; end
			114 : begin pls90 <= 0; min90 <= 1; phase <= -12960; end
			115 : begin pls90 <= 0; min90 <= 1; phase <= -13680; end
			116 : begin pls90 <= 0; min90 <= 1; phase <= -14400; end
			117 : begin pls90 <= 0; min90 <= 1; phase <= -15120; end
			118 : begin pls90 <= 0; min90 <= 1; phase <= -15840; end
			119 : begin pls90 <= 0; min90 <= 1; phase <= -16560; end
			120 : begin pls90 <= 0; min90 <= 1; phase <= -17280; end
			121 : begin pls90 <= 0; min90 <= 1; phase <= -18000; end
			122 : begin pls90 <= 0; min90 <= 1; phase <= -18720; end
			123 : begin pls90 <= 0; min90 <= 1; phase <= -19440; end
			124 : begin pls90 <= 0; min90 <= 1; phase <= -20160; end
			125 : begin pls90 <= 0; min90 <= 1; phase <= -20880; end
			126 : begin pls90 <= 0; min90 <= 1; phase <= -21600; end
			127 : begin pls90 <= 0; min90 <= 1; phase <= -22320; end
			128 : begin pls90 <= 0; min90 <= 0; phase <= 0; end
			129 : begin pls90 <= 0; min90 <= 0; phase <= -1080; end
			130 : begin pls90 <= 0; min90 <= 0; phase <= -2160; end
			131 : begin pls90 <= 0; min90 <= 0; phase <= -3240; end
			132 : begin pls90 <= 0; min90 <= 0; phase <= -4320; end
			133 : begin pls90 <= 0; min90 <= 0; phase <= -5400; end
			134 : begin pls90 <= 0; min90 <= 0; phase <= -6480; end
			135 : begin pls90 <= 0; min90 <= 0; phase <= -7560; end
			136 : begin pls90 <= 0; min90 <= 0; phase <= -8640; end
			137 : begin pls90 <= 0; min90 <= 0; phase <= -9720; end
			138 : begin pls90 <= 0; min90 <= 0; phase <= -10800; end
			139 : begin pls90 <= 0; min90 <= 0; phase <= -11880; end
			140 : begin pls90 <= 0; min90 <= 0; phase <= -12960; end
			141 : begin pls90 <= 0; min90 <= 0; phase <= -14040; end
			142 : begin pls90 <= 0; min90 <= 0; phase <= -15120; end
			143 : begin pls90 <= 0; min90 <= 0; phase <= -16200; end
			144 : begin pls90 <= 0; min90 <= 0; phase <= -17280; end
			145 : begin pls90 <= 0; min90 <= 0; phase <= -18360; end
			146 : begin pls90 <= 0; min90 <= 0; phase <= -19440; end
			147 : begin pls90 <= 0; min90 <= 0; phase <= -20520; end
			148 : begin pls90 <= 0; min90 <= 0; phase <= -21600; end
			149 : begin pls90 <= 0; min90 <= 0; phase <= -22680; end
			150 : begin pls90 <= 0; min90 <= 1; phase <= -720; end
			151 : begin pls90 <= 0; min90 <= 1; phase <= -1800; end
			152 : begin pls90 <= 0; min90 <= 1; phase <= -2880; end
			153 : begin pls90 <= 0; min90 <= 1; phase <= -3960; end
			154 : begin pls90 <= 0; min90 <= 1; phase <= -5040; end
			155 : begin pls90 <= 0; min90 <= 1; phase <= -6120; end
			156 : begin pls90 <= 0; min90 <= 1; phase <= -7200; end
			157 : begin pls90 <= 0; min90 <= 1; phase <= -8280; end
			158 : begin pls90 <= 0; min90 <= 1; phase <= -9360; end
			159 : begin pls90 <= 0; min90 <= 1; phase <= -10440; end
			160 : begin pls90 <= 0; min90 <= 1; phase <= -11520; end
			161 : begin pls90 <= 0; min90 <= 1; phase <= -12600; end
			162 : begin pls90 <= 0; min90 <= 1; phase <= -13680; end
			163 : begin pls90 <= 0; min90 <= 1; phase <= -14760; end
			164 : begin pls90 <= 0; min90 <= 1; phase <= -15840; end
			165 : begin pls90 <= 0; min90 <= 1; phase <= -16920; end
			166 : begin pls90 <= 0; min90 <= 1; phase <= -18000; end
			167 : begin pls90 <= 0; min90 <= 1; phase <= -19080; end
			168 : begin pls90 <= 0; min90 <= 1; phase <= -20160; end
			169 : begin pls90 <= 0; min90 <= 1; phase <= -21240; end
			170 : begin pls90 <= 0; min90 <= 1; phase <= -22320; end
			171 : begin pls90 <= 1; min90 <= 0; phase <= 22680; end
			172 : begin pls90 <= 1; min90 <= 0; phase <= 21600; end
			173 : begin pls90 <= 1; min90 <= 0; phase <= 20520; end
			174 : begin pls90 <= 1; min90 <= 0; phase <= 19440; end
			175 : begin pls90 <= 1; min90 <= 0; phase <= 18360; end
			176 : begin pls90 <= 1; min90 <= 0; phase <= 17280; end
			177 : begin pls90 <= 1; min90 <= 0; phase <= 16200; end
			178 : begin pls90 <= 1; min90 <= 0; phase <= 15120; end
			179 : begin pls90 <= 1; min90 <= 0; phase <= 14040; end
			180 : begin pls90 <= 1; min90 <= 0; phase <= 12960; end
			181 : begin pls90 <= 1; min90 <= 0; phase <= 11880; end
			182 : begin pls90 <= 1; min90 <= 0; phase <= 10800; end
			183 : begin pls90 <= 1; min90 <= 0; phase <= 9720; end
			184 : begin pls90 <= 1; min90 <= 0; phase <= 8640; end
			185 : begin pls90 <= 1; min90 <= 0; phase <= 7560; end
			186 : begin pls90 <= 1; min90 <= 0; phase <= 6480; end
			187 : begin pls90 <= 1; min90 <= 0; phase <= 5400; end
			188 : begin pls90 <= 1; min90 <= 0; phase <= 4320; end
			189 : begin pls90 <= 1; min90 <= 0; phase <= 3240; end
			190 : begin pls90 <= 1; min90 <= 0; phase <= 2160; end
			191 : begin pls90 <= 1; min90 <= 0; phase <= 1080; end
		endcase
	end
	// Assign output signals
	assign phase_out = phase;
	assign pls90_out = pls90;
	assign min90_out = min90;
endmodule

// fft 256 point stage module
module fft_256pt_stage (clk, rst_n, enable, data_r_in, data_i_in, data_r_out, data_i_out);
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

	// Data from 256pt butterfly
	wire signed [15 : 0] data_r_64;
	wire signed [15 : 0] data_i_64;

	fft_256p_unit fft_256pt_stage_bf (
				.clk(clk),
				.rst_n(rst_n),
				.enable(enable),
				.data_in_r(data_r_in),
				.data_in_i(data_i_in),
				.data_out_r(real_imd),
				.data_out_i(img_imd));

	fft_256pt_rotate_ctl rotate_256pt_stage_ctl(
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
	
	cordic_nppl cordic_256pt_stage (
				.real_in(real_part),
				.img_in(img_part),
				.z_in(phase),
				.real_out(data_r_out),
				.img_out(data_i_out));

endmodule
