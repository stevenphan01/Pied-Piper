import rv32i_types::*; 

module pipeline_stage (
    input clk, 
    input rst, 
    input load, 
    input rv32i_control_word stage_ctrl_i, 
    input rv32i_data_word stage_data_i,
    output rv32i_control_word stage_ctrl_o,
    output rv32i_data_word stage_data_o
);

rv32i_control_word ctrl_data = 0;
rv32i_data_word data_data = 0; 

always_ff @(posedge clk)
begin
    if (rst) begin
        ctrl_data.load_regfile <= 1'b0;
        ctrl_data.regfilemux_sel <= regfilemux::alu_out; 
        ctrl_data.cmpmux_sel <= cmpmux::rs2_out; 
        ctrl_data.alumux1_sel <= alumux::rs1_out; 
        ctrl_data.modmux_sel <= modmux::alu_out; 
        ctrl_data.cmpop <= beq; 
        ctrl_data.aluop <= alu_add; 
        ctrl_data.dmem_read <= 1'b0;
        ctrl_data.dmem_write <= 1'b0; 
        ctrl_data.mem_byte_enable <= 4'b1111; 
        ctrl_data.opcode <= rv32i_opcode'(7'd0); 
        ctrl_data.funct3 <= 3'd0; 
        ctrl_data.br_en <= 1'b0; 
        data_data.pc <= 32'd0; 
        data_data.rs1 <= 5'd0; 
        data_data.rs2 <= 5'd0; 
        data_data.rd <= 5'd0; 
        data_data.rs1_out <= 32'd0; 
        data_data.rs2_out <= 32'd0;
        data_data.alu_out <= 32'd0; 
        data_data.imm <= 32'd0;
        data_data.data_mdr <= 32'd0;
    end
    else if (load) begin
        ctrl_data.load_regfile <= stage_ctrl_i.load_regfile;
        ctrl_data.regfilemux_sel <= stage_ctrl_i.regfilemux_sel; 
        ctrl_data.cmpmux_sel <= stage_ctrl_i.cmpmux_sel; 
        ctrl_data.alumux1_sel <= stage_ctrl_i.alumux1_sel; 
        ctrl_data.modmux_sel <= stage_ctrl_i.modmux_sel; 
        ctrl_data.cmpop <= stage_ctrl_i.cmpop; 
        ctrl_data.aluop <= stage_ctrl_i.aluop; 
        ctrl_data.dmem_read <= stage_ctrl_i.dmem_read;
        ctrl_data.dmem_write <= stage_ctrl_i.dmem_write; 
        ctrl_data.mem_byte_enable <= stage_ctrl_i.mem_byte_enable; 
        ctrl_data.opcode <= stage_ctrl_i.opcode; 
        ctrl_data.funct3 <= stage_ctrl_i.funct3; 
        ctrl_data.br_en <= stage_ctrl_i.br_en; 
        data_data.pc <= stage_data_i.pc; 
        data_data.rs1 <= stage_data_i.rs1; 
        data_data.rs2 <= stage_data_i.rs2; 
        data_data.rd <= stage_data_i.rd; 
        data_data.rs1_out <= stage_data_i.rs1_out; 
        data_data.rs2_out <= stage_data_i.rs2_out;
        data_data.alu_out <= stage_data_i.alu_out; 
        data_data.imm <= stage_data_i.imm;
        data_data.data_mdr <= stage_data_i.data_mdr;
    end
    else begin
        ctrl_data.load_regfile <= ctrl_data.load_regfile;
        ctrl_data.regfilemux_sel <= ctrl_data.regfilemux_sel; 
        ctrl_data.cmpmux_sel <= ctrl_data.cmpmux_sel; 
        ctrl_data.alumux1_sel <= ctrl_data.alumux1_sel; 
        ctrl_data.modmux_sel <= ctrl_data.modmux_sel; 
        ctrl_data.cmpop <= ctrl_data.cmpop; 
        ctrl_data.aluop <= ctrl_data.aluop; 
        ctrl_data.dmem_read <= ctrl_data.dmem_read;
        ctrl_data.dmem_write <= ctrl_data.dmem_write; 
        ctrl_data.mem_byte_enable <= ctrl_data.mem_byte_enable; 
        ctrl_data.opcode <= ctrl_data.opcode; 
        ctrl_data.funct3 <= ctrl_data.funct3; 
        ctrl_data.br_en <= ctrl_data.br_en; 
        data_data.pc <= data_data.pc; 
        data_data.rs1 <= data_data.rs1; 
        data_data.rs2 <= data_data.rs2; 
        data_data.rd <= data_data.rd; 
        data_data.rs1_out <= data_data.rs1_out; 
        data_data.rs2_out <= data_data.rs2_out;
        data_data.alu_out <= data_data.alu_out; 
        data_data.imm <= data_data.imm;
        data_data.data_mdr <= data_data.data_mdr;
    end
end

always_comb
begin
    stage_ctrl_o.load_regfile = ctrl_data.load_regfile;
    stage_ctrl_o.regfilemux_sel = ctrl_data.regfilemux_sel; 
    stage_ctrl_o.cmpmux_sel = ctrl_data.cmpmux_sel; 
    stage_ctrl_o.alumux1_sel = ctrl_data.alumux1_sel; 
    stage_ctrl_o.modmux_sel = ctrl_data.modmux_sel; 
    stage_ctrl_o.cmpop = ctrl_data.cmpop; 
    stage_ctrl_o.aluop = ctrl_data.aluop; 
    stage_ctrl_o.dmem_read = ctrl_data.dmem_read;
    stage_ctrl_o.dmem_write = ctrl_data.dmem_write; 
    stage_ctrl_o.mem_byte_enable = ctrl_data.mem_byte_enable; 
    stage_ctrl_o.opcode = ctrl_data.opcode; 
    stage_ctrl_o.funct3 = ctrl_data.funct3; 
    stage_ctrl_o.br_en = ctrl_data.br_en; 
    stage_data_o.pc = data_data.pc; 
    stage_data_o.rs1 = data_data.rs1; 
    stage_data_o.rs2 = data_data.rs2; 
    stage_data_o.rd = data_data.rd; 
    stage_data_o.rs1_out = data_data.rs1_out; 
    stage_data_o.rs2_out = data_data.rs2_out;
    stage_data_o.alu_out = data_data.alu_out; 
    stage_data_o.imm = data_data.imm;
    stage_data_o.data_mdr = data_data.data_mdr; 
end

endmodule : pipeline_stage