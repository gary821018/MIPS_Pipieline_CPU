module IM(pc, ir_out);

	input 	[31:00] pc;
	output 	[31:00] ir_out;
	
	
	reg 	[31:0] 	InstrMemory [16777300:0];

	
	assign	ir_out = InstrMemory[pc];
endmodule
