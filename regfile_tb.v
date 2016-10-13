module register_file_tb ;

reg [2:0] writenum, readnum;
reg clk,write;
reg [15:0] data_in; 
 
wire [15:0] data_out;

reg_file DUT (.writenum(writenum), .write(write), .data_in(data_in), .clk(clk), .readnum(readnum), .data_out(data_out));


initial begin

clk=1; #5 clk=0;
forever 
begin
$display("writenum = %b, write = %b, data_in = %b, clk = %b, readnum = %b, data_out = %b", writenum, write, data_in, clk, readnum, data_out);
#5 clk = 1; #5 clk = 0;
end
end

initial begin

writenum = 3'b000; readnum = 3'b000; write = 0; data_in = {16{1'b0}};
#15 write = 1;
#15 write = 0;
#30
writenum = 3'b001; write = 1; data_in = {16{1'b1}};
#15 write = 0; readnum = 3'b001;
#50
$stop;
end 
endmodule



//test bench for registers

module reg_tb;
reg [15:0] in; 
reg clk,load;
wire [15:0] out;


register DUT (.in(in),.clk(clk),.load(load),.out(out));


initial begin

clk=1; #5 clk=0;
forever 
begin
$display("in = %b, out = %b, load = %b, clk = %b", in, out, load, clk);
#5 clk = 1; #5 clk = 0;
end
end

initial begin 
load = 0 ; in = {16{1'b0}};

# 15 load = 1; 
# 15 load = 0;
# 15 in = {16{1'b1}}; load = 1;
# 15 load = 0;
# 60
$stop ;
end 
endmodule 


//test bench for decoder 

module decoder_tb;
reg [2:0] in;
wire [7:0] out; 

decode3_8 DUT(.in(in), .out(out));
initial begin
in = 3'b000;
#15
$display("input %b, output %b", in, out);
#15
in = 3'b101;
#15
$display("input %b, output %b", in, out);
#15
in = 3'b111;
#15
$display("input %b, output %b", in, out);

end 
endmodule 
