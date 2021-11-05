import rv32i_types::*; 

module hazard_detection_unit (
    input logic dmem_read, 
    input logic data_resp_dp,
    input logic inst_resp_dp,
    input rv32i_reg dest, 
    input rv32i_reg src1,
    input rv32i_reg src2, 
    input logic br_en, 
    input logic jump_en,
    output logic inst_read,
    output logic rst_IF_ID, 
    output logic rst_ID_EX,
    output logic rst_EX_MEM, 
    output logic rst_MEM_WB,
    output logic load_IF_ID, 
    output logic load_ID_EX, 
    output logic load_EX_MEM,
    output logic load_MEM_WB,
    output logic load_pc
);
function void set_defaults(); 
    // default (no stall/no no-ops)
    rst_IF_ID = 1'b0; 
    rst_ID_EX = 1'b0; 
    rst_EX_MEM = 1'b0;
    rst_MEM_WB = 1'b0;  
    load_IF_ID = 1'b1; 
    load_ID_EX = 1'b1; 
    load_EX_MEM = 1'b1;
    load_MEM_WB = 1'b1; 
    load_pc = 1'b1; 
    inst_read = 1'b1; 
endfunction

always_comb begin 
    set_defaults();
    case({dmem_read, data_resp_dp})
        2'b00:;
        2'b01:;
        2'b10: begin 
            load_pc = 1'b0; 
            inst_read = 1'b0; 
            load_IF_ID = 1'b0; 
            load_ID_EX = 1'b0; 
            load_EX_MEM = 1'b0; 
            load_MEM_WB = 1'b0;
        end 
        2'b11: begin 
            if (dest == src1 || dest == src2) begin 
                load_pc = 1'b0; 
                inst_read = 1'b0; 
                rst_EX_MEM = 1'b1;
                load_IF_ID = 1'b0; 
                load_ID_EX = 1'b0; 
            end
        end 
    endcase 
    case({br_en || jump_en, inst_resp_dp})
        2'b00: begin 
            load_pc = 1'b0; 
            rst_IF_ID = 1'b1; 
        end 
        2'b01:;
        2'b10, 2'b11: begin
            rst_IF_ID = 1'b1; 
            rst_ID_EX = 1'b1;
        end
    endcase 
end 
endmodule : hazard_detection_unit