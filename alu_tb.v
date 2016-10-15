module alu_tb;

	reg [15:0] a, b;
	reg [1:0] op;
	wire s;
	wire [15:0] c;

	ALU DUT(.ain(a), .bin(b), .ALUop(op), .cout(c), .status(s));
 
	initial begin
		
		//subtraction,result != 0
		a = 15; b = 4; op = 1; 
		#100
		$display ("ain was %d, bin was %d, performed subtraction, cout was %d, status was %b", a, b, c, s);

		//addition		
		a = 5; b = 3; op = 0;
		#100
		$display ("ain was %d, bin was %d, performed addition, cout was %d, status was %b", a, b, c, s);

		//AND, result != 0
		a = 6; b = 3; op = 2;
		#100
		$display ("ain was %b, bin was %b, performed AND, cout was %b, status was %b", a, b, c, s);
		
		//pass ain, result != 0
		a = 9; b = 3; op = 3;
		#100
		$display ("ain was %d, bin was %d, performed pass ain, cout was %d, status was %b", a, b, c, s);

		//subtraction, result = 0
		a = 10; b = 10; op = 1;
		#100
		$display ("ain was %d, bin was %d, performed subtraction, cout was %d, status was %b", a, b, c, s);

		//addition overflow
		a = 16'b1111111111111111; b = 16'b0000000000000001; op = 0;
		#100
		$display ("ain was %b, bin was %b, performed addition, cout was %b, status was %b", a, b, c, s);

		//subtraction underflow, note 2's complement answer of -1
		a = 0; b = 1; op = 1;
		#100
		$display ("ain was %d, bin was %d, performed subtraction, cout was %b, status was %b", a, b, c, s);

	end

endmodule	
	