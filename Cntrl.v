// RegDst : determind register write address
// Reg Dst	,	reg_write_addr		, inst
//	0		,	inst[20:16]	(rt)	, lw
//	1		,	inst[15:11]	(rd)	, R_type
//
// ALUSrc : determind alu_src2
// ALUSrc	,	ALU Src2		, inst
//	0		,	register_data2	, R_type, beq
//	1		,	immediate		, lw, st
//
// MemtoReg : determind register write data
// MemtoReg	,	reg_write_data	, inst
// 0		,	alu_result		, R_type
// 1 		,	mem_read_data	, lw

// RegWrite : register write enable
// RegWrite	,	inst
// 0		,	sw, beq
// 1		,	lw, R_type
//
// memory read enable
// MemRead	,	inst
// 0		,	R_type, sw, beq
// 1		,	lw
//
// memory write enable
// MemWrite	,	inst
// 0		,	R_type, lw, beq
// 1		,	sw
//
// determind branch or not
// Branch	,	inst
// 0		,	R_type, lw, beq
// 1		,	beq
//
// for alu_control
// ALU_OP	,	instr	,	alu_do
//	00		,	lw, sw	,	add
//	01		,	beq		,	sub
//	10		,	R_type	, 	determind by function( inst[5:0] )

/* no use
`define RT 1'b0
`define RD 1'b1

`define R_DATA_2	1'b0
`define IMM			1'b1

`define ALU_RESULT		1'b0
`define MEM_READ_DATA	1'b1

`define REG_W_EN	1'b1
`define REG_W_DIS	1'b0

`define MEM_R_EN	1'b1
`define MEM_R_DIS	1'b0

`define MEM_W_EN	1'b1
`define MEM_W_DIS	1'b0

`define ALU_ADD		2'b00
`define ALU_SUB		2'b01
`define ALU_R_TYPE	2'b10
*/

/* control hazard
 *
 * ------------------put in cpu.v-------------------
 * assign PCSrc = (R_DATA1==R_DATA2) & Branch;
 * assign IFID_flush = (R_DATA1==R_DATA2) & Branch;
 * ------------------put in cpu.v-------------------
 */

`define RTYPE		6'b000_000
`define JUMP		6'b000_011
`define BEQ		6'b000_100

`define	ADDI		6'b001_000
`define	SUBI		6'b001_001

`define LW		6'b100_011

`define SW		6'b101_011

`define NOP		6'b111_111

module Cntrl(
	/* input port */
	reset,
	op,
	/* output port */
	RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, ALU_OP,
	Branch, Jump
);
	// instruction op, inst[31:26]
	input [5:0] op;
	input reset;

	
	output 		RegDst;		// register write address by mux
	output 		ALUSrc;		// alu_src2 by mux
	output 		MemtoReg;	// register write data by mux
	output 		RegWrite;	// register write enable
	output 		MemRead;	// memory read enable
	output 		MemWrite;	// memory write enable
	output [1:0] 	ALU_OP;		// alu_op for alu_control
	output 		Branch;		// branch instr
	output 		Jump;		// jump instr
	
	reg 		RegDst;
	reg 		ALUSrc;
	reg 		MemtoReg;
	reg 		RegWrite;
	reg 		MemRead;
	reg 		MemWrite;
	reg [1:0] 	ALU_OP;
	reg 		Branch;
	reg 		Jump;

	always @(op or reset) begin
		if (reset) begin
			RegDst		= 1'b0;
			ALUSrc		= 1'b0;
			MemtoReg	= 1'b0;
			RegWrite	= 1'b0;
			MemRead 	= 1'b0;
			MemWrite	= 1'b0;
			Branch		= 1'b0;
			ALU_OP		= 2'b00;
		end
		else begin
			case(op)
				`RTYPE:
					begin
						RegDst		= 1'b1;
						ALUSrc		= 1'b0;
						MemtoReg	= 1'b0;
						RegWrite	= 1'b1;
						MemRead 	= 1'b0;
						MemWrite	= 1'b0;
						Branch		= 1'b0;
						Jump		= 1'b0;
						// 10 is R_type, determind by funct(instr[5:0])
						ALU_OP		= 2'b10;
					end
				`BEQ:
					begin
						// RegDst don't care bit
						RegDst		= 1'b0;
						ALUSrc		= 1'b0;
						// MemtoReg don't care bit
						MemtoReg	= 1'b0;
						RegWrite	= 1'b0;
						MemRead 	= 1'b0;
						MemWrite	= 1'b0;
						Branch		= 1'b1;
						Jump		= 1'b0;
						// Because
						//    compare regdata1, regdata2 in ID stage,
						//    so 2'b01 sub for ALU_OP is no use at all
						ALU_OP		= 2'b01;
					end
				`JUMP:
					begin
						RegDst		= 1'b0;
						ALUSrc		= 1'b0;
						MemtoReg	= 1'b0;
						RegWrite	= 1'b0;
						MemRead 	= 1'b0;
						MemWrite	= 1'b0;
						Branch		= 1'b0;
						Jump		= 1'b1;
						// no meaning at all,
						// 00 is add
						ALU_OP		= 2'b00;
					end
				`ADDI:
					begin
						RegDst		= 1'b0;
						ALUSrc		= 1'b1;
						MemtoReg	= 1'b0;
						RegWrite	= 1'b1;
						MemRead		= 1'b0;
						MemWrite	= 1'b0;
						Branch		= 1'b0;
						Jump		= 1'b0;
						// 00 is add
						ALU_OP		= 2'b00;
					end
				`SUBI:
					begin
						RegDst		= 1'b0;
						ALUSrc		= 1'b1;
						MemtoReg	= 1'b0;
						RegWrite	= 1'b1;
						MemRead		= 1'b0;
						MemWrite	= 1'b0;
						Branch		= 1'b0;
						Jump		= 1'b0;
						// 00 is add
						ALU_OP		= 2'b01;
					end
				`LW:
					begin
						RegDst		= 1'b0;
						ALUSrc		= 1'b1;
						MemtoReg	= 1'b1;
						RegWrite	= 1'b1;
						MemRead 	= 1'b1;
						MemWrite	= 1'b0;
						Branch		= 1'b0;
						Jump		= 1'b0;
						// 00 is add
						ALU_OP		= 2'b00;
					end
				`SW:
					begin
						// RegDst don't care bit
						RegDst		= 1'b0;
						ALUSrc		= 1'b1;
						// MemtoReg don't care bit
						MemtoReg	= 1'b0;
						RegWrite	= 1'b0;
						MemRead 	= 1'b0;
						MemWrite	= 1'b1;
						Branch		= 1'b0;
						Jump		= 1'b0;
						// 00 is add
						ALU_OP		= 2'b00;
					end
				`NOP:
					begin
						RegDst		= 1'b0;
						ALUSrc		= 1'b0;
						MemtoReg	= 1'b0;
						RegWrite	= 1'b0;
						MemRead		= 1'b0;
						MemWrite	= 1'b0;
						Branch		= 1'b0;
						Jump		= 1'b0;
						// 00 is add
						ALU_OP		= 2'b00;
					end
				default:	// default is nop
					begin
						RegDst		= 1'b0;
						ALUSrc		= 1'b0;
						MemtoReg	= 1'b0;
						RegWrite	= 1'b0;
						MemRead		= 1'b0;
						MemWrite	= 1'b0;
						Branch		= 1'b0;
						Jump		= 1'b0;
						ALU_OP		= 2'b00;
					end
			endcase	//case
		end // else
	end	// always
endmodule
