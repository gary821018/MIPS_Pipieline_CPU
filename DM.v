module DM(clk, Mem_ID, Mem_Write, Mem_Read, Mem_WData, Mem_RData);

	input 		clk;
	input 	[31:0] 	Mem_ID;
	input 		Mem_Write, Mem_Read;
	input 	[31:0] 	Mem_WData;
	output 	[31:0] 	Mem_RData;

	reg 	[31:0] 	DataMemory [63:0];

	//insert for checking TB
	wire	[31:0]	DM0 = DataMemory[0];
	wire	[31:0]	DM1 = DataMemory[1];
	wire	[31:0]	DM2 = DataMemory[2];
	wire	[31:0]	DM3 = DataMemory[3];
	wire	[31:0]	DM4 = DataMemory[4];
	wire	[31:0]	DM5 = DataMemory[5];
	wire	[31:0]	DM6 = DataMemory[6];
	wire	[31:0]	DM7 = DataMemory[7];
	wire	[31:0]	DM8 = DataMemory[8];
	wire	[31:0]	DM9 = DataMemory[9];
	wire	[31:0]	DM10 = DataMemory[10];
	wire	[31:0]	DM43 = DataMemory[43];
	wire	[31:0]	DM44 = DataMemory[44];
	wire	[31:0]	DM45 = DataMemory[45];
	wire	[31:0]	DM46 = DataMemory[46];
	wire	[31:0]	DM47 = DataMemory[47];
	wire	[31:0]	DM48 = DataMemory[48];
	
	assign Mem_RData =(Mem_Read) ? DataMemory[ Mem_ID ] : 32'b0;
		
	always@(negedge clk) begin
		DataMemory[ Mem_ID ] <= (Mem_Write) ?  Mem_WData : DataMemory[ Mem_ID ];
	end
	
endmodule
