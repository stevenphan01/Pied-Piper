import rv32i_types::*; 

module datapath (
    input clk, 
    input rst, 
    /* Instruction memory interface */ 
    input  inst_resp_dp,
    input  rv32i_word inst_rdata_dp, 
    output inst_read_dp, 
    output rv32i_word inst_addr_dp, 
    /* Data memory interface */
    input data_resp_dp, 
    input rv32i_word data_rdata_dp, 
    output data_read_dp,
    output data_write_dp, 
    output [3:0] data_mbe_dp, 
    output rv32i_word data_addr_dp, 
    output rv32i_word data_wdata_dp
);
/****************************************************** Variables *****************************************************/
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
rv32i_word regfilemux_out; 
logic [1:0] mask_bits; 
rv32i_word alumux1_out; 
rv32i_word alumux2_out; 
rv32i_word cmpmux_out; 
logic br_en_temp;
logic jump_en; 
logic load_pc;
logic load_IF_ID; 
logic load_ID_EX;
logic load_EX_MEM;
logic load_MEM_WB;
logic rst_IF_ID;
logic rst_ID_EX;
logic rst_EX_MEM; 
logic rst_MEM_WB;
rv32i_word ex_mem_forwarding_out1;
rv32i_word mem_wb_forwarding_out1;
rv32i_word ex_mem_forwarding_out2;
rv32i_word mem_wb_forwarding_out2;
logic forwarding_load1;
logic forwarding_load2;
logic forwarding_mux1;
logic forwarding_mux2;
logic alumux2_sel;
/*********************************************************************************************************************/

/************************************************* Instruction Fetch *************************************************/
// assign  inst_read_dp = 1'b1;
assign  inst_addr_dp = pc_out; 
control_rom ctrl_rom(.opcode(rv32i_opcode'(inst_rdata_dp[6:0])), .funct3(inst_rdata_dp[14:12]), 
                     .funct7(inst_rdata_dp[31:25]), .ctrl_word(IF_ID_i.ControlWord));
pc_register pc_reg(.clk(clk), .rst(rst), .load(load_pc), .in(pcmux_out), .out(pc_out));
always_comb begin : IF_comb
    // Init. the dataword 
    IF_ID_i.DataWord.pc = pc_out; 
    IF_ID_i.DataWord.rs1 = inst_rdata_dp[19:15]; 
    IF_ID_i.DataWord.rs2 = inst_rdata_dp[24:20]; 
    IF_ID_i.DataWord.rd = inst_rdata_dp[11:7]; 
    IF_ID_i.DataWord.rs1_out = 32'd0; 
    IF_ID_i.DataWord.rs2_out = 32'd0; 
    IF_ID_i.DataWord.alu_out = 32'd0; 
    IF_ID_i.DataWord.data_mdr = 32'd0; 
    // Decode the immediate 
    case(IF_ID_i.ControlWord.opcode) 
        op_jalr, op_load, op_imm:
            IF_ID_i.DataWord.imm = {{21{inst_rdata_dp[31]}}, inst_rdata_dp[30:20]};
        op_store:
            IF_ID_i.DataWord.imm = {{21{inst_rdata_dp[31]}}, inst_rdata_dp[30:25], inst_rdata_dp[11:7]};
        op_br:
            IF_ID_i.DataWord.imm = {{20{inst_rdata_dp[31]}}, inst_rdata_dp[7], inst_rdata_dp[30:25], inst_rdata_dp[11:8], 1'b0};
        op_lui, op_auipc:
            IF_ID_i.DataWord.imm = {inst_rdata_dp[31:12], 12'h000};
        op_jal:
            IF_ID_i.DataWord.imm = {{12{inst_rdata_dp[31]}}, inst_rdata_dp[19:12], inst_rdata_dp[20], inst_rdata_dp[30:21], 1'b0};
        default:
            IF_ID_i.DataWord.imm = 32'd0;
    endcase 
    // Handle Branching 
    jump_en = (EX_MEM_i.ControlWord.opcode == op_jal || EX_MEM_i.ControlWord.opcode == op_jalr);
    case({jump_en, EX_MEM_i.ControlWord.br_en})
        2'b00: pcmux_out = pc_out + 4; 
        2'b01: pcmux_out = EX_MEM_i.DataWord.alu_out; 
        2'b10: pcmux_out = {EX_MEM_i.DataWord.alu_out[31:1], 1'b0};
        2'b11: pcmux_out = pc_out + 4;
    endcase 
end : IF_comb
/*********************************************************************************************************************/

/********************************************************IF_ID********************************************************/
pipeline_stage IF_ID_stage (.clk(clk), .rst(rst_IF_ID), .load(load_IF_ID), .stage_i(IF_ID_i), .stage_o(IF_ID_o)); 
/*********************************************************************************************************************/

/************************************************ Instruction Decode *************************************************/
regfile regfile (.clk(clk), .rst(rst), .load(MEM_WB_o.ControlWord.load_regfile), .in(regfilemux_out),
                 .src_a(IF_ID_o.DataWord.rs1), .src_b(IF_ID_o.DataWord.rs2), .dest(MEM_WB_o.DataWord.rd),
                 .reg_a(ID_EX_i.DataWord.rs1_out), .reg_b(ID_EX_i.DataWord.rs2_out));
hazard_detection_unit hdu (
    .dmem_read(EX_MEM_o.ControlWord.dmem_read),
    .data_resp_dp(data_resp_dp),
    .inst_resp_dp(inst_resp_dp),
    .dest(EX_MEM_o.DataWord.rd),
    .src1(ID_EX_o.DataWord.rs1),
    .src2(ID_EX_o.DataWord.rs2),
    .br_en(EX_MEM_i.ControlWord.br_en),
    .jump_en(jump_en),
    .inst_read(inst_read_dp),
    .rst_IF_ID(rst_IF_ID),
    .rst_ID_EX(rst_ID_EX),
    .rst_EX_MEM(rst_EX_MEM),
    .rst_MEM_WB(rst_MEM_WB),
    .load_IF_ID(load_IF_ID),
    .load_ID_EX(load_ID_EX),
    .load_EX_MEM(load_EX_MEM),
    .load_MEM_WB(load_MEM_WB),
    .load_pc(load_pc)
);
always_comb begin : ID_comb 
    // Pass the pipeline data
    ID_EX_i.ControlWord = IF_ID_o.ControlWord;
    ID_EX_i.DataWord.pc = IF_ID_o.DataWord.pc; 
    ID_EX_i.DataWord.rs1 = IF_ID_o.DataWord.rs1;
    ID_EX_i.DataWord.rs2 = IF_ID_o.DataWord.rs2;  
    ID_EX_i.DataWord.rd = IF_ID_o.DataWord.rd; 
    ID_EX_i.DataWord.alu_out = IF_ID_o.DataWord.alu_out;
    ID_EX_i.DataWord.imm = IF_ID_o.DataWord.imm;  
    ID_EX_i.DataWord.data_mdr = IF_ID_o.DataWord.data_mdr; 
    mask_bits = MEM_WB_o.DataWord.alu_out[1:0];
    // Regfilemux that handles writebacks
    unique case(MEM_WB_o.ControlWord.regfilemux_sel)
        regfilemux::alu_out:  regfilemux_out = MEM_WB_o.DataWord.alu_out; 
        regfilemux::br_en:    regfilemux_out = {31'd0, MEM_WB_o.ControlWord.br_en}; 
        regfilemux::u_imm:    regfilemux_out = MEM_WB_o.DataWord.imm; 
        regfilemux::lw:       regfilemux_out = MEM_WB_o.DataWord.data_mdr; 
        regfilemux::pc_plus4: regfilemux_out = MEM_WB_o.DataWord.pc + 4;
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
end : ID_comb
/*********************************************************************************************************************/

/********************************************************ID_EX********************************************************/
pipeline_stage ID_EX_stage (.clk(clk), .rst(rst_ID_EX), .load(load_ID_EX), .stage_i(ID_EX_i), .stage_o(ID_EX_o));  
/*********************************************************************************************************************/

/****************************************************** Execute ******************************************************/
alu ALU (.aluop(ID_EX_o.ControlWord.aluop), .a(alumux1_out), .b(alumux2_out), .f(EX_MEM_i.DataWord.alu_out));
cmp CMP (.cmpop(ID_EX_o.ControlWord.cmpop), .rs1_out(ID_EX_o.DataWord.rs1_out), .cmpmux_out(cmpmux_out), .br_en(br_en_temp));
forwarding_unit fu(.dest_ex_mem(EX_MEM_o.DataWord.rd), .dest_mem_wb(MEM_WB_o.DataWord.rd), .src1(ID_EX_o.DataWord.rs1),
                   .src2(ID_EX_o.DataWord.rs2), .data_ex_mem(EX_MEM_o.DataWord.alu_out), .data_mem_wb(MEM_WB_o.DataWord.alu_out),
                   .ld_regfile_ex_mem(EX_MEM_o.ControlWord.load_regfile), .ld_regfile_mem_wb(MEM_WB_o.ControlWord.load_regfile),
                   .alumux1_sel(ID_EX_o.ControlWord.alumux1_sel), .alumux2_sel(alumux2_sel),
                   .ex_mem_forwarding_out1(ex_mem_forwarding_out1), .mem_wb_forwarding_out1(mem_wb_forwarding_out1),
                   .ex_mem_forwarding_out2(ex_mem_forwarding_out2), .mem_wb_forwarding_out2(mem_wb_forwarding_out2),
                   .forwarding_load1(forwarding_load1), .forwarding_load2(forwarding_load2),
                   .forwarding_mux1(forwarding_mux1), .forwarding_mux2(forwarding_mux2));
assign alumux2_sel = (ID_EX_o.ControlWord.opcode == op_reg) ? 1'b1 : 1'b0;
always_comb begin : EX_comb
    // Pass the pipeline data
    EX_MEM_i.ControlWord.load_regfile = ID_EX_o.ControlWord.load_regfile;
    EX_MEM_i.ControlWord.regfilemux_sel = ID_EX_o.ControlWord.regfilemux_sel;
    EX_MEM_i.ControlWord.cmpmux_sel = ID_EX_o.ControlWord.cmpmux_sel;
    EX_MEM_i.ControlWord.alumux1_sel = ID_EX_o.ControlWord.alumux1_sel;
    EX_MEM_i.ControlWord.aluop = ID_EX_o.ControlWord.aluop;
    EX_MEM_i.ControlWord.cmpop = ID_EX_o.ControlWord.cmpop;
    EX_MEM_i.ControlWord.dmem_read = ID_EX_o.ControlWord.dmem_read;
    EX_MEM_i.ControlWord.dmem_write = ID_EX_o.ControlWord.dmem_write;
    EX_MEM_i.ControlWord.opcode = ID_EX_o.ControlWord.opcode;
    EX_MEM_i.ControlWord.funct3 = ID_EX_o.ControlWord.funct3;
    EX_MEM_i.ControlWord.br_en = br_en_temp && (ID_EX_o.ControlWord.opcode == 7'b1100011);
    EX_MEM_i.DataWord.pc = ID_EX_o.DataWord.pc; 
    EX_MEM_i.DataWord.rs1 = ID_EX_o.DataWord.rs1;
    EX_MEM_i.DataWord.rs2 = ID_EX_o.DataWord.rs2;  
    EX_MEM_i.DataWord.rd = ID_EX_o.DataWord.rd; 
    EX_MEM_i.DataWord.rs1_out = ID_EX_o.DataWord.rs1_out;
    EX_MEM_i.DataWord.rs2_out = ID_EX_o.DataWord.rs2_out;
    EX_MEM_i.DataWord.imm = ID_EX_o.DataWord.imm;  
    EX_MEM_i.DataWord.data_mdr = ID_EX_o.DataWord.data_mdr; 
    // Calculate the mem_byte_enable to use in the mem stage to write to memory (store)
    case(store_funct3_t'(ID_EX_o.ControlWord.funct3))
        sw: EX_MEM_i.ControlWord.mem_byte_enable = 4'b1111;
        sh: EX_MEM_i.ControlWord.mem_byte_enable = 4'b0011 << EX_MEM_i.DataWord.alu_out[1:0];
        sb: EX_MEM_i.ControlWord.mem_byte_enable = 4'b0001 << EX_MEM_i.DataWord.alu_out[1:0];
        default: EX_MEM_i.ControlWord.mem_byte_enable = 4'b1111; 
    endcase 
    // alumux1
    unique case({forwarding_mux1, forwarding_load1, ID_EX_o.ControlWord.alumux1_sel}) 
        3'b000: alumux1_out = ID_EX_o.DataWord.rs1_out;
        3'b001: alumux1_out = ID_EX_o.DataWord.pc;
        3'b010: alumux1_out = ex_mem_forwarding_out1;  
        3'b011: alumux1_out = ex_mem_forwarding_out1;
        3'b100: alumux1_out = 32'h391BAD;
        3'b101: alumux1_out = 32'h391BAD;
        3'b110: alumux1_out = mem_wb_forwarding_out1;
        3'b111: alumux1_out = mem_wb_forwarding_out1;
    endcase
    // alumux2
    unique case({forwarding_mux2, forwarding_load2, alumux2_sel}) 
        3'b000: alumux2_out = ID_EX_o.DataWord.imm;
        3'b001: alumux2_out = ID_EX_o.DataWord.rs2_out;
        3'b010: alumux2_out = 32'h391BAD;
        3'b011: alumux2_out = ex_mem_forwarding_out2;
        3'b100: alumux2_out = ID_EX_o.DataWord.imm;
        3'b101: alumux2_out = ID_EX_o.DataWord.rs2_out;
        3'b110: alumux2_out = 32'h391BAD;
        3'b111: alumux2_out = mem_wb_forwarding_out2;
    endcase  
    // cmpmux
    unique case(ID_EX_o.ControlWord.cmpmux_sel)
        cmpmux::rs2_out: cmpmux_out = ID_EX_o.DataWord.rs2_out; 
        cmpmux::i_imm: cmpmux_out = ID_EX_o.DataWord.imm; 
    endcase     
end : EX_comb

/********************************************************EX_MEM*******************************************************/
pipeline_stage EX_MEM_stage(.clk(clk), .rst(rst_EX_MEM), .load(load_EX_MEM), .stage_i(EX_MEM_i), .stage_o(EX_MEM_o));
/*********************************************************************************************************************/

/**********************************************************MEM********************************************************/
// interface with data memory 
assign data_read_dp = EX_MEM_o.ControlWord.dmem_read;
assign data_write_dp = EX_MEM_o.ControlWord.dmem_write;  
assign data_mbe_dp = EX_MEM_o.ControlWord.mem_byte_enable;
assign data_addr_dp = {EX_MEM_o.DataWord.alu_out[31:2], 2'b00};  
assign data_wdata_dp = EX_MEM_o.DataWord.rs2_out; 
always_comb begin : MEM_comb
    // Pass the pipeline data
    MEM_WB_i.ControlWord.load_regfile = EX_MEM_o.ControlWord.load_regfile;
    MEM_WB_i.ControlWord.regfilemux_sel = EX_MEM_o.ControlWord.regfilemux_sel;
    MEM_WB_i.ControlWord.cmpmux_sel = EX_MEM_o.ControlWord.cmpmux_sel;
    MEM_WB_i.ControlWord.alumux1_sel = EX_MEM_o.ControlWord.alumux1_sel;
    MEM_WB_i.ControlWord.aluop = EX_MEM_o.ControlWord.aluop;
    MEM_WB_i.ControlWord.cmpop = EX_MEM_o.ControlWord.cmpop;
    MEM_WB_i.ControlWord.dmem_read = EX_MEM_o.ControlWord.dmem_read;
    MEM_WB_i.ControlWord.dmem_write = EX_MEM_o.ControlWord.dmem_write;
    MEM_WB_i.ControlWord.mem_byte_enable = EX_MEM_o.ControlWord.mem_byte_enable;
    MEM_WB_i.ControlWord.opcode = EX_MEM_o.ControlWord.opcode;
    MEM_WB_i.ControlWord.funct3 = EX_MEM_o.ControlWord.funct3;
    MEM_WB_i.ControlWord.br_en = EX_MEM_o.ControlWord.br_en;
    MEM_WB_i.DataWord.pc = EX_MEM_o.DataWord.pc; 
    MEM_WB_i.DataWord.rs1 = EX_MEM_o.DataWord.rs1;
    MEM_WB_i.DataWord.rs2 = EX_MEM_o.DataWord.rs2;  
    MEM_WB_i.DataWord.rd = EX_MEM_o.DataWord.rd; 
    MEM_WB_i.DataWord.rs1_out = EX_MEM_o.DataWord.rs1_out;
    MEM_WB_i.DataWord.rs2_out = EX_MEM_o.DataWord.rs2_out;
    MEM_WB_i.DataWord.alu_out = EX_MEM_o.DataWord.alu_out;
    MEM_WB_i.DataWord.imm = EX_MEM_o.DataWord.imm;  
    MEM_WB_i.DataWord.data_mdr = data_rdata_dp; 
end : MEM_comb
/*********************************************************************************************************************/

/********************************************************MEM_WB*******************************************************/
pipeline_stage MEM_WB_stage(.clk(clk), .rst(rst_MEM_WB), .load(load_MEM_WB), .stage_i(MEM_WB_i), .stage_o(MEM_WB_o));
/*********************************************************************************************************************/
endmodule : datapath 