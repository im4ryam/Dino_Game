/*
Name: Maryam Imran and Evan Craft
Project: Dino Game --- counter
*/


module counter (C, bcd);     
	input C;	 // C = fast clock						 
	output [2:0] bcd;           							
	
	parameter m = 26;
	reg [m-1:0] fast_count;
 
	reg[2:0] slow_count;
	
	always @(posedge C)
		if (fast_count > 24'd5000000)
			fast_count <= 0;
		else
			fast_count <= fast_count + 1'b1;   //fast (24 bits) count is +ve edge
		
	always @ (posedge C)
		if (fast_count == 0)
			if (slow_count == 3'h5)
				slow_count <= 3'h0;
			else
				slow_count <= slow_count + 1'b1;
	
	assign bcd = slow_count;
	
	
endmodule
