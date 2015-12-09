module sr_tb ();
	reg clk;
	reg rst_n;
	reg signed [15 : 0] data_in;
	wire signed [15 : 0] data_out;
	initial begin
		clk = 0;
		repeat (200) begin
			#5
			clk = ~clk;
		end
	end
	initial begin
		rst_n = 0;
		#15
		rst_n = 1;
	end
	
	always @(posedge clk or rst_n) begin
		if (rst_n == 0) begin
			data_in <= 15'b0;
		end
		else begin
			data_in <= data_in + 1;
		end
	end
	
	SR_64 sr_dut (
			.clk(clk),
			.rst_n(rst_n),
			.data_in(data_in),
			.data_out(data_out));
endmodule

