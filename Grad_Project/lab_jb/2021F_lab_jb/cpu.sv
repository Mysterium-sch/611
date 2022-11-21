module cpu(input logic clk, input logic rst_n, input logic [31:0] instr_in, output logic [31:0] instr_out); 

// From given cpu file
logic [31:0] inst_ram [2047:0];
logic [11:0] PC_FETCH = 9'd0; 
logic [63:0] instr_EX;
logic [31:0] instr_EX_1;
logic [31:0] instr_EX_2;
logic [31:0] instr_WB_1;
logic [31:0] instr_WB_2;

// Write back control signals
logic [1:0] regsel_WB_1;
logic [0:0] regwrite_WB_1;
logic [1:0] regsel_WB_2;
logic [0:0] regwrite_WB_2;
logic [0:0] gpio_we_WB_2;

// Decode/Execute control signals
logic [3:0] aluop_EX_1;
logic [0:0] alusrc_EX_1;
logic [1:0] regsel_EX_1;
logic [0:0] regwrite_EX_1;
logic [0:0] gpio_we_EX_1;
logic [3:0] aluop_EX_2;
logic [0:0] alusrc_EX_2;
logic [1:0] regsel_EX_2;
logic [0:0] regwrite_EX_2;
logic [0:0] gpio_we_EX_2;

// regfile outputs
logic [31:0] readdata1_1;
logic [31:0] readdata2_1;
logic [31:0] luiHelper_1;
logic [31:0] readdata1_2;
logic [31:0] readdata2_2;
logic [31:0] luiHelper_2;

// alu ouputs
logic [31:0] R_EX_1;
logic [31:0] R_WB_1;
logic [31:0] R_EX_2;
logic [31:0] R_WB_2;
logic zero;

// Devices
logic [31:0] se_1;
logic [31:0] mux1_1;
logic [31:0] mux2_1;
logic [31:0] se_2;
logic [31:0] mux1_2;
logic [31:0] mux2_2;
logic [11:0] PC_mux;

// Update to lab 4
logic [11:0] PC_EX = 12'd0;
logic [0:0] stall_EX_1;
logic [0:0] stall_FETCH_1;
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
		// branch cal
		PC_FETCH <= PC_mux;
		PC_EX <= PC_FETCH;
		instr_EX <= inst_ram[PC_FETCH];
	end 
end 

assign instr_EX_1 = instr_EX[63:32];
assign instr_EX_2 = instr_EX[31:0];

// Execute and Decode stage

// intialize control signals to be decode/execute
control control1 (.instr(instr_EX_1), .stall_EX(stall_EX_1), .aluop(aluop_EX_1), .alusrc(alusrc_EX_1), .regsel(regsel_EX_1), .regwrite(regwrite_EX_1), .gpio_we(gpio_we_EX_1)); 
control control2 (.instr(instr_EX_2), .stall_EX(stall_EX_1), .aluop(aluop_EX_2), .alusrc(alusrc_EX_2), .regsel(regsel_EX_2), .regwrite(regwrite_EX_2), .gpio_we(gpio_we_EX_2)); 

// Sign extend for alu
assign se_1 = {{20{instr_EX_1[31]}}, instr_EX_1[31:20]};
assign mux1_1 = (alusrc_EX_1 == 2'b1) ? se_1 : readdata2_1;

assign se_2 = {{20{instr_EX_2[31]}}, instr_EX_2[31:20]};
assign mux1_2 = (alusrc_EX_2 == 2'b1) ? se_2 : readdata2_2;



alu alu1_1 (.A(readdata1_1), .B(mux1_1), .op(aluop_EX_1), .R(R_EX_1), .zero(zero));
alu alu1_2 (.A(readdata1_2), .B(mux1_2), .op(aluop_EX_2), .R(R_EX_2), .zero(zero));

// intialize alu
	assign pcsrc_EX = (stall_EX_1 == 1'b1) ? 2'b0 : (instr_EX_1[6:0] == 7'b1100011) ? 
			    ((instr_EX_1[14:12] == 3'b0) ? (R_EX_1 == 32'b0 ? 2'b1 : 2'b0) : ((instr_EX_1[14:12] == 3'b1) ? (R_EX_1 !== 32'b0 ? 2'b1 : 2'b0) : (instr_EX_1[14:12] == 3'b100) ? (R_EX_1 == 32'b1 ? 2'b1 : 2'b0) : (instr_EX_1[14:12] == 3'b101) ? (R_EX_1 == 32'b0 ? 2'b1 : 2'b0) : (instr_EX_1[14:12] == 3'b110) ? (R_EX_1 == 32'b1 ? 2'b1 : 2'b0) : (instr_EX_1[14:12] == 3'b111) ? (R_EX_1 == 32'b0 ? 2'b1 : 2'b0) : 2'b0))
			    : ((instr_EX_1[6:0] == 7'b1100111) ? 2'b11 : ((instr_EX_1[6:0] == 7'b1101111) ? 2'b10 : 2'b0));
	
	assign stall_FETCH_1 = (pcsrc_EX[1:0] == 2'b0) ? 1'b0 : 1'b1;

	always @(posedge clk) stall_EX_1 <= stall_FETCH_1;

// Write back stage
always_ff @(posedge clk) begin

	R_WB_1 <= R_EX_1;
	R_WB_2 <= R_EX_2;
	regwrite_WB_1 <= regwrite_EX_1;
	regwrite_WB_2 <= regwrite_EX_1;
	regsel_WB_1 <= regsel_EX_1;
	regsel_WB_2 <= regsel_EX_2;
	luiHelper_1 <= ({instr_EX_1[31:12], 12'b0});
	luiHelper_2 <= ({instr_EX_2[31:12], 12'b0});
	gpio_we_WB_2 <= gpio_we_EX_2;
	
// Setting our output
	if(gpio_we_WB_2 == 1'b1) begin
		instr_out <= readdata1_2;
	end else if (~rst_n) begin 
	        instr_out <= 32'b0;           
	end else begin 
	        instr_out <= instr_out;         
	end 
end

// Mux for regfile
assign mux2_1 = (regsel_WB_1 == 2'b11) ? PC_EX : ((regsel_WB_1 == 2'b10) ? R_WB_1 : ((regsel_WB_1 == 2'b01) ? luiHelper_1 : instr_in));
assign mux2_2 = (regsel_WB_2 == 2'b11) ? PC_EX : ((regsel_WB_2 == 2'b10) ? R_WB_2 : ((regsel_WB_2 == 2'b01) ? luiHelper_2 : instr_in));

// Lab 4 Specfics 

// branch cal
assign branch_offset_EX = {instr_EX_1[31], instr_EX_1[7], instr_EX_1[30:25], instr_EX_1[11:8], 1'b0};
assign branch_addr_EX = PC_EX + {branch_offset_EX[12], branch_offset_EX[12:2]};

// Jal cal
assign jal_offset_EX = {instr_EX_1[31], instr_EX_1[19:12], instr_EX_1[20], instr_EX_1[30:21], 1'b0};
assign jal_addr_EX = PC_EX + jal_offset_EX[13:2];

//Jalr cal
assign jalr_offset_EX = instr_EX_1[31:20];
assign jalr_addr_EX = readdata1_1 + {{2{jalr_offset_EX[11]}},jalr_offset_EX[11:2]};

logic [11:0] holder;
assign holder = PC_FETCH + 2'b10;
assign PC_mux = (pcsrc_EX == 2'b11) ? (jalr_addr_EX) : ((pcsrc_EX == 2'b1) ? branch_addr_EX : ((pcsrc_EX == 2'b10) ? jal_addr_EX : holder));
		
// Intialize regfile
	regfile regfile1 (.clk(clk), .rst(~rst_n), .we_1(regwrite_WB_1), .we_2(regwrite_WB_2), .readaddr1_1(instr_EX_1[19:15]), .readaddr2_2(instr_EX_2[24:20]), .writeaddr_1(instr_WB_1[11:7]), .writeaddr_2(instr_WB_2[11:7]), .writedata_1(mux2_1), .writedata_2(mux2_2), .readdata1_1(readdata1_1), .readdata2_1(readdata2_1), .readdata1_2(readdata1_2), .readdata2_2(readdata2_2));


endmodule  
