module Hazard_Detect(ID_EXMEMREAD,IF_IDRs,IF_IDRt,ID_EXRt,
						PC_write,IF_IDWrite,control_muxsig);
	input ID_EXMEMREAD;
	input [4:0] IF_IDRs,IF_IDRt,ID_EXRt;
	output reg PC_write,IF_IDWrite,control_muxsig;
	
	always@(ID_EXMEMREAD or IF_IDRs or IF_IDRt or ID_EXRt) begin
		//check the instruction is load or not, and check if it has hazard
		if( (ID_EXMEMREAD==1)&& ( (ID_EXRt==IF_IDRs)|| (ID_EXRt==IF_IDRt)) )
			begin
				PC_write=1'b0; // means PC hold value
				IF_IDWrite=1'b0; // hold the all value in IF_ID register
				control_muxsig=1'b1; //let mux choose that all control signal be zero
			end
		else
			begin
				PC_write=1'b1;
				IF_IDWrite=1'b1;
				control_muxsig=1'b0;
			end
	end
	
	
endmodule
