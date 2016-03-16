module EX_MEMpipe(
	clk, reset,
	WB_IN, M_IN,
	ALU_resultIN, Mem_WDataIN, Reg_WIDIN,
	WB_OUT, M_OUT,
	ALU_resultOUT, Mem_WDataOUT, Reg_WIDOUT
	);
	
	input 	clk, reset;
	input [1:0]	WB_IN;
	input [1:0]	M_IN;
	input [31:00]	ALU_resultIN;
	input [31:00]	Mem_WDataIN;
	input [4:0]	Reg_WIDIN;
	
	output [1:0]	WB_OUT;
	output [1:0]	M_OUT;
	output [31:00]	ALU_resultOUT;
	output [31:00]	Mem_WDataOUT;
	output [4:0]	Reg_WIDOUT;

	reg [1:0]	WB_OUT;
	reg [1:0]	M_OUT;
	reg [31:00]	ALU_resultOUT;
	reg [31:00]	Mem_WDataOUT;
	reg [4:0]	Reg_WIDOUT;

	always @(posedge clk) begin
		if (reset) begin
			WB_OUT		<= 2'b01;
			M_OUT		<= 2'b00;
			ALU_resultOUT	<= 32'b0;
			Mem_WDataOUT	<= 32'b0;
			Reg_WIDOUT	<= 5'b0;
		end
		else begin
			WB_OUT		<= WB_IN;
			M_OUT		<= M_IN;
			ALU_resultOUT	<= ALU_resultIN;
			Mem_WDataOUT	<= Mem_WDataIN;
			Reg_WIDOUT	<= Reg_WIDIN;
		end
	end
	
endmodule
