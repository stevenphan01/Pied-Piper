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
    if (rst)
    begin
        ctrl_data <= '0;
        data_data <= '0;
    end
    else if (load)
    begin
        ctrl_data <= stage_ctrl_i;
        data_data <= stage_data_i;
    end
    else
    begin
        ctrl_data <= ctrl_data;
        data_data <= data_data;
    end
end

always_comb
begin
    stage_ctrl_o = ctrl_data;
    stage_data_o = data_data; 
end

endmodule : pipeline_stage