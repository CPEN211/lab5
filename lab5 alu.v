module ALU(ain, bin, ALUop, cout, status);

	`define width 16
	`define add 2'b00
	`define minus 2'b01
	`define and1 2'b10
	`define A 2'b11

	input [`width-1:0] ain,bin;
	input [1:0] ALUop;
	output [`width-1:0] cout;
	output status;
	reg [`width-1:0] cout;



	always @ (*) begin

		case(ALUop)

			`add : cout = ain + bin;
			`minus : cout = ain - bin;
			`and1 : cout = ain & bin;
			`A : cout = ain;
			default : cout = {16{1'b0}};

		endcase
	end

	assign status = (|cout)? 0:1;
endmodule
