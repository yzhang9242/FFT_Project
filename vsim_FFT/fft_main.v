module global_ctl (clk, rst_n, stage_256_en, stage_64_en, stage_16_en, stage_4_en, OE);
	input clk;
	input rst_n;
	
	output wire stage_256_en;
	output reg stage_64_en;
	output reg stage_16_en;
	output reg stage_4_en;
	output reg OE;

	reg [9 : 0] state;

	always @(posedge clk) begin
		if (rst_n == 0) begin
			state <= 0;
		end
		else begin
			if (state == 513)
				state <= 0;
			else state <= state + 1;
		end
	end
	
	assign stage_256_en = 1;

	always @(state) begin
		if (state > 192)
			stage_64_en <= 1;
		else
			stage_64_en <= 0;
	end

	always @(state) begin
		if (state > 241)
			stage_16_en <= 1;
		else
			stage_16_en <= 0;
	end
	always @(state) begin
		if (state > 254)
			stage_4_en <= 1;
		else
			stage_4_en <= 0;
	end
	always @(state) begin
		if (state > 257)
			OE <= 1;
		else
			OE <= 0;
	end
endmodule

module fft_256pt_main (clk, rst_n, data_r_in, data_i_in, data_r_out, data_i_out, OE);
	input clk;
	input rst_n;

	input signed [15 : 0] data_r_in;
	input signed [15 : 0] data_i_in;
	output signed [15 : 0] data_r_out;
	output signed [15 : 0] data_i_out;
	output OE;

	wire stage_256_en;
	wire stage_64_en;
	wire stage_16_en;
	wire stage_4_en;

	// Data wires
	wire signed [15 : 0] data_256pt_r;
	wire signed [15 : 0] data_256pt_i;
	wire signed [15 : 0] data_64pt_r;
	wire signed [15 : 0] data_64pt_i;
	wire signed [15 : 0] data_16pt_r;
	wire signed [15 : 0] data_16pt_i;
	
	global_ctl global_main_ctl (
			.clk(clk),
			.rst_n(rst_n),
			.stage_256_en(stage_256_en),
			.stage_64_en(stage_64_en),
			.stage_16_en(stage_16_en),
			.stage_4_en(stage_4_en),
			.OE(OE));

	fft_256pt_stage fft_256pt (
			.clk(clk),
			.rst_n(rst_n),
			.enable(stage_256_en),
			.data_r_in(data_r_in),
			.data_i_in(data_i_in),
			.data_r_out(data_256pt_r),
			.data_i_out(data_256pt_i));

	fft_64pt_stage fft_64pt (
			.clk(clk), 
			.rst_n(rst_n),
			.enable(stage_64_en),
			.data_r_in(data_256pt_r),
			.data_i_in(data_256pt_i),
			.data_r_out(data_64pt_r),
			.data_i_out(data_64pt_i));

	fft_16pt_stage fft_16pt (
			.clk(clk),
			.rst_n(rst_n),
			.enable(stage_16_en),
			.data_r_in(data_64pt_r),
			.data_i_in(data_64pt_i),
			.data_r_out(data_16pt_r),
			.data_i_out(data_16pt_i));

	fft_4pt_stage fft_4pt(
			.clk(clk),
			.rst_n(rst_n),
			.enable(stage_4_en),
			.data_in_r(data_16pt_r),
			.data_in_i(data_16pt_i),
			.data_out_r(data_r_out),
			.data_out_i(data_i_out));
endmodule
