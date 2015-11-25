`timescale 1ns/1ps

module r4_unit_tb ();
	reg clk;
	reg rst_n;
	reg signed [15 : 0] data_in_r;
	reg signed [15 : 0] data_in_i;
	wire signed [15 : 0] data_out_r;
	wire signed [15 : 0] data_out_i;

// Clock signal
initial begin
	clk = '1;
	repeat (20) begin
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
		data_in_r <= 2;
		data_in_i <= 0;
	end
	else begin
		data_in_r = data_in_r + 1;
	end
end

// Instantiate DUT
r4_unit r4_dut(
	.clk(clk),
	.rst_n(rst_n),
	.data_in_r(data_in_r),
	.data_in_i(data_in_i),
	.data_out_r(data_out_r), 
	.data_out_i(data_out_i));

endmodule
