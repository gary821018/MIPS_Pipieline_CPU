module Mux_2to132bits(in0,in1,out0,sel);
	input	sel;
	input  [31:0] 	in0,in1;
	output [31:0]	out0;

	wire   [31:0]	out0 = (sel)?in1:in0;

endmodule

module Mux_2to18bits(in0,in1,out0,sel);
	input	sel;
	input  [7:0] 	in0,in1;
	output [7:0]	out0;

	wire   [7:0]	out0 = (sel)?in1:in0;
endmodule

module Mux_2to15bits(in0,in1,out0,sel);
	input	sel;
	input	[4:0]	in0,in1;
	output	[4:0]	out0;

	wire   [4:0]	out0 = (sel)?in1:in0;
endmodule

module Mux_4to132bits(in_00,in_01,in_10,in_11,out0,sel);
	input  [1:0]	sel;
	input  [31:0] 	in_00,in_01,in_10,in_11;
	output [31:0]	out0;

	wire   [31:0]	out0 = (sel == 2'b11)?in_11:
			      (sel == 2'b10)?in_10:
			      (sel == 2'b01)?in_01:in_00;

endmodule

module Sign_Extend(in0, out0);
	input [15:00] in0;
	output [31:00] out0;

	wire [31:00] out0;

	assign out0 = { {16{in0[15]}} , in0[15:00] };
endmodule

module Adder_32bits(Src1, Src2, Result);
	input [31:00] Src1;
	input [31:00] Src2;

	output [31:00] Result;

	assign Result = Src1 + Src2;
endmodule

module Compare_32bits(Src1, Src2, equal);
	input [31:00] Src1;
	input [31:00] Src2;
	
	output equal;
	
	assign equal = (Src1==Src2) ? 1'b1 : 1'b0;
endmodule

module Branch(beq, equal, BranchTaken);
	input beq;
	//input Bnq;
	input equal;
	
	output BranchTaken;
	
	assign BranchTaken = beq & equal;
endmodule
