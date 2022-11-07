/* Copyright 2020 Jason Bakos, Philip Conrad, Charles Daniels */

/* Top-level module for CSCE611 RISC-V CPU, for running under simulation.  In
 * this case, the I/Os and clock are driven by the simulator. */

module simtop;

	logic clk;
	logic [6:0] HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7;
	logic [17:0] SW;

	top dut
	(
		//////////// CLOCK //////////
		.CLOCK_50(clk),
		.CLOCK2_50(),
	        .CLOCK3_50(),

		//////////// LED //////////
		.LEDG(),
		.LEDR(),

		//////////// KEY //////////
		.KEY(),

		//////////// SW //////////
		.SW(SW),

		//////////// SEG7 //////////
		.HEX0(HEX0),
		.HEX1(HEX1),
		.HEX2(HEX2),
		.HEX3(HEX3),
		.HEX4(HEX4),
		.HEX5(HEX5),
		.HEX6(HEX6),
		.HEX7(HEX7)
	);

// your code here
//	
initial begin
	SW = 18'b10; #10
	if (HEX0 !== 7'b1111001) $display ("hex0 fail");
	SW = 18'b1; #10
        if (HEX0 == 7'b1111001) $display ("hex0 pass");


	SW[7:4] = 4'b1; #10
	if (HEX1 == 7'b1111001) $display ("Hex1 pass");
	SW[7:4] = 4'b10; #10
        if (HEX1 !== 7'b1111001) $display ("Hex1 fail");

	SW[11:8] = 4'b1; #10
        if (HEX2 == 7'b1111001) $display ("hex2 pass");
        SW[11:8] = 4'b10; #10    
        if (HEX2 !== 7'b1111001) $display ("hex2 fail");

        
        SW[15:12] = 4'b1; #10
        if (HEX3 == 7'b1111001) $display ("Hex3 pass");
        SW[15:12] = 4'b10; #10
        if (HEX3 !== 7'b1111001) $display ("Hex3 fail");

	SW[17:16] = 4'b1; #10
        if (HEX4 == 7'b1111001) $display ("Hex4 pass");
        SW[17:16] = 4'b10; #10
        if (HEX4 !== 7'b1111001) $display ("Hex4 fail");


end

endmodule

