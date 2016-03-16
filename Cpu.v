`include "PC.v"
//`include "IM.v"
`include "Cntrl.v"
`include "Reg.v"
`include "ALU.v"
//`include "DM.v"
`include "Hazard_Detect.v"
`include "Forwarding.v"
`include "IF_ID_pipe.v"
`include "ID_EX_pipe.v"
`include "EX_MEM_pipe.v"
`include "MEM_WB_pipe.v"
`include "Small_Components.v"
`include "forwarding_rs.v"
`include "forwarding_rt.v"

module Cpu( reset, clk, instr_IF, PCOut_IF, Mem_RDataMEM, M_MEM, ALU_resultMEM, Mem_WDataMEM );

input reset;
input clk;
input [31:00]	instr_IF;
output [31:00]	PCOut_IF;
output [1:0]	M_MEM;
output [31:00]	ALU_resultMEM;
output [31:00]	Mem_WDataMEM;
input [31:00]	Mem_RDataMEM;

/*---------------------------IF STAGE output port--------------------------*/
//wire [31:00]	PCOut_IF;
//wire [31:00]	instr_IF;
wire [31:00]	PCOut1_IF;
wire [31:00]	PCNext1_IF;
wire [31:00]	PCNext2_IF;
/*---------------------------IF STAGE output port--------------------------*/


/*-------------------------IF_ID pipe output port--------------------------*/
wire [31:00]	PCOut1_ID;
wire [31:00]	instr_ID;
/*-------------------------IF_ID pipe output port--------------------------*/


/*---------------------------ID STAGE output port--------------------------*/
wire [31:00]	branch_immID;
wire [31:00]	PCOut2_ID;
wire 		RegDst_ID;
wire		ALUSrc_ID;
wire		MemtoReg_ID;
wire		RegWrite_ID;
wire		MemRead_ID;
wire		MemWrite_ID;
wire [01:00]	ALU_OPID;
wire		Branch_ID;
wire		Jump_ID;
wire [07:00]	cntrl_resultID;
wire [31:00]	imm_signextendID;
wire [31:00]	Reg_RData1ID;
wire [31:00]	Reg_RData2ID;
wire		equal_ID;
wire		PCSrc_ID;
wire		IF_IDFlushID;
wire [31:00]	Jump_addressID;

wire[31:0] Reg1data_ID;
wire[31:0] Reg2data_ID;
/*---------------------------ID STAGE output port--------------------------*/


/*-------------------------ID_EX pipe output port--------------------------*/
wire [1:0]	WB_EX;
wire [1:0]	M_EX;
wire [3:0]	EX_EX;
wire [31:00]	Reg_RData1EX;
wire [31:00]	Reg_RData2EX;
wire [31:00]	imm_signextendEX;
wire [4:0]	RS_EX;
wire [4:0]	RT_EX;
wire [4:0]	RD_EX;
wire [4:0]	shamt;
/*-------------------------ID_EX pipe output port--------------------------*/


/*---------------------------EX STAGE output port--------------------------*/
wire [4:0]	Reg_WIDEX;
wire [31:00]	ALU_src1EX;
wire [31:00]	ALUsrc2_1EX;
wire [31:00]	ALUsrc2_2EX;
wire [31:00]	ALURESULT_EX;	//ALU_RESULT_EX
/*---------------------------EX STAGE output port--------------------------*/


/*------------------------EX_MEM pipe output port--------------------------*/
wire [1:0]	WB_MEM;
//wire [1:0]	M_MEM;
//wire [31:00]	ALU_resultMEM;
//wire [31:00]	Mem_WDataMEM;
wire [4:0]	Reg_WIDMEM;
/*------------------------EX_MEM pipe output port--------------------------*/


/*---------------------------MEM STAGE output port-------------------------*/
//wire [31:00]	Mem_RDataMEM;
/*---------------------------MEM STAGE output port-------------------------*/


/*------------------------MEM_WB pipe output port--------------------------*/
wire [1:0]	WB_WB;
wire [31:00]	Mem_RDataWB;
wire [31:00]	ALU_resultWB;
wire [4:0]	Reg_WIDWB;
/*------------------------MEM_WB pipe output port--------------------------*/


/*---------------------------------WB STAGE--------------------------------*/
wire [31:00]	Reg_WDataWB;
/*---------------------------------WB STAGE--------------------------------*/


/*----------------------------------Hazard---------------------------------*/
wire		PCWrite_HZ;
wire		IF_IDWriteHZ;
wire		control_muxsigHZ;
/*----------------------------------Hazard---------------------------------*/


/*----------------------------------Forward--------------------------------*/
wire [1:0]	ForwardA_FW;
wire [1:0]	ForwardB_FW;
/*----------------------------------Forward--------------------------------*/


// PCSrc_ID is 1 mean
// 		in ID stage
//		instr is BEQ and RS equal to RT
// 		than branch taken
// Jump_ID is 1 mean jump instr taken
// 
// if branch taken or jump taken
// we need to a nop in ID_STAGE,
// beause IF stage should be update by new pc_address,
// the old pc_address(pc+4) should be disgarded,
//
// so we flush the if_id_pipeline by IF_IDFlushID (insert 'nop')
assign IF_IDFlushID = PCSrc_ID | Jump_ID;

// Jump address is  PC+4[31:26] : jump_immediate (26bits)
assign Jump_addressID = { PCOut1_IF[31:26] ,instr_ID[25:00]};

/*---------------------------------IF STAGE--------------------------------*/
PC pc(
	//-------------------input port--------------------
	.clk(clk), .reset(reset),
	.PCWrite(PCWrite_HZ), .PCIn(PCNext2_IF),
	//-------------------output port-------------------
	.PCOut(PCOut_IF)
);
/*
IM im(
	//-------------------input port--------------------
	.clk(clk),
	.pc(PCOut_IF),
	//-------------------output port-------------------
	.ir_out(instr_IF)
);
*/
Adder_32bits pc_adder1(
	//-------------------input port--------------------
	.Src1(PCOut_IF), .Src2(32'b01),
	//-------------------output port-------------------
	.Result(PCOut1_IF)
);

Mux_2to132bits pc_mux1(
	//-------------------input port--------------------
	.sel(PCSrc_ID), .in0(PCOut1_IF), .in1(PCOut2_ID),
	//-------------------output port-------------------
	.out0(PCNext1_IF)
);

Mux_2to132bits pc_mux2(
	//-------------------input port--------------------
	.sel(Jump_ID), .in0(PCNext1_IF), .in1(Jump_addressID),
	//-------------------output port-------------------
	.out0(PCNext2_IF)
);
/*---------------------------------IF STAGE--------------------------------*/


IF_IDpipe if_idpipe(
	//-------------------input port--------------------
	.clk(clk), .reset(reset),
	.IF_IDwrite(IF_IDWriteHZ), .IF_IDFlush(IF_IDFlushID),
	.PC_IN(PCOut1_IF), .instr_IN(instr_IF),
	//-------------------output port-------------------
	.PC_OUT(PCOut1_ID), .instr_OUT(instr_ID)
);


/*---------------------------------ID STAGE--------------------------------*/
Sign_Extend sign_extend(
	//-------------------input port--------------------
	.in0(instr_ID[15:00]),
	//-------------------output port-------------------
	.out0(imm_signextendID)
);

Adder_32bits pc_adderbranch(
	//-------------------input port--------------------
	.Src1(PCOut1_ID), .Src2(imm_signextendID),
	//-------------------output port-------------------
	.Result(PCOut2_ID)
);

Cntrl cntrl(
	//-------------------input port--------------------
	.reset(reset), .op(instr_ID[31:26]),
	//-------------------output port-------------------
	.RegDst(RegDst_ID), .ALUSrc(ALUSrc_ID), .MemtoReg(MemtoReg_ID),
	.RegWrite(RegWrite_ID), .MemRead(MemRead_ID), .MemWrite(MemWrite_ID),
	.ALU_OP(ALU_OPID),
	.Branch(Branch_ID), .Jump(Jump_ID)
);

Mux_2to18bits cntrl_sigmux(
	//-------------------input port--------------------
	.sel(control_muxsigHZ),
	.in0({
		RegWrite_ID , MemtoReg_ID ,
		MemRead_ID, MemWrite_ID,
		RegDst_ID, ALU_OPID, ALUSrc_ID
	}),// 8 bits
	.in1(8'b0),
	//-------------------output port-------------------
	.out0(cntrl_resultID)
);

Reg regFile(
	//-------------------input port--------------------
	.clk(clk), .reset(reset),
	.RS_ID(instr_ID[25:21]), .RT_ID(instr_ID[20:16]),
	.Reg_Write(WB_WB[1]), .Reg_WID(Reg_WIDWB), .Reg_WData(Reg_WDataWB),// connect by WB pipeline
	//-------------------output port-------------------
	.Reg_RData1(Reg_RData1ID), .Reg_RData2(Reg_RData2ID)
);

//module forwarding_rs(branch,r1_data,alu_result,rs,r_writeexe,wr_addrexe,r1_out,
					 //r_writemem,wr_addrmem,wrdata_mem);
forwarding_rs forwarding_rs1(.branch(Branch_ID), .r1_data(Reg_RData1ID), .alu_result(ALURESULT_EX),
							 .rs(instr_ID[25:21]), .r_writeexe(WB_EX[1]), .wr_addrexe(Reg_WIDEX),
							 .r1_out(Reg1data_ID), .r_writemem(WB_MEM[1]), .wr_addrmem(Reg_WIDMEM),
							 .wrdata_mem(ALU_resultMEM));
							 
//module forwarding_rt(branch,r2_data,alu_result,rt,r_writeexe,wr_addrexe,r2_out,
	//				 r_writemem,wr_addrmem,wrdata_mem);
forwarding_rt forwarding_rt1(.branch(Branch_ID), .r2_data(Reg_RData2ID), .alu_result(ALURESULT_EX),
							 .rt(instr_ID[20:16]), .r_writeexe(WB_EX[1]), .wr_addrexe(Reg_WIDEX),
							 .r2_out(Reg2data_ID), .r_writemem(WB_MEM[1]), .wr_addrmem(Reg_WIDMEM),
							 .wrdata_mem(ALU_resultMEM));


Compare_32bits compare_regdata1regdata2(
	//-------------------input port--------------------
	.Src1(Reg1data_ID), .Src2(Reg2data_ID),
	//-------------------output port-------------------
	.equal(equal_ID)
);

Branch branch(
	//-------------------input port--------------------
	.beq(Branch_ID), .equal(equal_ID),
	//-------------------output port-------------------
	.BranchTaken(PCSrc_ID)
);
/*---------------------------------ID STAGE--------------------------------*/
			
			
ID_EXpipe id_expipe(
	//-------------------input port--------------------
	.clk(clk), .reset(reset),
	.WB_IN( { cntrl_resultID[7] , cntrl_resultID[6] } ),
	.M_IN( { cntrl_resultID[5] , cntrl_resultID[4] } ),
	.EX_IN( { cntrl_resultID[3] , cntrl_resultID[2:1] , cntrl_resultID[0] } ),
	.Reg_RData1IN(Reg1data_ID), .Reg_RData2IN(Reg2data_ID),
	.sign_extendIN(imm_signextendID),
	.RS_IN(instr_ID[25:21]), .RT_IN(instr_ID[20:16]), .RD_IN(instr_ID[15:11]),
	//-------------------output port-------------------
	.WB_OUT(WB_EX), .M_OUT(M_EX), .EX_OUT(EX_EX),
	.Reg_RData1OUT(Reg_RData1EX), .Reg_RData2OUT(Reg_RData2EX),
	.sign_extendOUT(imm_signextendEX),
	.RS_OUT(RS_EX), .RT_OUT(RT_EX), .RD_OUT(RD_EX), .shamt(shamt)
);

					
/*---------------------------------EX STAGE--------------------------------*/
Mux_2to15bits reg_dstidmux(
	//-------------------input port--------------------
	.sel(EX_EX[3]), .in0(RT_EX), .in1(RD_EX),
	//-------------------output port-------------------
	.out0(Reg_WIDEX)
);

Mux_4to132bits mux_forwardA(
	//-------------------input port--------------------
	.sel(ForwardA_FW),
	.in_00(Reg_RData1EX),
	.in_01(Reg_WDataWB),
	.in_10(ALU_resultMEM),
	.in_11(32'b0),
	//-------------------output port-------------------
	.out0(ALU_src1EX)
);

Mux_4to132bits mux_forwardB(
	//-------------------input port--------------------
	.sel(ForwardB_FW),
	.in_00(Reg_RData2EX),
	.in_01(Reg_WDataWB),
	.in_10(ALU_resultMEM),
	.in_11(32'b0),
	//-------------------output port-------------------
	.out0(ALUsrc2_1EX)
);

Mux_2to132bits alu_src2mux1(
	//-------------------input port--------------------
	.sel(EX_EX[0]), .in0(ALUsrc2_1EX), .in1(imm_signextendEX),
	//-------------------output port-------------------
	.out0(ALUsrc2_2EX)
);
					
ALU alu(
	//-------------------input port--------------------
	.op(EX_EX[2:1]), .funct(imm_signextendEX[5:0]), .shamt(shamt),
	.ALU_Src1(ALU_src1EX), .ALU_Src2(ALUsrc2_2EX),
	//-------------------output port-------------------
	.ALU_Result(ALURESULT_EX)
);
/*---------------------------------EX STAGE--------------------------------*/


EX_MEMpipe ex_mempipe(
	//-------------------input port--------------------
	.clk(clk), .reset(reset),
	.WB_IN(WB_EX), .M_IN(M_EX),
	.ALU_resultIN(ALURESULT_EX), .Mem_WDataIN(ALUsrc2_1EX), .Reg_WIDIN(Reg_WIDEX),
	//-------------------output port-------------------
	.WB_OUT(WB_MEM), .M_OUT(M_MEM),
	.ALU_resultOUT(ALU_resultMEM), .Mem_WDataOUT(Mem_WDataMEM), .Reg_WIDOUT(Reg_WIDMEM)
);


/*--------------------------------MEM STAGE--------------------------------*/
/*
DM dm(
	//-------------------input port--------------------
	.clk(clk),
	.Mem_Write(M_MEM[0]), .Mem_Read(M_MEM[1]),
	.Mem_ID(ALU_resultMEM), .Mem_WData(Mem_WDataMEM),
	//-------------------output port-------------------
	.Mem_RData(Mem_RDataMEM)
);
*/
/*--------------------------------MEM STAGE--------------------------------*/
	
	
MEM_WBpipe mem_wbpipe(
	//-------------------input port--------------------
	.clk(clk), .reset(reset),
	.WB_IN(WB_MEM),
	.Mem_RDataIN(Mem_RDataMEM), .ALU_resultIN(ALU_resultMEM), .Reg_WIDIN(Reg_WIDMEM),
	//-------------------output port-------------------
	.WB_OUT(WB_WB),
	.Mem_RDataOUT(Mem_RDataWB), .ALU_resultOUT(ALU_resultWB), .Reg_WIDOUT(Reg_WIDWB)
);


/*---------------------------------WB STAGE--------------------------------*/
Mux_2to132bits reg_dstdatasrc(
	//-------------------input port--------------------
	.sel(WB_WB[0]), .in0(ALU_resultWB), .in1(Mem_RDataWB),
	//-------------------output port-------------------
	.out0(Reg_WDataWB)
);
/*---------------------------------WB STAGE--------------------------------*/


/*----------------------------------Hazard---------------------------------*/
Hazard_Detect hazard_detect(
	//-------------------input port--------------------
	.ID_EXMEMREAD(M_EX[1]), .ID_EXRt(RT_EX),
	.IF_IDRs(instr_ID[25:21]), .IF_IDRt(instr_ID[20:16]),
	//-------------------output port-------------------
	.PC_write(PCWrite_HZ), .IF_IDWrite(IF_IDWriteHZ), .control_muxsig(control_muxsigHZ)
);
/*----------------------------------Hazard---------------------------------*/


/*----------------------------------Forward--------------------------------*/
Forwarding forwarding(
	//-------------------input port--------------------
	.ID_EXRs(RS_EX), .ID_EXRt(RT_EX),
	.EX_MEMRd(Reg_WIDMEM), .MEM_WBRd(Reg_WIDWB),
	.EX_MEMRegWrite(WB_MEM[1]), .MEM_WBRegwrite(WB_WB[1]),
	//-------------------output port-------------------
	.ForwardA(ForwardA_FW), .ForwardB(ForwardB_FW)
);
/*----------------------------------Forward--------------------------------*/
endmodule
