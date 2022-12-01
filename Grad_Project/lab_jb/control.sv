module control (input logic [31:0] instr, input logic [0:0] stall_EX,

		output logic [3:0] aluop,
		output logic [0:0] alusrc,
		output logic [1:0] regsel,
		output logic [0:0] regwrite,
		output logic [0:0] gpio_we);
	
// Instruction Varibles
	logic [6:0] op; 
        logic [4:0] rs1;
        logic [4:0] rs2;
        logic [4:0] rd;   
        logic [6:0] funct7;
        logic [2:0] funct3;
        logic [11:0] imm12;
        logic [19:0] imm20;
	logic [2:0] instrT;
	

deco decode1 (.instr(instr), .op(op), .rs1(rs1), .rs2(rs2), .rd(rd), .funct7(funct7), .funct3(funct3), .imm12(imm12), .imm20(imm20), .instrT(instrT));

always_comb begin

	//defaults
	aluop = 4'bX;
	alusrc=1'bX;
	regsel = 2'bX;
	regwrite = 1'bX;
    	gpio_we = 1'bX;


if (stall_EX !== 1'b0) begin
	aluop = 4'b0011;
	alusrc=1'b1;
end

else begin

if(op == 7'h73) begin //csrrw
		if(imm12 == 12'hf02) begin // HEX
            regsel = 2'bX;
        	regwrite = 1'b0;
            gpio_we = 1'b1;
		end

		if(imm12 == 12'hf00) begin // SW
            regsel = 2'b00;
            regwrite = 1'b1;
            gpio_we = 1'b0;
end
end
else if(instrT == 3'b01) begin // R type
		if(funct7 ==7'b0000000) begin
			if(funct3 ==3'b000) begin //add
				aluop = 4'b0011;
                alusrc=1'b0;
                regsel = 2'b10;
                regwrite = 1'b1;
                gpio_we = 1'b0;
			end

		end
	if(funct7==7'h20) begin 
		if(funct3==3'b00) begin //sub
				aluop = 4'b0100;
                                alusrc=1'b0;
                                regsel = 2'b10;
                                regwrite = 1'b1;
                                gpio_we = 1'b0;

		end
	end
	if(funct7==7'h1) begin 
		if(funct3==3'b000) begin //mul
				aluop = 4'b0101;
                                alusrc=1'b0;
                                regsel = 2'b10;
                                regwrite = 1'b1;
                                gpio_we = 1'b0;

		end
	end
	if(funct7==7'h1) begin
		if(funct3==3'b001) begin //mulh
				aluop = 4'b0110;
                                alusrc=1'b0;
                                regsel = 2'b10;
                                regwrite = 1'b1;
                                gpio_we = 1'b0;

		end
	end
	if(funct7==7'h1) begin 
		if(funct3==3'b011) begin //mulhu
				aluop = 4'b0111;
                                alusrc=1'b0;
                                regsel = 2'b10;
                                regwrite = 1'b1;
                                gpio_we = 1'b0;

		end
	end
	if(funct7==7'h0) begin
		if(funct3==3'b010) begin //slt
				aluop = 4'b1100;
                                alusrc=1'b0;
                                regsel = 2'b10;
                                regwrite = 1'b1;
                                gpio_we = 1'b0;

		end
	end
	if(funct7==7'h0) begin
		if(funct3==3'b011) begin //sltu
				aluop = 4'b1101;
                alusrc=1'b0;
                regsel = 2'b10;
                regwrite = 1'b1;
                gpio_we = 1'b0;

		end
	end
	if(funct7==7'h0) begin 
		if (funct3==3'b111) begin //and
				aluop = 4'b0000;
                                alusrc=1'b0;
                                regsel = 2'b10;
                                regwrite = 1'b1;
                                gpio_we = 1'b0;

		end
	end
	if(funct7==7'h0) begin
		if(funct3==3'b110) begin //or
				aluop = 4'b0001;
                                alusrc=1'b0;
                                regsel = 2'b10;
                                regwrite = 1'b1;
                                gpio_we = 1'b0;

		end
	end
	if(funct7==7'h0) begin
		if(funct3==3'b100) begin //xor
				aluop = 4'b0010;
                                alusrc=1'b0;
                                regsel = 2'b10;
                                regwrite = 1'b1;
                                gpio_we = 1'b0;

		end
	end
	if(funct7==7'h0) begin 
		if(funct3==3'b001) begin //sll
				aluop = 4'b1000;
                                alusrc=1'b0;
                                regsel = 2'b10;
                                regwrite = 1'b1;
                                gpio_we = 1'b0;

		end
	end
	if(funct7==7'h0) begin
		if(funct3==3'b101) begin //srl
				aluop = 4'b1001;
                                alusrc=1'b0;
                                regsel = 2'b10;
                                regwrite = 1'b1;
                                gpio_we = 1'b0;

		end
	end
	if(funct7==7'b0100000) begin
		if(funct3==3'b101) begin //sra
				aluop = 4'b1010;
                                alusrc=1'b0;
                                regsel = 2'b10;
                                regwrite = 1'b1;
                                gpio_we = 1'b0;

		end
	end
end
else if(instrT == 3'b10) begin // I type
			if(funct3==3'b000) begin //addi
				aluop = 4'b0011;
                                alusrc=1'b1;
                                regsel = 2'b10;
                                regwrite = 1'b1;
                                gpio_we = 1'b0;

			end
			if(funct3==3'b111) begin //andi
				aluop = 4'b0000;
                                alusrc=1'b1;
                                regsel = 2'b10;
                                regwrite = 1'b1;
                                gpio_we = 1'b0;

			end
			if(funct3==3'b110) begin //ori
				aluop = 4'b0001;
                                alusrc=1'b1;
                                regsel = 2'b10;
                                regwrite = 1'b1;
                                gpio_we = 1'b0;

			end
			if(funct3==3'b100) begin //xori
				aluop = 4'b0010;
                                alusrc=1'b1;
                                regsel = 2'b10;
                                regwrite = 1'b1;
                                gpio_we = 1'b0;

			end
			if(funct7==7'h0) begin
				if(funct3==3'b001) begin //slli
				aluop = 4'b1000;
                                alusrc=1'b1;
                                regsel = 2'b10;
                                regwrite = 1'b1;
                                gpio_we = 1'b0;

				end
			end
		if(funct7==7'b0100000) begin
			if(funct3==3'b101) begin //srai
				aluop = 4'b1010;
                alusrc=1'b1;
                regsel = 2'b10;
                regwrite = 1'b1;
                gpio_we = 1'b0;

			end
		end
		if(funct7==7'h0) begin
			if(funct3==3'b101) begin //srli
				aluop = 4'b1001;
                                alusrc=1'b1;
                                regsel = 2'b10;
                                regwrite = 1'b1;
                                gpio_we = 1'b0;

			end
		end
end
else if(instrT == 3'b11) begin // U type
			if(op==7'h37) begin //lui
				aluop = 4'bX;
				alusrc=1'bX;
				regsel = 2'b01;
				regwrite = 1'b1;
				gpio_we = 1'b0;
			end
end
else if(instrT == 3'b100) begin //Branch
	if(funct3 == 3'b000) begin //BEQ
			aluop = 4'b0100;
            alusrc=1'b0;
            regsel = 2'b10;
            regwrite = 1'b0;
            gpio_we = 1'b0;
	end
	if(funct3 == 3'b001) begin //BNE
			aluop = 4'b0100;
            alusrc=1'b0;
            regsel = 2'b10;
            regwrite = 1'b0;
            gpio_we = 1'b0;
	end
	if(funct3 == 3'b100) begin //BLT
			aluop = 4'b1100;
            alusrc=1'b0;
            regsel = 2'b10;
            regwrite = 1'b0;
            gpio_we = 1'b0;
	end
	if(funct3 == 3'b101) begin //BGE
			aluop = 4'b1100;
            alusrc=1'b0;
            regsel = 2'b10;
            regwrite = 1'b0;
            gpio_we = 1'b0;
	end
	if(funct3 == 3'b110) begin //BLTU
				aluop = 4'b1101;
                alusrc=1'b0;
                regsel = 2'b10;
                regwrite = 1'b0;
                gpio_we = 1'b0;
	end
	if(funct3 == 3'b111) begin //BGEU
				aluop = 4'b1101;
                alusrc=1'b0;
                regsel = 2'b10;
                regwrite = 1'b0;
                gpio_we = 1'b0;
	end
end
else if(instrT == 3'b101) begin //Jalr

		aluop = 4'b1010;
    	alusrc=1'b0;
        regsel = 2'b11;
        regwrite = 1'b1;
        gpio_we = 1'b0;

end
else if (instrT == 3'b110) begin //Jal
		aluop = 4'b1010;
    	alusrc=1'b0;
        regsel = 2'b11;
        regwrite = 1'b1;
        gpio_we = 1'b0;
end

end

end
endmodule
