import rv32i_types::*; 
module mp4 (
    input clk, 
    input rst,
    input  logic mem_resp,
    input  rv32i_word mem_rdata,
    output logic mem_read,
    output logic mem_write,
    output rv32i_word mem_addr,
    output rv32i_word mem_wdata
    // FOR CHECKPOINT 2
    /* Instruction memory interface */ 
    // input  inst_resp,
    // input  rv32i_word inst_rdata, 
    // output inst_read, 
    // output rv32i_word inst_addr, 
    /* Data memory interface */
    // input data_resp, 
    // input rv32i_word data_rdata, 
    // output data_read,
    // output data_write, 
    // output [3:0] data_mbe, 
    // output rv32i_word data_addr, 
    // output rv32i_word data_wdata
);
/* Signals needed for RVFI Monitor */

/* Declare Datapath */
datapath datapath(.*);

endmodule : mp4
