module forwarding_rs(branch,r1_data,alu_result,rs,r_writeexe,wr_addrexe,r1_out,
					 r_writemem,wr_addrmem,wrdata_mem);
	
	input branch,r_writeexe,r_writemem;
	input [31:0] r1_data,alu_result,wrdata_mem;
	input [4:0] rs,wr_addrexe,wr_addrmem;
	
	output reg [31:0] r1_out;
	
	always@(branch or rs or wr_addrexe or r_writeexe or r1_data or alu_result or r_writemem or wr_addrmem or wrdata_mem)
	begin
		if (branch && (rs==wr_addrexe) && r_writeexe)
			r1_out=alu_result;
		else if(branch &&(rs==wr_addrmem)&& r_writemem)
			r1_out=wrdata_mem;
		else
			r1_out=r1_data;
	end
	
endmodule
	
