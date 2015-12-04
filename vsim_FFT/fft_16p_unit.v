// FSM controller for 16 point fft
module fft_16p_unit_ctl (clk, rst_n, by_pass, ld0, ld1, ld2);
	input clk;
	input rst_n;
	output reg by_pass, ld0, ld1, ld2;
	
	reg [3 : 0] state;
	
	always @(posedge clk) begin
		if (rst_n == 0) begin
			state <= 0;
		end
		else begin
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

module fft_16p_unit (clk, rst_n, data_in_r, data_in_i, data_out_r, data_out_i);
	input clk;
	input rst_n;
	
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
