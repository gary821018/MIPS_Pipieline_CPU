module ID_EXpipe(
	clk, reset,
	WB_IN, M_IN, EX_IN,
	Reg_RData1IN, Reg_RData2IN,
	sign_extendIN,
	RS_IN, RT_IN, RD_IN,
	WB_OUT, M_OUT, EX_OUT,
	Reg_RData1OUT, Reg_RData2OUT,
	sign_extendOUT,
	RS_OUT, RT_OUT, RD_OUT, shamt);
	
	input 	clk, reset;
	input [1:0]	WB_IN;
	input [1:0]	M_IN;
	input [3:0]	EX_IN;
	input [31:0]	Reg_RData1IN;
	input [31:0]	Reg_RData2IN;
	input [31:0]	sign_extendIN;
	input [4:0]	RS_IN;
	input [4:0]	RT_IN;
	input [4:0]	RD_IN;
	
	output [1:0]	WB_OUT;
	output [1:0]	M_OUT;
	output [3:0]	EX_OUT;
	output [31:0]	Reg_RData1OUT;
	output [31:0]	Reg_RData2OUT;
	output [31:0]	sign_extendOUT;
	output [4:0]	RS_OUT;
	output [4:0]	RT_OUT;
	output [4:0]	RD_OUT, shamt;
	
	reg [1:0]	WB_OUT;
	reg [1:0]	M_OUT;
	reg [3:0]	EX_OUT;
	reg [31:0]	Reg_RData1OUT;
	reg [31:0]	Reg_RData2OUT;
	reg [31:0]	sign_extendOUT;
	reg [4:0]	RS_OUT;
	reg [4:0]	RT_OUT;
	reg [4:0]	RD_OUT, shamt;

	always @(posedge clk) begin
		if (reset) begin
			WB_OUT		<= 2'b01;
			M_OUT		<= 2'b00;
			EX_OUT		<= 4'b0000;
			Reg_RData1OUT	<= 32'b0;
			Reg_RData2OUT	<= 32'b0;
			sign_extendOUT	<= 32'b0;
			shamt		<= 5'b0;
			RS_OUT		<= 5'b0;
			RT_OUT		<= 5'b0;
			RD_OUT		<= 5'b0;
		end
		else begin
			WB_OUT		<= WB_IN;
			M_OUT		<= M_IN;
			EX_OUT		<= EX_IN;
			Reg_RData1OUT	<= Reg_RData1IN;
			Reg_RData2OUT	<= Reg_RData2IN;
			sign_extendOUT	<= sign_extendIN;
			shamt		<= sign_extendIN[10:6];
			RS_OUT		<= RS_IN;
			RT_OUT		<= RT_IN;
			RD_OUT		<= RD_IN;
		end
	end
endmodule
