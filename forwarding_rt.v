module forwarding_rt(branch,r2_data,alu_result,rt,r_writeexe,wr_addrexe,r2_out,
					 r_writemem,wr_addrmem,wrdata_mem);
	
	input branch,r_writeexe,r_writemem;
	input [31:0] r2_data,alu_result,wrdata_mem;
	input [4:0] rt,wr_addrexe,wr_addrmem;
	
	output reg [31:0] r2_out;
	
	always@(branch or rt or wr_addrexe or alu_result or r_writeexe or r2_data or wr_addrmem or r_writemem or wrdata_mem)
	begin
		if(branch && (rt==wr_addrexe) && r_writeexe)
			r2_out=alu_result;
		else if(branch &&(rt==wr_addrmem)&& r_writemem)
			r2_out=wrdata_mem;
		else
			r2_out=r2_data;
	end
	
endmodule
	
