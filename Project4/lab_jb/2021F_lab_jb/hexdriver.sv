module hexdriver(input logic [3:0] val, output logic [6:0] hex);

	/* your code here */
	
	always @ (val)
	begin 


	case (val)
            0 : hex = 7'b1000000;
            1 : hex = 7'b1111001;
            2 : hex = 7'b0100100;
            3 : hex = 7'b0110000;
            4 : hex = 7'b0011001;
            5 : hex = 7'b0010010;
            6 : hex = 7'b0000010;
            7 : hex = 7'b1111000;
            8 : hex = 7'b0000000;
            9 : hex = 7'b0010000;
	    10 : hex = 7'b0001000;
	    11 : hex = 7'b0000000;
	    12 : hex = 7'b1000110;
	    13 : hex = 7'b1000000;
	    14 : hex = 7'b0000110;
	    15 : hex = 7'b0001110;
            default : hex = 7'b1111111; 
endcase
end 




endmodule
