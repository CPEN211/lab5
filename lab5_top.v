// INSTRUCTIONS:
//
// You can use this file to demo your Lab5 on your DE1-SoC.  You should NOT 
// spend ANY time looking at this file until you have first read the Lab 5 
// handout completely and especially Sections 3 (Lab Procedure) and Section 4
// (which describes the marking scheme).
// 
// If you prefer you can instead use your own version of lab5_top.v.
//
// You MUST submit whichever lab5_top.v you used during your demo with handin.
//
// If you DO use this file you will need to fill in the sseg module as by
// default it will just print F's on HEX0 through HEX3.  Also, the signal 
// names inside the lab5_top module may need to be change to match the 
// ones you use in your own datapath module.



// DE1-SOC INTERFACE SPECIFICATION for lab5_top.v code in this file:
//
// clk input to datpath has rising edge when KEY0 is *pressed* 
//
// LEDR9 is the status register output
//
// HEX3, HEX2, HEX1, HEX0 are wired to datapath_out.
//
// When SW[9] is set to 1, SW[7:0] changes the lower 8 bits of datpath_in.
// (The upper 8-bits are hardwired to zero.) The LEDR[8:0] will show the
// current control inputs (LED "on" means input has logic value of 1).
//
// When SW[9] is set to 0, SW[8:0] changes the control inputs to the datapath
// as listed in the table below.  Note that the datapath has three main
// stages: register read, execute and writeback.  On any given clock cycle,
// you should only need to configure one of these stages so some switches are
// reused.  LEDR[7:0] will show the lower 8-bits of datapath_in (LED "on"
// means corresponding input has logic value of 1).
//
// control signal(s)  switch(es)
// ~~~~~~~~~~~~~~~~~  ~~~~~~~~~       
// <<register read stage>>
//           readnum  SW[3:1]
//             loada  SW[5]
//             loadb  SW[6]
// <<execute stage>>
//             shift  SW[2:1]
//              asel  SW[3]
//              bsel  SW[4]
//             ALUop  SW[6:5]
//             loadc  SW[7]
//             loads  SW[8]
// <<writeback stage>>
//             write  SW[0]      
//          writenum  SW[3:1]
//              vsel  SW[4]


module lab5_top(KEY,SW,LEDR,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,CLOCK_50);

	//binary to hex defintions
	`define zero 7'b1000000
	`define one 7'b1111001
	`define two 7'b0100100
	`define three 7'b0110000
	`define four 7'b0011001
	`define five 7'b0010010
	`define six 7'b0000010
	`define seven 7'b1111000
	`define eight 7'b0000000
	`define nine 7'b0011000
	`define A 7'b0001000
	`define b 7'b0000011
	`define C 7'b1000110
	`define d 7'b0100001
	`define E 7'b0000110
	`define F 7'b0001110
	`define OFF 7'b1111111

  input [3:0] KEY;
  input [9:0] SW;
  
  output [9:0] LEDR; 
  output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	wire [6:0] intrnl_HEX0, intrnl_HEX1, intrnl_HEX2, intrnl_HEX3; //to enable fun times
  input CLOCK_50;

  wire [15:0] datapath_out, datapath_in;
  wire write, vsel, loada, loadb, asel, bsel, loadc, loads;
  wire [2:0] readnum, writenum;
  wire [1:0] shift, ALUop;
	wire coffee_sw = SW[8]; //for fun times
	wire sel_sw = SW[9]; //to enable fun times

  input_iface IN(CLOCK_50, SW, datapath_in, write, vsel, loada, loadb, asel, 
                 bsel, loadc, loads, readnum, writenum, shift, ALUop, LEDR[8:0]);

  datapath DP ( .clk         (~KEY[0]), // recall from Lab 4 that KEY0 is 1 when NOT pushed

                // register operand fetch stage
                .readnum     (readnum),
                .vsel        (vsel),
                .loada       (loada),
                .loadb       (loadb),

                // computation stage (sometimes called "execute")
                .shift       (shift),
                .asel        (asel),
                .bsel        (bsel),
                .ALUop       (ALUop),
                .loadc       (loadc),
                .loads       (loads),

                // set when "writing back" to register file
                .writenum    (writenum),
                .write       (write),  
                .datapath_in (datapath_in),

                // outputs
                .status      (LEDR[9]),
                .datapath_out(datapath_out)
             );

  // fill in sseg to display 4-bits in hexidecimal 0,1,2...9,A,B,C,D,E,F
  sseg H0(datapath_out[3:0],   intrnl_HEX0);   
  sseg H1(datapath_out[7:4],   intrnl_HEX1);
  sseg H2(datapath_out[11:8],  intrnl_HEX2);
  sseg H3(datapath_out[15:12], intrnl_HEX3);

	coffee CAFE( .coffee_sw(coffee_sw), .sel_sw(sel_sw), //sw[9] and sw[8] to enable fun times

				 .intrnl_HEX3(intrnl_HEX3), .intrnl_HEX2(intrnl_HEX2), .intrnl_HEX1(intrnl_HEX1), .intrnl_HEX0(intrnl_HEX0), //connections from datapath

				 .HEX0(HEX0), .HEX1(HEX1), .HEX2(HEX2), .HEX3(HEX3), .HEX4(HEX4), .HEX5(HEX5) //connections to sseg displays
				);

endmodule


//When sw[9] and sw [8] are both 1, displays COFFEE on ssegs 5 through 0. Those switches are not used in that combination for anything else.
//When sw[9] & sw[8] = 0, ssegs 5 and 4 display nothing, while ssegs 3 through 0 display datapath_out.
module coffee(input coffee_sw, sel_sw, input [6:0] intrnl_HEX3, intrnl_HEX2, intrnl_HEX1, intrnl_HEX0, output[6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);

	assign {HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = (coffee_sw & sel_sw) ? {`C, `zero, `F, `F, `E, `E} : {`OFF, `OFF, intrnl_HEX3, intrnl_HEX2, intrnl_HEX1, intrnl_HEX0};

endmodule


module input_iface(clk, SW, datapath_in, write, vsel, loada, loadb, asel, bsel, 
                   loadc, loads, readnum, writenum, shift, ALUop, LEDR);
  input clk;
  input [9:0] SW;
  output [15:0] datapath_in;
  output write, vsel, loada, loadb, asel, bsel, loadc, loads;
  output [2:0] readnum, writenum;
  output [1:0] shift, ALUop;
  output [8:0] LEDR;

  wire sel_sw = SW[9];   

  // When SW[9] is set to 1, SW[7:0] changes the lower 8 bits of datpath_in.
  wire [15:0] datapath_in_next = sel_sw ? {8'b0,SW[7:0]} : datapath_in;
  vDFF #(16) DATA(clk,datapath_in_next,datapath_in);

  // When SW[9] is set to 0, SW[8:0] changes the control inputs 
  wire [8:0] ctrl_sw;
  wire [8:0] ctrl_sw_next = sel_sw ? ctrl_sw : SW[8:0];
  vDFF #(9) CTRL(clk,ctrl_sw_next,ctrl_sw);

  assign {readnum,vsel,loada,loadb,shift,asel,bsel,ALUop,loadc,loads,writenum,write}={
    // register operand fetch stage
    //     readnum       vsel        loada       loadb
           ctrl_sw[3:1], ctrl_sw[4], ctrl_sw[5], ctrl_sw[6], 
    // computation stage (sometimes called "execute")
    //     shift         asel        bse         ALUop         loadc       loads
           ctrl_sw[2:1], ctrl_sw[3], ctrl_sw[4], ctrl_sw[6:5], ctrl_sw[7], ctrl_sw[8],  
    // set when "writing back" to register file
    //   writenum        write
           ctrl_sw[3:1], ctrl_sw[0]    
  };

  // LEDR[7:0] shows other bits
  assign LEDR = sel_sw ? ctrl_sw : {1'b0, datapath_in[7:0]};  
endmodule         


module vDFF(clk,D,Q);
  parameter n=1;
  input clk;
  input [n-1:0] D;
  output [n-1:0] Q;
  reg [n-1:0] Q;

  always @(posedge clk)
    Q <= D;
endmodule


// The sseg module below can be used to display the value of datpath_out on
// the hex LEDS the input is a 4-bit value representing numbers between 0 and
// 15 the output is a 7-bit value that willrint a hexadecimal digit.  You
// may want to look at the code in Figure 7.20 and 7.21 in Dally but note this
// code will not work with the DE1-SoC because the order of segments used in
// the book is not the same as on the DE1-SoC (see comments below).

module sseg(in,segs);

//	`define zero 7'b1000000
//	`define one 7'b1111001
//	`define two 7'b0100100
//	`define three 7'b0110000
//	`define four 7'b0011001
//	`define five 7'b0010010
//	`define six 7'b0000010
//	`define seven 7'b1111000
//	`define eight 7'b0000000
//	`define nine 7'b0011000
//	`define A 7'b0001000
//	`define b 7'b0000011
//	`define C 7'b1000110
//	`define d 7'b0100001
//	`define E 7'b0000110
//	`define F 7'b0001110

  input [3:0] in;
  output [6:0] segs;
	reg [6:0] segs;

	always @(*)begin
	
	case (in)
	
	4'b 0000 : segs = `zero ;
	4'b 0001 : segs = `one ;
	4'b 0010 : segs = `two ;
	4'b 0011 : segs = `three ;
	4'b 0100 : segs = `four ;
	4'b 0101 : segs = `five ;
	4'b 0110 : segs = `six ;
	4'b 0111 : segs = `seven ;
	4'b 1000 : segs = `eight ;
	4'b 1001 : segs = `nine ;
	4'b 1010 : segs = `A;
	4'b 1011 : segs = `b;
	4'b 1100 : segs = `C;
	4'b 1101 : segs = `d;
	4'b 1110 : segs = `E;
	4'b 1111 : segs = `F;

	endcase
	end
	 
  //assign segs = 7'b0001110;  // this will output "F" 

endmodule

  // NOTE: The code for sseg is not complete: You can use your code from
  // Lab4 to fill this in or code from someone else's Lab4.  
  //
  // IMPORTANT:  If you *do* use someone else's Lab4 code for the seven
  // segment display you *need* to state the following three things in
  // a file README.txt that you submit with handin along with this code: 
  //
  //   1.  First and last name of student providing code
  //   2.  Student number of student providing code
  //   3.  Date and time that student provided you their code
  //
  // You must also (obviously!) have the other student's permission to use
  // their code.
  //
  // To do otherwise is considered plagiarism.
  //
  // One bit per segment. On the DE1-SoC a HEX segment is illuminated when
  // the input bit is 0. Bits 6543210 correspond to:
  //
  //    0000
  //   5    1
  //   5    1
  //    6666
  //   4    2
  //   4    2
  //    3333
  //
  // Decimal value | Hexadecimal symbol to render on (one) HEX display
  //             0 | 0
  //             1 | 1
  //             2 | 2
  //             3 | 3
  //             4 | 4
  //             5 | 5
  //             6 | 6
  //             7 | 7
  //             8 | 8
  //             9 | 9
  //            10 | A
  //            11 | b
  //            12 | C
  //            13 | d
  //            14 | E
  //            15 | F
