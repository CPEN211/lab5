module datapath (clk, readnum, vsel, loada, loadb, shift, asel, bsel, ALUop, loadc, loads, writenum, write, datapath_in, status, datapath_out);

	input [15:0] datapath_in;
	input [2:0] readnum, writenum;
	input [1:0] shift, ALUop;
	input clk, vsel, loada, loadb, asel, bsel, loadc, loads, write;

	output [15:0] datapath_out;
	output status;

	wire [15:0] data_in, data_out, outA, outB, shift_out, ain, bin, ALUout;
	wire status_wire, dummy_wire;

	register A(.load(loada), .clk(clk), .in(data_out), .out(outA));
	register B(.load(loadb), .clk(clk), .in(data_out), .out(outB));
	register C(.load(loadc), .clk(clk), .in(ALUout), .out(datapath_out));

	mux2_1 v(.in1(datapath_in), .in0(datapath_out), .sel(vsel), .out(data_in));
	mux2_1 a(.in1({16{1'b0}}), .in0(outA), .sel(asel), .out(ain));
	mux2_1 b(.in1({11'b0,datapath_in[4:0]}), .in0(shift_out), .sel(bsel), .out(bin));

	reg_file regfile(.writenum(writenum), .write(write), .data_in(data_in), .clk(clk), .readnum(readnum), .data_out(data_out));

	ALU alu(.ain(ain), .bin(bin), .ALUop(ALUop), .ALUout(ALUout), .status(status_wire));

	register #(1) status_reg(.load(loads), .clk(clk), .in(status_wire), .out(dummy_wire));

	Shifter shifter(.in(outB), .op(shift), .out(shift_out));

endmodule 

module mux2_1(in1, in0, sel, out);

	input [15:0] in1, in0;
	input sel;
	output [15:0] out;

	assign out=sel ? in1:in0;

endmodule

