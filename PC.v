module PC(clk,reset,PCWrite,PCIn,PCOut);
	input 		clk,reset;
	input 		PCWrite;
	input  [31:0] 	PCIn;

	output [31:0] 	PCOut;

	reg    [31:0]	PCOut;
	reg		PCWrite_out;
	reg    [31:0] 	PCIn_out;	

	always@(posedge clk)begin
		if(reset)
			PCOut<=0;

		else begin
			if(PCWrite_out)
				PCOut<=PCIn_out;
			else
				PCOut<=PCOut;
		end
	end

	always@(negedge clk)begin
		if(reset)begin
			PCIn_out<=0;
			PCWrite_out<=1;
		end
		else begin
			PCIn_out<=PCIn;
			PCWrite_out <= PCWrite;
		end
	end
endmodule
