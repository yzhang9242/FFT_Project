`timescale 1ns/1ps

module fft_main_tb ();
	reg clk;
	reg rst_n;
	reg signed [15 : 0] data_in_r;
	reg signed [15 : 0] data_in_i;
	wire signed [15 : 0] data_out_r;
	wire signed [15 : 0] data_out_i;

	integer input_file;
	integer input_cap;

initial begin
	input_file = $fopen("fft.in", "r");
	input_cap = $fscanf(input_file, "%d\n", data_in_r);	
end

// Clock signal
initial begin
	clk = '1;
	repeat (1000) begin
		#5
		clk = ~clk;
	end
end

initial begin
	rst_n = '0;
	#15
	rst_n = '1;
end


always @(posedge clk) begin
	if (rst_n == 0) begin
		data_in_i <= 0;
	end
	else begin
		input_cap = $fscanf(input_file, "%d\n", data_in_r);
	end
end

// Instantiate DUT
fft_256pt_main fft256_dut(
	.clk(clk),
	.rst_n(rst_n),
	.data_r_in(data_in_r),
	.data_i_in(data_in_i),
	.data_r_out(data_out_r), 
	.data_i_out(data_out_i));

endmodule
