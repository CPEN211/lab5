module ALU(ain, bin, ALUop, ALUout, status);

	`define width 16
	`define add 2'b00
	`define minus 2'b01
	`define and1 2'b10
	`define A 2'b11

	input [`width-1:0] ain,bin;
	input [1:0] ALUop;
	output reg [`width-1:0] ALUout;
	output status;

	always @ (*) begin

		case(ALUop)

			`add : ALUout = ain + bin;
			`minus : ALUout = ain - bin;
			`and1 : ALUout = ain & bin;
			`A : ALUout = ain;
			default : ALUout = {16{1'b0}};

		endcase
	end

	assign status = (|ALout)? 0:1;
endmodule
