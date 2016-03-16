module Forwarding(EX_MEMRd,MEM_WBRd,ID_EXRs,ID_EXRt,
				  EX_MEMRegWrite,MEM_WBRegwrite,
				  ForwardA,ForwardB);
	input [4:0] EX_MEMRd,MEM_WBRd,ID_EXRs,ID_EXRt;
	input EX_MEMRegWrite,MEM_WBRegwrite;
	output reg [1:0] ForwardA,ForwardB;
	
	always@(*) begin
		/*
		EX hazard:check whether the instruction need to write back or not,
		and the dst can't be r0
		*/
		if( (EX_MEMRegWrite==1) && (EX_MEMRd!=5'b0) && (EX_MEMRd==ID_EXRs) )
			ForwardA=2'b10;
		//MEM hazard: should consider more, if EX_MEM_Rd==ID_EX_Rs, we should not let ForwardA=01
		else if( (MEM_WBRegwrite==1) && (MEM_WBRd!=6'b0) 
				  &&(EX_MEMRd!=ID_EXRs) &&(MEM_WBRd==ID_EXRs)) 
			ForwardA=2'b01;
		else 
			ForwardA=2'b00; //normal situation
		
		//same as ForwardA's condition
		if( (EX_MEMRegWrite==1) && (EX_MEMRd!=5'b0) && (EX_MEMRd==ID_EXRt) )
			ForwardB=2'b10;
		else if( (MEM_WBRegwrite==1) &&(MEM_WBRd!=6'b0) 
				  && (EX_MEMRd!=ID_EXRt) && (MEM_WBRd==ID_EXRt))
			ForwardB=2'b01;
		else
			ForwardB=2'b00;
			
	
	end
endmodule
