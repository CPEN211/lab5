module datapath_tb;

	reg [15:0] datapath_in;
	reg [2:0] readnum, writenum;
	reg [1:0] shift, ALUop;
	reg clk, vsel, loada, loadb, asel, bsel, loadc, loads, write;

	wire [15:0] datapath_out;
	wire status;

	datapath DUT(.clk(clk), .readnum(readnum), .vsel(vsel), .loada(loada), .loadb(loadb), .shift(shift), .asel(asel), .bsel(bsel), .ALUop(ALUop), .loadc(loadc), .loads(loads), .writenum(writenum), .write(write), .datapath_in(datapath_in), .status(status), .datapath_out(datapath_out));

	initial begin

		//section to set all inputs initially?

		//testing example datapath operation from lab handout
		clk = 0; #5; clk = 1;
		datapath_in = 32; vsel = 1; write = 1; writenum = 2; //should push value of 32 into R2 on posedge
		#5; clk = 0; #5;
		$display ("R2 contains value %b",datapath_tb.DUT.regfile.R2.out);

		clk = 1; #5;
		datapath_in = 56; writenum = 3; //should push value of 56 into R3 on posedge
		readnum = 2; loada = 1; //loading 32 into RA on posedge
		#5; clk = 0; #5;

		clk = 1; #5;
		readnum = 3; loada = 0; loadb = 1; //loading 56 into RB on posedge
		#5; clk = 0; #5;

		clk = 1; #5;
		loadb = 0; ALUop = 0; asel = 0; bsel = 0; shift = 0; loadc = 1; loads = 1; //adding RA and RB and storing sum in RC on posedge
		#5; clk = 0; #5;
		
		clk = 1; #5;
		loadc = 0; vsel = 0; writenum = 5; //pushing 88 into R5
		#5; clk = 0; #5;
		
	end

endmodule

		
		

		
		

		 
	
