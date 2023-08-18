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

wire [50:0] numbers [20:0];
wire [11:0] postfactor2,postfactor3,postfactor5;
wire [3:0] count2;
wire [2:0] count3,count5;
wire valid2,valid3,valid5;

Factor2 factor2(clk,rst_n,i_n,i_in_valid,valid2,postfactor2,o_p2,numbers[0]);
Factor3 factor3(clk,rst_n,i_n,i_in_valid,valid3,o_p3,numbers[1]);
Factor5 factor5(clk,rst_n,i_n,i_in_valid,valid5,o_p5,numbers[2]);
AN3 and0(o_out_valid,valid2,valid3,valid5,numbers[3]);

reg [50:0] sum;
integer j;
always @ (*) begin
	sum=0;
	for (j=0;j<=3;j=j+1) begin
		sum=sum+numbers[j];
	end
end
assign number=sum;


endmodule

module Factor5(
	clk_i,
	rst_i,
	data_i,
	in_valid_i,
	out_valid_o,
	count_o,
	number_o
);
	input clk_i,rst_i,in_valid_i;
	input [11:0] data_i;
	output [2:0] count_o;
	output [50:0]  number_o;
	output out_valid_o;
	wire [50:0] numbers [20:0];

	wire [17:0] init,circuit_i,circuit_o, temp1,temp2,temp3,temp4,temp5;
	assign init={1'b00,data_i,4'b0000}; 
	wire enable,in_valid_edge,enable_inv,outv;
	
	SigtoEdge ive(clk_i,rst_i,in_valid_i,in_valid_edge,numbers[0]);
	RegSet #(18) regist(clk_i,rst_i,enable,init,in_valid_edge,circuit_o,circuit_i,numbers[1]);
	RCA #(18) adder1(temp1,circuit_i,{4'b0000,circuit_i[17:4]},numbers[2]);
	RCA #(18) adder2(temp2,temp1,{8'b00000000,temp1[17:8]},numbers[3]);
	RCA #(18) adder3(temp3, temp2, {temp2[16:0],1'b0},numbers[4]);
	assign temp4={4'b0000,temp3[17:4]};
	ND4 nand4(enable,temp4[0],temp4[1],temp4[2],temp4[3],numbers[5]);
	RCA #(18) adder4(circuit_o, temp4,{17'b00000000000000000,temp4[0]},numbers[6]);
	IV inv(enable_inv,enable,numbers[7]);
	AN2 and0(outv,in_valid_i,enable,numbers[8]);
	REGP #(1) dff(clk_i,rst_i,out_valid_o,outv,numbers[9]);

	
	COUNTER #(3) count5(clk_i,rst_i,enable_inv,count_o,in_valid_i,numbers[10]);
		
	reg [50:0] sum;
	integer j;
	always @ (*) begin
		sum=0;
		for (j=0;j<=10;j=j+1) begin
			sum=sum+numbers[j];
		end
	end
	assign number_o=sum;


endmodule

module Factor3(
	clk_i,
	rst_i,
	data_i,
	in_valid_i,
	out_valid_o,
	count_o,
	number_o
);
	input clk_i,rst_i,in_valid_i;
	input [11:0] data_i;
	output [2:0] count_o;
	output [50:0]  number_o;
	output out_valid_o;
	wire [50:0] numbers [20:0];

	wire [16:0] init,circuit_i,circuit_o, temp1,temp2,temp3,temp4,temp5;
	assign init={1'b0,data_i,4'b0000}; 
	wire enable,in_valid_edge,enable_inv,outv;


	SigtoEdge ive(clk_i,rst_i,in_valid_i,in_valid_edge,numbers[0]);
	RegSet #(17) regist(clk_i,rst_i,enable,init,in_valid_edge,circuit_o,circuit_i,numbers[1]);
	RCA #(17) adder1(temp1,circuit_i,{2'b00,circuit_i[16:2]},numbers[2]);
	RCA #(17) adder2(temp2,temp1,{4'b0000,temp1[16:4]},numbers[3]);
	RCA #(17) adder3(temp3,temp2,{8'b00000000,temp2[16:8]},numbers[4]);
	assign temp4={2'b00,temp3[16:2]};
	ND2 nand0(enable,temp4[2],temp4[3],numbers[5]);
	RCA #(17) adder4(temp5,temp4,{14'b00000000000000,temp4[1],2'b00},numbers[6]);
	assign circuit_o={temp5[16:4],4'b0000};
	IV inv(enable_inv,enable,numbers[7]);
	AN2 and0(outv,in_valid_i,enable,numbers[8]);

	REGP #(1) dff(clk_i,rst_i,out_valid_o,outv,numbers[9]);
	COUNTER #(3) count3(clk_i,rst_i,enable_inv,count_o,in_valid_i,numbers[10]);

	reg [50:0] sum;
	integer j;
	always @ (*) begin
		sum=0;
		for (j=0;j<=10;j=j+1) begin
			sum=sum+numbers[j];
		end
	end
	assign number_o=sum;


endmodule

module RegSet #(parameter BW=12)(
	clk_i,
	rst_i,
	enable_i,
	init_i,
	init_en_i,
	regin_i,
	regout_o,
	number_o
);
	input clk_i,rst_i,enable_i,init_en_i;
	input[BW-1:0] init_i,regin_i;
	output [BW-1:0] regout_o;
	output[50:0] number_o;
	wire [BW-1:0] dffo,dffi;
	wire [50:0] numbers [20:0];
	
	REGP #(BW) dff0(clk_i,rst_i,dffo,dffi,numbers[0]);
	MUX #(BW) mux1(regin_i,regout_o,dffi,enable_i,numbers[1]);
	MUX #(BW) mux2(dffo,init_i,regout_o,init_en_i,numbers[2]);

	reg [50:0] sum;
	integer j;
	always @ (*) begin
		sum=0;
		for (j=0;j<3;j=j+1) begin
			sum=sum+numbers[j];
		end
	end
	assign number_o=sum;


endmodule

module RCA #(parameter BW=2)(
	o_o,
	a_i,
	b_i,
	number_o
);
	input [BW-1:0] a_i,b_i;
	output [BW-1:0] o_o;
	output [50:0] number_o;
	wire [BW:0] carry;
	assign carry[0]=1'b0;
	wire [50:0] numbers [50:0];
	genvar i;
	

	generate 
		for(i=0;i<BW;i=i+1) begin
			FA1 adder(carry[i+1],o_o[i],a_i[i],b_i[i],carry[i],numbers[i]);
		end
	endgenerate

	reg [50:0] sum;
	integer j;
	always @ (*) begin
		sum=0;
		for (j=0;j<BW;j=j+1) begin
			sum=sum+numbers[j];
		end
	end
	assign number_o=sum;
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

module COUNTER#(parameter BW=2)(
	clk_i,
	rst_i,
	din_i,
	dout_o,
	enable_i,
	number_o,
	
);

	input clk_i, din_i,rst_i,enable_i;
	output [BW-1:0] dout_o;
	output [50:0] number_o;
	wire [50:0] numbers [50:0];
	wire [BW-1:0] carry, sumo, sumi;
	wire fadin,gatedin;
	

	genvar i;

	generate
		for (i=1;i<BW;i=i+1) begin
			HA1 ha0(carry[i],sumo[i],sumi[i], carry[i-1],numbers[i]);
			FD2 fdsum0(sumi[i], sumo[i],clk_i, rst_i,numbers[i+BW-1] );
		end
	endgenerate
	
	HA1 ha1(carry[0],sumo[0],sumi[0],fadin,numbers[0]);
	FD2 fdsum1(sumi[0],sumo[0],clk_i,rst_i,numbers[2*BW-1]);
	FD2 dff (fadin,gatedin,clk_i,rst_i,numbers[2*BW]);
	
	AN2 and2(gatedin,din_i,enable_i);
	
	assign dout_o=sumo;
	reg [50:0] sum;
	integer j;
	always @ (*) begin
		sum=0;
		for (j=0;j<=2*BW;j=j+1) begin
			sum=sum+numbers[j];
		end
	end
	assign number_o=sum;

endmodule

module Factor2(
	clk_i,
	rst_i,
	data_i,
	in_valid_i,
	out_valid_o,
	data_o,
	count_o,
	number_o
);

	input [11:0] data_i;
	output [11:0] data_o;
	input clk_i,rst_i,in_valid_i;
	output [3:0] count_o;
	output out_valid_o;
	output [50:0] number_o;
	wire [50:0] numbers [20:0];


	wire [11:0]shiftout,shiftin;
	wire reg0,valid,reg0inv,in_valid_edge;
	IV inv(reg0inv,reg0,numbers[0]);


	assign shiftout={shiftin[11],shiftin[11:1]},reg0=shiftin[0];
	
	SigtoEdge ive(clk_i,rst_i,in_valid_i,in_valid_edge,numbers[1]);
	COUNTER #(4) count2(clk_i,rst_i,reg0inv,count_o,in_valid_i,numbers[2],);
	REGP #(1) dff1(clk_i,rst_i,out_valid_o,reg0,numbers[3]);

	RegSet #(12) regset(clk_i,rst_i,reg0,data_i,in_valid_edge,shiftout,shiftin,numbers[4]);


	assign data_o=shiftin;
	reg [50:0] sum;
	integer j;
	always @ (*) begin
		sum=0;
		for (j=0;j<=4;j=j+1) begin
			sum=sum+numbers[j];
		end
	end
	assign number_o=sum;

endmodule

module SigtoEdge(
	clk_i,
	rst_i,
	signal_i,
	edge_o,
	number_o
);
	input clk_i,rst_i,signal_i;
	output edge_o;
	output [50:0] number_o;

	wire [50:0] numbers [20:0];
	wire signal_pre,signal_pre_inv;

	REGP # (1) dff(clk_i,rst_i,signal_pre,signal_i,numbers[0]);
	IV inv(signal_pre_inv,signal_pre,numbers[1]);
	AN2 and2(edge_o,signal_i,signal_pre_inv,numbers[2]);


	integer j;
	reg[50:0] sum;
	always @(*) begin
		sum = 0;
		for (j=0; j<=2; j=j+1) begin 
			sum = sum + numbers[j];
		end
	end
	assign number_o=sum;

	
endmodule

module MUX#(parameter BW=12)(
	data0_i,
	data1_i,
	data_o,
	ctrl_i,
	number_o
);
	input [BW-1:0] data0_i,data1_i;
	output[BW-1:0] data_o;
	input ctrl_i;
	output [50:0] number_o;
	wire [50:0] numbers [BW:0];

	genvar i;

	for (i=0;i<BW;i=i+1) begin
		MUX21H muxs(data_o[i],data0_i[i],data1_i[i],ctrl_i,numbers[i]);
	end

	reg [50:0] sum;
	integer j;
	always @ (*) begin
		sum=0;
		for (j=0;j<BW;j=j+1) begin
			sum=sum+numbers[j];
		end
	end
	assign number_o=sum;
endmodule
