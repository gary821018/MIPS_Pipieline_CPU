module ALU(funct,op, shamt, ALU_Src1,ALU_Src2,ALU_Result);
	input 	[5:0] 	funct;
	input 	[4:0]	shamt;
	input	[1:0]	op;
	input 	[31:0] 	ALU_Src1,ALU_Src2;
	output	[31:0] 	ALU_Result;

	`define ADD 4'b0001
	`define SUB 4'b0010
	`define SLT 4'b0011
	`define andr 4'b0100
	`define xorr 4'b0101
	`define orr  4'b0110
	`define sllr 4'b0111
	`define srlr 4'b1000
	`define MUL 4'b1001
	`define notr 4'b1010
	`define SGT 4'b1011
	`define norr 4'b1100

	reg [31:0] func_result;

	wire [31:0] ALU_Result =(op==2'b00)?ALU_Src1+ALU_Src2:
				(op==2'b01)?ALU_Src1-ALU_Src2:func_result;

	always@ (funct or ALU_Src1 or ALU_Src2 or shamt) begin
		case(funct[3:0])
			`ADD:func_result = ALU_Src1+ALU_Src2;
			`SUB:func_result = ALU_Src1-ALU_Src2; //rs-rt
			`SLT:func_result = (ALU_Src1<ALU_Src2)?1:0;
			`andr:func_result = ALU_Src1&ALU_Src2;
			`xorr:func_result = ALU_Src1^ALU_Src2;
			`orr :func_result = ALU_Src1|ALU_Src2;
			`sllr:func_result = ALU_Src2<<shamt;
			`srlr:func_result = ALU_Src2>>shamt;
			`MUL:func_result = ALU_Src1[15:0]*ALU_Src2[15:0];
			`notr:func_result = ~ALU_Src1;
			`SGT:func_result = (ALU_Src1>ALU_Src2)?1:0;
			`norr:func_result = ~(ALU_Src1|ALU_Src2);
			default:func_result = 32'b0;
		endcase
	end
endmodule
