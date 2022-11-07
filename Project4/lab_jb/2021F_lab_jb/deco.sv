module deco (input logic [31:0] instr,
        /////// Intruction Fields
        output logic [6:0] op, 
	output logic [4:0] rs1,
        output logic [4:0] rs2,
        output logic [4:0] rd,    
        output logic [6:0] funct7,
        output logic [2:0] funct3,
        output logic [11:0] imm12,
        output logic [19:0] imm20,
	output logic [2:0] instrT);

        assign imm12 = instr[31:20];
        assign imm20 = instr[31:12];
        assign funct7 = instr[31:25];
        assign rs2 = instr[24:20];
        assign rs1 = instr[19:15];
        assign funct3 = instr[14:12];
        assign rd = instr[11:7];
        assign op = instr[6:0];
        	
	always_comb begin
		instrT = 3'b0;
                if(op == 7'b0110011) begin // R type
                        instrT = 3'b1; // 1                
                end
                if(op == 7'b0010011) begin // I type
                        instrT = 3'b10; // 2
                end
                if(op == 7'b0110111) begin // U type
                        instrT = 3'b11; // 3
                end
		if(op == 7'b1100011) begin //branch
			instrT = 3'b100;
		end
		if(op == 7'b1100111) begin //J type
			instr = 3'b101;
		end
        end

endmodule

