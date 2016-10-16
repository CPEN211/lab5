module reg_file(writenum, write, data_in, clk, readnum, data_out);

	//defining binary to b# for writenum and readnum.
	`define b0 3'b000
	`define	b1 3'b001
	`define	b2 3'b010
	`define	b3 3'b011
	`define	b4 3'b100
	`define b5 3'b101
	`define b6 3'b110
	`define b7 3'b111

	//defining one hot for out in decoder.
	`define h0 8'b00000001
	`define h1 8'b00000010
	`define h2 8'b00000100
	`define h3 8'b00001000
	`define h4 8'b00010000
	`define h5 8'b00100000
	`define h6 8'b01000000
	`define h7 8'b10000000

	//define width
	`define width16 16
	`define width8 8
	
	input [2:0] writenum;
	input write;
	input [15:0] data_in;
	input clk;
	input [2:0] readnum;
	wire [15:0] out_zero, out_one, out_two, out_three, out_four, out_five, out_six, out_seven;
	output [15:0] data_out;
	wire [7:0] out_blk1, out_blk2, load;

	decode3_8 blockone (.in(writenum), .out(out_blk1));
	decode3_8 blocktwo (.in(readnum), .out(out_blk2));
	
	register R0(.load(load[0]), .clk(clk), .in(data_in), .out(out_zero)); 
	register R1(.load(load[1]), .clk(clk), .in(data_in), .out(out_one));
	register R2(.load(load[2]), .clk(clk), .in(data_in), .out(out_two));
	register R3(.load(load[3]), .clk(clk), .in(data_in), .out(out_three));
	register R4(.load(load[4]), .clk(clk), .in(data_in), .out(out_four));
	register R5(.load(load[5]), .clk(clk), .in(data_in), .out(out_five));
	register R6(.load(load[6]), .clk(clk), .in(data_in), .out(out_six));
	register R7(.load(load[7]), .clk(clk), .in(data_in), .out(out_seven));
	
	mux16 #(`width16,`width8) mux(.in0(out_zero), .in1(out_one), .in2(out_two), .in3(out_three), .in4(out_four), .in5(out_five), .in6(out_six), .in7(out_seven), .choose(out_blk2), .outone(data_out)); 
	
	assign load = {8{write}} & out_blk1;

endmodule

module mux16(in0, in1, in2, in3, in4, in5, in6, in7, choose, outone); //mux to choose between Register values 

	parameter k=1;
	parameter m=1;
	input [k-1:0] in0, in1, in2, in3, in4, in4, in5, in6, in7;
	input [m-1:0] choose;
	output [k-1:0] outone;
	reg [k-1:0] outone;
	
	always @ (*) begin
		case(choose)
			8'b00000001 : outone = in0;
			8'b00000010 : outone = in1;
			8'b00000100 : outone = in2;
			8'b00001000 : outone = in3;
			8'b00010000 : outone = in4;
			8'b00100000 : outone = in5;
			8'b01000000 : outone = in6;
			8'b10000000 : outone = in7;
			default : outone = {k{1'b0}};
		endcase
	end 

endmodule

module register(load, clk, in, out); //register module for loading value.
	
	parameter k = 16;
	input clk;
	input load;
	input [k-1:0] in;
	output [k-1:0] out;
	
	wire [k-1:0] new_mem;
	
	assign new_mem = load ? in:out;
	
	vDFF #(k) flipflop_1(.clk(clk), .D(new_mem), .Q(out));

endmodule

module decode3_8(in,out); //decoder module same as the one in the text book 

	input [2:0] in;
	output [7:0] out;
	reg [7:0] out;
	
	always @(*) begin	
		case(in)
			`b0: out = `h0;
			`b1: out = `h1;
			`b2: out = `h2;
			`b3: out = `h3;
			`b4: out = `h4;
			`b5: out = `h5;
			`b6: out = `h6;
			`b7: out = `h7;
			default: out = {8{1'b0}};
		endcase
	end

endmodule  

