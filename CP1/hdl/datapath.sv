import rv32i_types::*; 

module datapath (
    input clk, 
    input rst, 
    input rv32i_word mem_rdata, 
    input rv32i_word mem_resp, 
    output logic mem_read, 
    output logic mem_write, 
    output logic mem_addr, 
    output rv32i_word mem_wdata
);
/******************* Variables *******************/
rv32i_stage IF_ID_i; 
rv32i_stage IF_ID_o; 
rv32i_stage ID_EX_i; 
rv32i_stage ID_EX_o;
rv32i_stage EX_MEM_i; 
rv32i_stage EX_MEM_o;
rv32i_stage MEM_WB_i; 
rv32i_stage MEM_WB_o;
rv32i_word pc_out; 
rv32i_word pcmux_out; 
rv32i_word modmux_out; 
rv32i_word regfilemux_out; 
logic [1:0] mask_bits; 
rv32i_word alumux1_out; 
rv32i_word cmpmux_out; 


/******************* IF Stage *******************/
assign IF_ID_i.DataWord.pc = pc_out; 
assign IF_ID_i.DataWord.rs1 = mem_rdata[19:15]; 
assign IF_ID_i.DataWord.rs2 = mem_rdata[24:20]; 
assign IF_ID_i.DataWord.rd = mem_rdata[11:7]; 
/***** Determine what immediate will be used in the execute stage *****/
case(IF_ID_i.ControlWord.opcode) begin 
    op_jalr, op_load, op_imm:
        IF_ID_i.DataWord.imm = {{21{mem_rdata[31]}}, mem_rdata[30:20]};
    op_store:
        IF_ID_i.DataWord.imm = {{21{mem_rdata[31]}}, mem_rdata[30:25], mem_rdata[11:7]};
    op_br:
        IF_ID_i.DataWord.imm = {{20{mem_rdata[31]}}, mem_rdata[7], mem_rdata[30:25], mem_rdata[11:8], 1'b0};
    op_lui, op_auipc:
        IF_ID_i.DataWord.imm = {data[31:12], 12'h000};
    op_jal:
        IF_ID_i.DataWord.imm = {{12{data[31]}}, data[19:12], data[20], data[30:21], 1'b0};
end 
/***** Modules *****/
control_rom ctrl_rom(.opcode(rv32i_opcode'(mem_rdata[6:0])), .funct3(mem_rdata[14:12]), 
                     .funct7(mem_rdata[31:25]), .ctrl_word(IF_ID_i.ControlWord));
                                         // Change load to pc later
pc_register pc_reg(.clk(clk), .rst(rst), .load(1'b1), .in(pcmux_out), .out(pc_out));
/***** MUXES *****/
always_comb begin : IF_MUXES 
    unique case(EX_MEM_o.ControlWord.br_en)
        pcmux::pc_plus4: pcmux_out = pc_out + 4; 
        pcmux::alu_out: pcmux_out = modmux_out; 
    endcase 
    unique case(EX_MEM_o.ControlWord.modmux_sel)
        modmux::alu_out: modmux_out = EX_MEM_o.DataWord.alu_out; 
        modmux::alu_mod2: modmux_out = {EX_MEM_o.DataWord.alu_out[31:1], 1'b0}; 
    endcase 
end 

/******************* IF_ID *******************/
pipeline_stage IF_ID_stage (.clk(clk), .rst(rst), .load(1'b1), .stage_i(IF_ID_i), .stage_o(IF_ID_o)); 

/******************* ID Stage *******************/
assign mask_bits = MEM_WB_o.alu_out[1:0];
/***** Modules *****/
regfile regfile (.clk(clk), .rst(rst), .load(MEM_WB_o.ControlWord.load_regfile), .in(regfilemux_out)
                 .src_a(IF_ID_o.DataWord.rs1), .src_b(IF_ID_o.DataWord.rs2), .dest(MEM_WB_o.DataWord.rd),
                 .reg_a(ID_EX_i.DataWord.rs1_out), .reg_b(ID_EX_i.DataWord.rs2_out));
/***** MUXES *****/
always_comb begin : ID_MUXES 
    unique case(MEM_WB_o.ControlWord.regfilemux_sel)
        regfilemux::alu_out: regfilemux_out = MEM_WB_o.DataWord.alu_out; 
        regfilemux::br_en: regfilemux_out = {{31'd0}, MEM_WB_o.ControlWord.br_en}; 
        regfilemux::u_imm: regfilemux_out = MEM_WB_o.DataWord.imm; 
        regfilemux::lw: regfilemux_out = MEM_WB_o.DataWord.data_mdr; 
        regfilemux::pc_plus4: regfilemux_out = MEM_WB_o.pc + 4;
        regfilemux::lb: begin 
            case(mask_bits)
                2'b00: regfilemux_out = {{24{MEM_WB_o.DataWord.data_mdr[7]}},  MEM_WB_o.DataWord.data_mdr[7:0]}; 
                2'b01: regfilemux_out = {{24{MEM_WB_o.DataWord.data_mdr[15]}}, MEM_WB_o.DataWord.data_mdr[15:8]};
                2'b10: regfilemux_out = {{24{MEM_WB_o.DataWord.data_mdr[23]}}, MEM_WB_o.DataWord.data_mdr[23:16]};
                2'b11: regfilemux_out = {{24{MEM_WB_o.DataWord.data_mdr[31]}}, MEM_WB_o.DataWord.data_mdr[31:24]};                
            endcase
        end 
        regfilemux::lbu: begin 
            case(mask_bits)
                2'b00: regfilemux_out = {{24'd0}, MEM_WB_o.DataWord.data_mdr[7:0]}; 
                2'b01: regfilemux_out = {{24'd0}, MEM_WB_o.DataWord.data_mdr[15:8]};
                2'b10: regfilemux_out = {{24'd0}, MEM_WB_o.DataWord.data_mdr[23:16]};
                2'b11: regfilemux_out = {{24'd0}, MEM_WB_o.DataWord.data_mdr[31:24]};
            endcase              
        end    
        regfilemux::lh: begin 
            case(mask_bits)
                2'b00: regfilemux_out = {{16{MEM_WB_o.DataWord.data_mdr[15]}}, MEM_WB_o.DataWord.data_mdr[15:0]};
                2'b01: regfilemux_out = {{16{MEM_WB_o.DataWord.data_mdr[23]}}, MEM_WB_o.DataWord.data_mdr[23:8]};
                2'b10: regfilemux_out = {{16{MEM_WB_o.DataWord.data_mdr[31]}}, MEM_WB_o.DataWord.data_mdr[31:16]}; 
                2'b11: regfilemux_out = 32'd0;
            endcase 
        end  
        regfilemux::lhu: begin 
            case(mask_bits)
                2'b00: regfilemux_out = {{16'd0}, MEM_WB_o.DataWord.data_mdr[15:0]};
                2'b01: regfilemux_out = {{16'd0}, MEM_WB_o.DataWord.data_mdr[23:8]};
                2'b10: regfilemux_out = {{16'd0}, MEM_WB_o.DataWord.data_mdr[31:16]}; 
                2'b11: regfilemux_out = 32'd0;
            endcase 
        end                      
    endcase 
end
/******************* ID_EX *******************/
pipeline_stage ID_EX_stage (.clk(clk), .rst(rst), .load(1'b1), .stage_i(ID_EX_i), .stage_o(ID_EX_o));  

/******************* EX *******************/
case(store_funct3'(ID_EX_o.ControlWord.funct3))
    sw: EX_MEM_i.ControlWord.mem_byte_enable = 4'b1111;
    sh: EX_MEM_i.ControlWord.mem_byte_enable = 4'b0011 << EX_MEM_i.DataWord.alu_out[1:0];
    sb: EX_MEM_i.ControlWord.mem_byte_enable = 4'b0001 << EX_MEM_i.DataWord.alu_out[1:0];
endcase 
/***** Modules *****/
alu ALU (
    .aluop(ID_EX_o.ControlWord.aluop),
    .a(alumux1_out),
    .b(ID_EX_o.DataWord.imm),
    .f(EX_MEM_i.DataWord.alu_out)
)
cmp CMP (
    .cmpop(ID_EX_o.ControlWord.cmpop),
    .rs1_out(ID_EX_o.DataWord.rs1_out),
    .cmpmux_out(cmpmux_out),
	.br_en(EX_MEM_i.ControlWord.br_en)
)
/***** MUXES *****/
always_comb begin : EX_MUXES 
    unique case(ID_EX_o.ControlWord.alumux_sel) 
        alumux::rs1_out: alumux1_out = ID_EX_o.DataWord.rs1_out;
        alumux::pc_out: alumux1_out = ID_EX_o.DataWord.pc;
    endcase 
    unique case(ID_EX_o.ControlWord.cmpmux_sel)
        cmpmux::rs2_out: cmpmux_out = ID_EX_o.DataWord.rs2_out; 
        cmpmux::i_imm: cmpmux_out = ID_EX_o.DataWord.imm; 
    endcase 
end 
endmodule : datapath 