module true_dpram_sclk
(
	input [23:0] data_a, data_b,
//input [7:0] data_a,data_b,
	input [15:0] addr_a, addr_b,
//input [9:0] addr_a,addr_b,
	input we_a, we_b, clk,
	output reg [23:0] q_a, q_b
//	output reg [7:0] q_a, q_b
);
	// Declare the RAM variable
	reg [23:0] ram[2000:0];
//	reg [7:0] ram [9:0];
	integer i;
	
	// Port A
	always @ (posedge clk)
	begin
		if (we_a) 
		begin
			ram[addr_a] <= data_a;
			q_a <= data_a;
		end
		else 
		begin
			q_a <= ram[addr_a];
		end
	end
	
	// Port B
	always @ (posedge clk)
	begin
		if (we_b)
		begin
			ram[addr_b] <= data_b;
			q_b <= data_b;
		end
		else
		begin
			q_b <= ram[addr_b];
		end
	end
	
	initial begin
//		$readmemh("./ram.txt",ram);
		for(i = 0; i < 2000; i = i + 1) begin
			ram[i] = 24'b100010001110011111000111;
		end
		
	end
	
endmodule


module testbenchh();
	initial begin
		$dumpfile("testbench.vcd");
		$dumpvars(0,testbench);
	end
	
	reg clk;
	wire[23:0] data_a = 0,data_b = 0;
	reg[15:0] addr_a = 0,addr_b = 0;
	wire we_a = 0,we_b = 0;
	wire[23:0] q_a,q_b;
	
	true_dpram_sclk mem(data_a,data_b
						,addr_a,addr_b
						,we_a,we_b,
						clk
						,q_a,q_b
	);
	
	always begin
		clk = 0;
		#1
		clk = 1;
		#1
		//write read logic
		addr_a = 5'b0000000000011;
		clk = 0;
		#1
		clk = 1;
		#1
		clk = 0;
		#1
		clk = 1;
		#1
		clk = 0;
		#0
		clk = 1;
	end
	

endmodule

