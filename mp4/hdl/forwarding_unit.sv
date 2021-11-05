import rv32i_types::*; 

module forwarding_unit (
    input rv32i_reg dest_ex_mem,
    input rv32i_reg dest_mem_wb,
    input rv32i_reg src1,
    input rv32i_reg src2,
    input rv32i_word data_ex_mem,
    input rv32i_word data_mem_wb,
    input logic ld_regfile_ex_mem,
    input logic ld_regfile_mem_wb,
    input logic alumux1_sel,
    input logic alumux2_sel,
    output rv32i_word ex_mem_forwarding_out1,
    output rv32i_word mem_wb_forwarding_out1,
    output rv32i_word ex_mem_forwarding_out2,
    output rv32i_word mem_wb_forwarding_out2,
    output logic forwarding_load1,
    output logic forwarding_load2,
    output logic forwarding_mux1,
    output logic forwarding_mux2
);

function void set_defaults();
    // default (no forwarding required)
    forwarding_load1 = 1'b0;
    forwarding_load2 = 1'b0;
    forwarding_mux1 = 1'b0;
    forwarding_mux2 = 1'b0;
    ex_mem_forwarding_out1 = 0;
    mem_wb_forwarding_out1 = 0;
    ex_mem_forwarding_out2 = 0;
    mem_wb_forwarding_out2 = 0;
endfunction

always_comb begin
    set_defaults();
    case({ld_regfile_ex_mem, ld_regfile_mem_wb})
        2'b00:;
        2'b01: begin
            if(dest_mem_wb == src1 && alumux1_sel == 1'b0) begin
                if(src1 == 0) begin
                    ex_mem_forwarding_out1 = 32'd0;
                    mem_wb_forwarding_out1 = 32'd0;
                    forwarding_load1 = 1'b1;
                end
                else begin
                    mem_wb_forwarding_out1 = data_mem_wb;
                    forwarding_load1 = 1'b1;
                end
                forwarding_mux1 = 1'b1;
            end
            if(dest_mem_wb == src2 && alumux2_sel == 1'b1) begin
                if(src2 == 0) begin
                    ex_mem_forwarding_out2 = 32'd0;
                    mem_wb_forwarding_out2 = 32'd0;
                    forwarding_load2 = 1'b1;
                end
                else begin
                    mem_wb_forwarding_out2 = data_mem_wb;
                    forwarding_load2 = 1'b1;
                end
                forwarding_mux2 = 1'b1;
            end
        end
        2'b10: begin
            if(dest_ex_mem == src1 && alumux1_sel == 1'b0) begin
                if(src1 == 0) begin
                    ex_mem_forwarding_out1 = 32'd0;
                    mem_wb_forwarding_out1 = 32'd0;
                    forwarding_load1 = 1'b1;
                end
                else begin
                    ex_mem_forwarding_out1 = data_ex_mem;
                    forwarding_load1 = 1'b1;
                end
                forwarding_mux1 = 1'b0;
            end
            if(dest_ex_mem == src2 && alumux2_sel == 1'b1) begin
                if(src2 == 0) begin
                    ex_mem_forwarding_out2 = 32'd0;
                    mem_wb_forwarding_out2 = 32'd0;
                    forwarding_load2 = 1'b1;
                end
                else begin
                    ex_mem_forwarding_out2 = data_ex_mem;
                    forwarding_load2 = 1'b1;
                end
                forwarding_mux2 = 1'b0;
            end
        end 
        2'b11: begin
            if(dest_mem_wb == dest_ex_mem) begin
                if(dest_ex_mem == src1 && alumux1_sel == 1'b0) begin
                    if(src1 == 0) begin
                        ex_mem_forwarding_out1 = 32'd0;
                        mem_wb_forwarding_out1 = 32'd0;
                        forwarding_load1 = 1'b1;
                    end
                    else begin
                        ex_mem_forwarding_out1 = data_ex_mem;
                        forwarding_load1 = 1'b1;
                    end
                    forwarding_mux1 = 1'b0;
                end
                if(dest_ex_mem == src2 && alumux2_sel == 1'b1) begin
                    if(src2 == 0) begin
                        ex_mem_forwarding_out2 = 32'd0;
                        mem_wb_forwarding_out2 = 32'd0;
                        forwarding_load2 = 1'b1;
                    end
                    else begin
                        ex_mem_forwarding_out2 = data_ex_mem;
                        forwarding_load2 = 1'b1;
                    end
                    forwarding_mux2 = 1'b0;
                end
            end
            else begin
                if(dest_mem_wb == src1 && alumux1_sel == 1'b0) begin
                    if(src1 == 0) begin
                        ex_mem_forwarding_out1 = 32'd0;
                        mem_wb_forwarding_out1 = 32'd0;
                        forwarding_load1 = 1'b1;
                    end
                    else begin
                        mem_wb_forwarding_out1 = data_mem_wb;
                        forwarding_load1 = 1'b1;
                    end
                    forwarding_mux1 = 1'b1;
                end
                if(dest_mem_wb == src2 && alumux2_sel == 1'b1) begin
                    if(src2 == 0) begin
                        ex_mem_forwarding_out2 = 32'd0;
                        mem_wb_forwarding_out2 = 32'd0;
                        forwarding_load2 = 1'b1;
                    end
                    else begin
                        mem_wb_forwarding_out2 = data_mem_wb;
                        forwarding_load2 = 1'b1;
                    end
                    forwarding_mux2 = 1'b1;
                end
                if(dest_ex_mem == src1 && alumux1_sel == 1'b0) begin
                    if(src1 == 0) begin
                        ex_mem_forwarding_out1 = 32'd0;
                        mem_wb_forwarding_out1 = 32'd0;
                        forwarding_load1 = 1'b1;
                    end
                    else begin
                        ex_mem_forwarding_out1 = data_ex_mem;
                        forwarding_load1 = 1'b1;
                    end
                    forwarding_mux1 = 1'b0;
                end
                if(dest_ex_mem == src2 && alumux2_sel == 1'b1) begin
                    if(src2 == 0) begin
                        ex_mem_forwarding_out2 = 32'd0;
                        mem_wb_forwarding_out2 = 32'd0;
                        forwarding_load2 = 1'b1;
                    end
                    else begin
                        ex_mem_forwarding_out2 = data_ex_mem;
                        forwarding_load2 = 1'b1;
                    end
                    forwarding_mux2 = 1'b0;
                end
            end
        end
    endcase
end
endmodule : forwarding_unit