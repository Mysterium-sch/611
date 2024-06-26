module cpu(input logic clk, input logic rst_n, input logic [31:0] instr_in, output logic [31:0] instr_out); 

// From given cpu file
logic [31:0] inst_ram [4095:0];
logic [11:0] PC_FETCH = 12'd0; 
logic [31:0] instr_EX;
logic [31:0] instr_WB;

// Write back control signals
logic [3:0] aluop_WB;
logic [0:0] alusrc_WB;
logic [1:0] regsel_WB;
logic [0:0] regwrite_WB;
logic [0:0] gpio_we_WB;

// Decode/Execute control signals
logic [3:0] aluop_EX;
logic [0:0] alusrc_EX;
logic [1:0] regsel_EX;
logic [0:0] regwrite_EX;
logic [0:0] gpio_we_EX;

// regfile outputs
logic [31:0] readdata1;
logic [31:0] readdata2;
logic [31:0] luiHelper;

// alu ouputs
logic [31:0] R_EX;
logic [31:0] R_WB;
logic zero;

// Devices
logic [31:0] se;
logic [31:0] mux1;
logic [31:0] mux2;
logic [11:0] PC_mux;

// Update to lab 4
logic [11:0] PC_EX = 12'd0;
logic [0:0] stall_EX;
logic [0:0] stall_FETCH;
logic [1:0] pcsrc_EX;

//branch
logic [11:0] branch_addr_EX;
logic [12:0] branch_offset_EX;
//jal
logic [11:0] jal_addr_EX;
logic [20:0] jal_offset_EX;
//jalr
logic [11:0] jalr_addr_EX;
logic [12:0] jalr_offset_EX;



initial 
	$readmemh("program.rom",inst_ram); 

// Fetch stage
always_ff @(posedge clk) begin 
	if (~rst_n) begin 
		PC_FETCH <= 12'd0; 
		instr_EX <= 32'd0; 
	end else begin
		instr_EX <= inst_ram[PC_FETCH];
		PC_FETCH <= PC_mux;
		PC_EX <= PC_FETCH;
	end 
end 


// Execute and Decode stage

// intialize control signals to be decode/execute
control control1 (.instr(instr_EX), .stall_EX(stall_EX), .aluop(aluop_EX), .alusrc(alusrc_EX), .regsel(regsel_EX), .regwrite(regwrite_EX), .gpio_we(gpio_we_EX)); 

// Sign extend for alu
assign se = {{20{instr_EX[31]}}, instr_EX[31:20]};
assign mux1 = (alusrc_EX == 2'b1) ? se : readdata2;



logic [6:0] op;
assign op = instr_EX[6:0];
alu alu1 (.A(readdata1), .B(mux1), .op(aluop_EX), .R(R_EX), .zero(zero));

// intialize alu
	assign pcsrc_EX = (stall_EX == 1'b1) ? 2'b0 : (instr_EX[6:0] == 7'b1100011) ? 
			  ((instr_EX[14:12] == 3'b0) ? (zero == 1'b1 ? 2'b1 : 2'b0) : ((instr_EX[14:12] == 3'b1) ? (zero == 1'b0 ? 2'b1 : 2'b0) : (instr_EX[14:12] == 3'b100) ? (R_EX[0] == 1'b1 ? 2'b1 : 2'b0) : (instr_EX[14:12] == 3'b101) ? (zero == 1'b1 ? 2'b1 : 2'b0) : (instr_EX[14:12] == 3'b110) ? (R_EX[0] == 1'b1 ? 2'b1 : 2'b0) : (instr_EX[14:12] == 3'b111) ? (zero == 1'b1 ? 2'b1 : 2'b0) : 2'b0))
								: ((instr_EX[6:0] == 7'b1100111) ? 2'b11 : ((instr_EX[6:0] == 7'b1101111) ? 2'b10 : 2'b0));
	
	assign stall_FETCH = (pcsrc_EX[1:0] == 2'b0) ? 1'b0 : 1'b1;

always @(posedge clk) stall_EX <= stall_FETCH;

// Write back stage
always_ff @(posedge clk) begin

	R_WB <= R_EX;
	instr_WB <= instr_EX;
	regwrite_WB <= regwrite_EX;
	regsel_WB <= regsel_EX;
	gpio_we_WB <= gpio_we_EX;
	alusrc_WB <= alusrc_EX;
	aluop_WB <= aluop_EX;
	luiHelper <= ({instr_EX[31:12], 12'b0});
	
// Setting our output
	if(gpio_we_WB == 1'b1) begin
		instr_out <= readdata1;
	end else if (~rst_n) begin 
	        instr_out <= 32'b0;           
	end else begin 
	        instr_out <= instr_out;         
	end 
end

// Mux for regfile
assign mux2 = (regsel_WB == 2'b11) ? PC_EX : ((regsel_WB == 2'b10) ? R_WB : ((regsel_WB == 2'b01) ? luiHelper : instr_in));

// Lab 4 Specfics 

// branch cal
assign branch_offset_EX = {instr_EX[31], instr_EX[7], instr_EX[30:25], instr_EX[11:8], 1'b0};
assign branch_addr_EX = PC_EX + {branch_offset_EX[12], branch_offset_EX[12:2]};

// Jal cal
assign jal_offset_EX = {instr_EX[31], instr_EX[19:12], instr_EX[20], instr_EX[30:21], 1'b0};
assign jal_addr_EX = PC_EX + jal_offset_EX[13:2];

//Jalr cal
assign jalr_offset_EX = instr_EX[31:20];
assign jalr_addr_EX = readdata1 + {{2{jalr_offset_EX[11]}},jalr_offset_EX[11:2]};

logic [11:0] holder;
assign holder = PC_FETCH + 1'b1;
assign PC_mux = (pcsrc_EX == 2'b11) ? (jalr_addr_EX) : ((pcsrc_EX == 2'b1) ? branch_addr_EX : ((pcsrc_EX == 2'b10) ? jal_addr_EX : holder));
		
// Intialize regfile
regfile regfile1 (.clk(clk), .rst(~rst_n), .we(regwrite_WB), .readaddr1(instr_EX[19:15]), .readaddr2(instr_EX[24:20]), .writeaddr(instr_WB[11:7]), .writedata(mux2), .readdata1(readdata1), .readdata2(readdata2));


endmodule  
