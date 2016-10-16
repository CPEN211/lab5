module Shifter(op, in, out);

	`define Lshift 2'b01
	`define Rshift 2'b10
	`define ARshift 2'b11

	input [15:0] in; //input number to be shifted
	input [1:0] op; //type of shifting to be performed
	output reg [15:0] out; //shifted number

	always @(*) begin
		case(op)

			`Lshift : ou = in<<1;
			`Rshift : out = in>>1;
			`ARshift : out = {{in[15]}, in[15:1]};
			default : out = in;

		endcase
	end

 endmodule
			

	