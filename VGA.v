/*ѧϰVGA��ʾԭ��,��ʾ�����źš�
��ӿ�������VGA�ӿں͵�����ʾ����
���뿪��1��2ͬʱ���ϲ���  ����ʾ8ɫ���������̸���
���뿪��1̧��ȥ��2���ϲ�������ʾ�任������8ɫ���������̸���
���뿪��1��2ͬʱ����ON������ʾ8ɫ����
���뿪��1������2����ON������ʾ8ɫ����
*/
module VGA(
   clock,
   switch,
   disp_RGB,
   hsync,
   vsync
);
input  clock;     //ϵͳ����ʱ�� 50MHz
input  [1:0]switch;
output [2:0]disp_RGB;    //VGA��������
output  hsync;     //VGA��ͬ���ź�
output  vsync;     //VGA��ͬ���ź�

reg [9:0] hcount;     //VGA��ɨ��������
reg [9:0]   vcount;     //VGA��ɨ��������
reg [2:0]   data;
reg [2:0]  h_dat;
reg [2:0]   v_dat;

reg [4:0] vram[4:0];
 
//reg [9:0]   timer;


wire  hcount_ov;
wire  vcount_ov;
wire  dat_act;
wire  hsync;
wire  vsync;
reg  vga_clk;
//VGA�С���ɨ��ʱ��������
parameter hsync_end   = 10'd95,
   hdat_begin  = 10'd143,
   hdat_end  = 10'd783,
   hpixel_end  = 10'd799,
   vsync_end  = 10'd1,
   vdat_begin  = 10'd34,
   vdat_end  = 10'd514,
   vline_end  = 10'd524;


always @(posedge clock)
begin
 vga_clk = ~vga_clk;
end

//************************VGA��������******************************* 
//��ɨ��     
always @(posedge vga_clk)
begin
 if (hcount_ov)
  hcount <= 10'd0;
 else
  hcount <= hcount + 10'd1;
end
assign hcount_ov = (hcount == hpixel_end);
//��ɨ��
always @(posedge vga_clk)
begin
 if (hcount_ov)
 begin
  if (vcount_ov)
   vcount <= 10'd0;
  else
   vcount <= vcount + 10'd1;
 end
end
assign  vcount_ov = (vcount == vline_end);
//���ݡ�ͬ���ź���
assign dat_act =    ((hcount >= hdat_begin) && (hcount < hdat_end))
     && ((vcount >= vdat_begin) && (vcount < vdat_end));
assign hsync = (hcount > hsync_end);
assign vsync = (vcount > vsync_end);
assign disp_RGB = (dat_act) ?  data : 3'h00;       

//************************��ʾ���ݴ�����******************************* 
//ͼƬ��ʾ��ʱ������
/*always @(posedge vga_clk)
begin
 flag <= vcount_ov;
 if(vcount_ov && ~flag)
  timer <= ti)mer + 1'b1;
end
*/
wire[23:0] dataA = 0,dataB = 0;
reg[15:0] addrA = 0,addrB = 0;
wire weA = 0,weB = 0;
wire[23:0] q_A ,q_B;

true_dpram_sclk dram(dataA,dataB,addrA,addrB,weA,weB,clock,q_A,q_B);


wire [12:0] h_count_;
assign h_count_ = hcount - 34;
reg h_count;
always begin
	#1;
	if(h_count_ < 0) begin
		h_count <= 0;
	end
	h_count <= h_count_; 
end

wire [12:0] _v_count;
assign _v_count = vcount - 143;
reg v_count;
always begin
 	#1;
	if(_v_count < 0) begin
		h_count = 0;
	end
	h_count = h_count_;
end

wire [16:0] ram_addr;
assign ram_addr = hcount / 8 + vcount * 80;

always @(posedge clock) begin
	addrA <= ram_addr;
end

//reg index,start,end_;

wire [16:0] index;
assign index = hcount % 8;

//reg buff[23:0];

wire [23:0] hoge = (q_A << (3 * index));

always @(posedge vga_clk) begin
	data <= hoge[23:21];

//	data = buff[23:21];
end

// read from ram
//always begin
//	case(state) begin
//		0'b00: next_state = 0'b01; //fetching 
//		0'b01: next_state = 0'b10; //wait
//		0'b02: next_state = 0'b00; //printing
//		default: next_state = 0'b001;
//	end
//end



initial begin
	vram[0] = 5'b00111;
	vram[1] = 5'b00111;
	vram[2] = 5'b11000;
	vram[3] = 5'b00111;
	vram[4] = 5'b00111;
end

endmodule



module testbench();
	initial begin
		$dumpfile("testbench.vcd");
		$dumpvars(0,testbench);
	end	
	
	reg clk;
	
	wire [1:0] sw = 0;
	wire [2:0] rgb = 0;
	wire hksync = 0,vksync = 0;
	
	VGA hoge(
		clk,
		sw,
		rgb,
		hksync,
		vksync
	);
	
	always begin
		clk = 1;
		#1;
		clk = 0;
		#1;
	end
endmodule





