module factor (
	input  clk,
	input  rst_n,
	input  i_in_valid,
	input  [11:0] i_n,
	output [3:0]  o_p2,
	output [2:0]  o_p3,
	output [2:0]  o_p5,
	output        o_out_valid,
	output [50:0] number
);

endmodule

//BW-bit FD2
module REGP#(
	parameter BW = 2
)(
	input clk,
	input rst_n,
	output [BW-1:0] Q,
	input [BW-1:0] D,
	output [50:0] number
);

wire [50:0] numbers [0:BW-1];

genvar i;
generate
	for (i=0; i<BW; i=i+1) begin
		FD2 f0(Q[i], D[i], clk, rst_n, numbers[i]);
	end
endgenerate

//sum number of transistors
reg [50:0] sum;
integer j;
always @(*) begin
	sum = 0;
	for (j=0; j<BW; j=j+1) begin 
		sum = sum + numbers[j];
	end
end

assign number = sum;

endmodule

module COUNTER4(
	clk_i,
	din_i,
	dout_o,
	rst_i
);

input clk_i, din_i;
output [3:0] dout_o;
wire [50:0] numbers [4];

wire [3:0] carry, sumo, sumi, carryd;

genvar i;

generate
	for (i=1;i<4;i=i+1) begin
		HA1 ha0(carry[i],sumo[i],sumi[i], carryd[i]);
		FD2 fds0(sumi[i], sumo[i],clk_i, )
	end
endgenerate

endmodule