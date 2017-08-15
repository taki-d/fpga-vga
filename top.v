
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

wire CounterXmaxed = (CounterX == 767);

always @(posedge clk) begin
	if(CounterXmaxed) begin
		CounterX <= 0;
	end
	else begin
		CounterX <= CounterX + 1;
	end
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
		
	end
	wire[4:0] hoge;
	top test(clock,hoge[0],hoge[1],hoge[2],hoge[3]);
	
	reg clock;
	always begin
		#50; clock <=  ~clock;
	end
endmodule
