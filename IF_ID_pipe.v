module IF_IDpipe(
	clk, reset,
	IF_IDwrite, IF_IDFlush,
	PC_IN, instr_IN,
	/* output port*/
	PC_OUT, instr_OUT
);

	input		clk;
	input		reset;
	input		IF_IDwrite;
	input		IF_IDFlush;
	input [31:0]	PC_IN;		//pc from IF
	input [31:0]	instr_IN;	//ir from IF

	output [31:0]	PC_OUT;		//pc to   ID
	output [31:0]	instr_OUT;	//ir to   ID

	reg [31:0]	PC_OUT;
	reg [31:0]	instr_OUT;

	//for PC and IR
	// if reset is 1, set 0 to pc_id, ir_id
	//
	// if ifid_write is 1,
	//      mean that no data hazards, and change by IF stage
	// 
	// if ifid_write is 0,
	// 	mean that data hazards, and keep data with no change
	always@(posedge clk) begin
		if (reset) begin
			PC_OUT		<= 32'b0;
			instr_OUT	<= 32'b0;
		end
		else if (IF_IDFlush) begin
			PC_OUT		<= 32'b0;
			instr_OUT	<= 32'b111_111_00000_00000_0000000000000000;
		end
		else if (IF_IDwrite) begin
			PC_OUT		<= PC_IN;
			instr_OUT	<= instr_IN;
		end
		else begin
			PC_OUT		<= PC_OUT;
			instr_OUT	<= instr_OUT;
		end
	end
endmodule
