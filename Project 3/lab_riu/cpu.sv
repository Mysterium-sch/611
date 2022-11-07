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

initial 
	$readmemh("program.rom",inst_ram); 

always_ff @(posedge clk) begin 
	if (~rst_n) begin 
		PC_FETCH <= 12'd0; 
		instr_EX <= 32'd0; 
	end else begin
		instr_EX <= inst_ram[PC_FETCH];
		PC_FETCH <= PC_FETCH + 1'b1;
	end 
end 

// intialize control signals to be decode/execute
control control1 (.instr(instr_EX), .aluop(aluop_EX), .alusrc(alusrc_EX), .regsel(regsel_EX), .regwrite(regwrite_EX), .gpio_we(gpio_we_EX)); 

// Sign extend for alu
assign se = {{20{instr_EX[31]}}, instr_EX[31:20]};
assign mux1 = (alusrc_EX == 2'b1) ? se : readdata2;


// intialize alu
alu alu1 (.A(readdata1), .B(mux1), .op(aluop_EX), .R(R_EX), .zero(zero));


// set WB
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
assign mux2 = (regsel_WB == 2'b10) ? R_WB : ((regsel_WB == 2'b01) ? luiHelper : instr_in);

// Intialize regfile
regfile regfile1 (.clk(clk), .rst(~rst_n), .we(regwrite_WB), .readaddr1(instr_EX[19:15]), .readaddr2(instr_EX[24:20]), .writeaddr(instr_WB[11:7]), .writedata(mux2), .readdata1(readdata1), .readdata2(readdata2));


endmodule  
