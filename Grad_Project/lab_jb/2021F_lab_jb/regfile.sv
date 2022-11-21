/* 32 x 32 register file implementation */

module regfile (

/**** inputs *****************************************************************/

	input [0:0 ] clk,		/* clock */
	input [0:0 ] rst,		/* reset */
	input [0:0 ] we_1,		/* write enable */
	input [0:0 ] we_2,		/* write enable */
	
	input [4:0 ] readaddr1_1,		/* read address 1 */
	input [4:0 ] readaddr2_1,		/* read address 2 */
	input [4:0 ] writeaddr_1,		/* write address */
	input [31:0] writedata_1,		/* write data */
	
	input [4:0 ] readaddr1_2,		/* read address 1 */
	input [4:0 ] readaddr2_2,		/* read address 2 */
	input [4:0 ] writeaddr_2,		/* write address */
	input [31:0] writedata_2,		/* write data */

/**** outputs ****************************************************************/

	output [31:0] readdata1_1,	/* read data 1 */
	output [31:0] readdata2_1,		/* read data 2 */
	output [31:0] readdata1_2,	/* read data 1 */
	output [31:0] readdata2_2
);



logic [63:0] mem[63:0];
// note that declaring readdata*, reg30_out as 'output reg' would have the
// same effect.
logic [31:0] readdata1_buf_1, readdata2_buf_1, readdata1_buf_2, readdata2_buf_2;


always_ff @(posedge clk, posedge rst) begin


	if (rst) begin
		// initialize reg 0 to 0
		mem[0] <= 0;
	end

	else begin

		// write to the requested addr iff we is high

		// handle case where we are writing to reg0. we explicitly write 0 to
		// as a precaution to make sure nothing gets optimized out of the
		// design.
		if (we_1 && (writeaddr_1 == 0)) mem[0] <= 0;
		// handle the default case
		else if (we_1) mem[writeaddr_1] <= writedata_1;
		
		if (we_2 && (writeaddr_2 == 0)) mem[0] <= 0;
		// handle the default case
		else if (we_2) mem[writeaddr_2] <= writedata_2;

	end

end

always_comb begin
	// $monitor("reg 6: %8h", mem[6]);
	// $monitor("reg 5: %8h", mem[5]);
	// $monitor("writeaddr: %8h, we: %1h", writeaddr, we);

	// special case to prevent write bypass from kicking in for reg0
	if (we_1 && (readaddr1_1 == 0)) readdata1_buf_1 = 0;
	// write-bypass
	else if (we_1 && (readaddr1_1 == writeaddr_1)) readdata1_buf_1 = writedata_1;
	// default case
	else readdata1_buf_1 = mem[readaddr1_1];
	
	// Instruction 2
	if (we_2 && (readaddr1_2 == 0)) readdata1_buf_2 = 0;
	// write-bypass
	else if (we_2 && (readaddr1_2 == writeaddr_2)) readdata1_buf_2 = writedata_2;
	// default case
	else readdata1_buf_2 = mem[readaddr1_2];

end

// connect the output buffers to the output wires
assign readdata1_1 = readdata1_buf_1;
assign readdata2_1 = readdata2_buf_1;
assign readdata1_2 = readdata1_buf_2;
assign readdata2_2 = readdata2_buf_2;

endmodule
