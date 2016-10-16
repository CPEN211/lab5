module Shifter_tb;

	reg [15:0] in;
	reg [1:0] op;
	wire [15:0] out;

	Shifter DUT(.op(op), .in(in), .out(out));

	initial begin
		
		//shifting left by 1
		in = 16'b1100000000000111; op = 2'b01;
		#100
		$display("in was %b, shifted left by 1, out was %b", in, out);

		//shifting right by 1
		in = 16'b1110000000000011; op = 2'b10;
		#100
		$display("in was %b, shifted right by 1, out was %b", in, out);

		//arithmetic shifting right by 1
		in = 16'b1110000000000011; op = 2'b11;
		#100
		$display("in was %b, arithmetic shifted right by 1, out was %b", in, out);

		//don't change input
		in = 16'b1110000000000011; op = 2'b00;
		#100
		$display("in was %b, passing input, out was %b", in, out);

	end

endmodule 