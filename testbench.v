`timescale 1ns/10ps
`include "IM.v"
`include "DM.v"
`ifdef syn
	`include "Cpu_syn.v"	
	`include "tsmc18.v"
`else
	`include "Cpu.v"
`endif

module testbench;
	
	reg clk,reset;
	
	wire [31:0] pc,ir_out;
	wire [31:0] Mem_ID,Mem_WData,Mem_RData;
	wire Mem_Write,Mem_Read;
	
	
	initial 
	begin
		clk=0; 
		forever #9 clk=~clk;  // 5 15 25.... posdege clk
	end  
	
//module IM(pc, ir_out);
//module DM(clk, Mem_ID, Mem_Write, Mem_Read, Mem_WData, Mem_RData);
//module cpu( reset, clk, instr_IF, PCOut_IF, Mem_RDataMEM, M_MEM, ALU_resultMEM, Mem_WDataMEM );

IM im (.pc(pc), .ir_out(ir_out) );
DM dm (.clk(clk), .Mem_ID(Mem_ID), .Mem_Write(Mem_Write), .Mem_Read(Mem_Read),
	   .Mem_WData(Mem_WData), .Mem_RData(Mem_RData));
Cpu cpu1(.reset(reset), .clk(clk), .instr_IF(ir_out), .PCOut_IF(pc), 
		 .Mem_RDataMEM(Mem_RData), .M_MEM({Mem_Read,Mem_Write}), 
		 .ALU_resultMEM(Mem_ID), .Mem_WDataMEM(Mem_WData) );
		 
	integer i;	 
	initial begin
		$readmemb("DM.prog",dm.DataMemory);
		$readmemb("Test.prog",im.InstrMemory);
		#3 reset=1;
		#13 reset=0;  // #16
	end
	
	initial begin
		#40000 $finish;
	end
	


	`ifdef syn
		initial begin
			$sdf_annotate("Cpu_syn.sdf",cpu1);
			$fsdbDumpfile("PCPU_syn.fsdb");
			$fsdbDumpvars;
		end
	`else
		initial begin
			$fsdbDumpfile("PCPU.fsdb");
			$fsdbDumpvars;
		end
/*
		initial begin

		$monitor($time,"reset=%b,pc_out=%b,ir_out=%b,ir_regout=%b,rs=%b,alu=%b,mem_data=%b,reg[1]=%b,backdata=%b,wr_addr=%b,reg_wr=%b,reg[2]=%b,reg[3]=%b,reg[4]=%b,reg[5]=%b,reg[6]=%b,reg[7]=%b,reg[8]=%b,reg[9]=%b,mem[7]=%b,reg[10]=%b,reg[11]=%b,reg[12]=%b,reg[13]=%b,reg[14]=%b,reg[15]=%b,control=%b",
			reset, pc, ir_out,
			cpu1.if_id_pipe.instr_OUT,cpu1.id_ex_pipe.Reg_RData1_OUT,cpu1.alu.ALU_Result,
			Mem_RData,cpu1.regFile.RegisterR[1], cpu1.reg_dst_data_src.o,
			cpu1.mem_wb_pipe.Reg_WID_OUT,cpu1.mem_wb_pipe.WB_OUT[1],cpu1.regFile.RegisterR[2],
			cpu1.regFile.RegisterR[3],cpu1.regFile.RegisterR[4],cpu1.regFile.RegisterR[5],
			cpu1.regFile.RegisterR[6],cpu1.regFile.RegisterR[7],cpu1.regFile.RegisterR[8],
			cpu1.regFile.RegisterR[9],dm.DataMemory[7],cpu1.regFile.RegisterR[10],
			cpu1.regFile.RegisterR[11],cpu1.regFile.RegisterR[12],cpu1.regFile.RegisterR[13],
			cpu1.regFile.RegisterR[14],cpu1.regFile.RegisterR[15],cpu1.cntrl_resultID);
	end
*/
	`endif
	
endmodule
