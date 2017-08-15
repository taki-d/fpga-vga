
module top(
	input clk,
	output vga_h_sync,
	output vga_v_sync,
	output R,
	output G,
	output B
);


reg [9:0] CounterX;
reg [8:0] CounterY;

reg CounterXmaxed = (CounterX == 767);

always @(posedge clk) begin
	if(CounterXmaxed)
		CounterX <= 0;
	else
		CounterX <= CounterX + 1;
end
	
always @(posedge clk) begin
	if(CounterXmaxed)
		CounterY <= CounterY + 1;
end

reg vga_HS, vga_VS;

always @(posedge clk) begin
	vga_HS <= (CounterX[9:4] == 0);
	vga_VS <= (CounterY == 0);
end

assign vga_h_sync = ~vga_HS;
assign vga_v_sync = ~vga_VS;

assign R = CounterY[3] | (CounterX==256);
assign G = (CounterX[5] ^ CounterX[6]) | (CounterX==256);
assign B = CounterX[4] | (CounterX==256);

endmodule


module testbench();
	initial begin
		$dumpfile("testbench.vcd");
		$dumpvars(0,testbench);
	end
	wire a,b,c,d,e;

	reg clk;
	top test(clk,a,b,c,d,e);
	
	always begin
		#1; 
		clk = 0;
		#1;
		clk = 1;
	end
endmodule
