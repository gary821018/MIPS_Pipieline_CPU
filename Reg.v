module Reg(clk, reset ,RS_ID, RT_ID, Reg_WID, Reg_Write, Reg_WData, Reg_RData1, Reg_RData2);

	input 		clk,reset;
	input 	[4:0] 	RS_ID,	//ir[25:21]  
			RT_ID, 	//ir[20:16]
			Reg_WID;
	input 		Reg_Write;
	input 	[31:0] 	Reg_WData;
	
	output 	[31:0] 	Reg_RData1;
	output 	[31:0] 	Reg_RData2;
	
	reg	[31:0] 	RegisterR [15:0];
	
	assign Reg_RData1 = (RS_ID==Reg_WID) ? Reg_WData : RegisterR[ RS_ID ];
	assign Reg_RData2 = (RT_ID==Reg_WID) ? Reg_WData : RegisterR[ RT_ID ];

	//insert for checking TB
	wire	[31:0]	RM0 = RegisterR[0];
	wire	[31:0]	RM1 = RegisterR[1];
	wire	[31:0]	RM2 = RegisterR[2];
	wire	[31:0]	RM3 = RegisterR[3];
	wire	[31:0]	RM4 = RegisterR[4];
	wire	[31:0]	RM5 = RegisterR[5];
	wire	[31:0]	RM6 = RegisterR[6];
	wire	[31:0]	RM7 = RegisterR[7];
	wire	[31:0]	RM8 = RegisterR[8];
	wire	[31:0]	RM9 = RegisterR[9];
	wire	[31:0]	RM10 = RegisterR[10];
	wire	[31:0]	RM11 = RegisterR[11];
	wire	[31:0]	RM12 = RegisterR[12];
	wire	[31:0]	RM13 = RegisterR[13];
	wire	[31:0]	RM14 = RegisterR[14];
	wire	[31:0]	RM15 = RegisterR[15];
	
	always@(negedge clk or posedge reset) begin
		if(reset)
			RegisterR[0]<=32'b0;
		else
			RegisterR[ Reg_WID ] <=(Reg_Write)? Reg_WData : RegisterR[ Reg_WID ];
	end

endmodule
