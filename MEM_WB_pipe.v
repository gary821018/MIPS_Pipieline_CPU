module MEM_WBpipe(
	clk, reset,
	WB_IN,
	Mem_RDataIN, ALU_resultIN, Reg_WIDIN,
	WB_OUT,
	Mem_RDataOUT, ALU_resultOUT, Reg_WIDOUT
);

	input 	clk, reset;
	input	[1:0]	WB_IN;		// WB from MEM
	input	[31:00]	Mem_RDataIN;	// Mem Read Data from MEM
	input	[31:00]	ALU_resultIN;	// ALU_result_IN from MEM
	input	[4:0]	Reg_WIDIN;	// Register Write Data from MEM

	output	[1:0]	WB_OUT;			// WB to WB
	output	[31:00]	Mem_RDataOUT;	// Mem Read Data to WB
	output	[31:00]	ALU_resultOUT;	// ALU_result_IN to WB
	output	[4:00]	Reg_WIDOUT;	// Register Write Data to WB

	reg	[1:0]	WB_OUT;			
	reg	[31:00]	Mem_RDataOUT;	
	reg	[31:00]	ALU_resultOUT;	
	reg	[4:0]	Reg_WIDOUT;	
	
	always@(posedge clk) begin
		if(reset) begin
			WB_OUT		<= 2'b00;
			Mem_RDataOUT	<= 32'b0;
			ALU_resultOUT	<= 32'b0;
			Reg_WIDOUT	<= 5'b0;
		end
		else begin
			WB_OUT		<= WB_IN;
			Mem_RDataOUT	<= Mem_RDataIN;
			ALU_resultOUT	<= ALU_resultIN;
			Reg_WIDOUT	<= Reg_WIDIN;
		end
	end
endmodule
