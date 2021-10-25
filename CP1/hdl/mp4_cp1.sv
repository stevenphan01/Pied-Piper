import rv32i_types::*; 
module mp4 (
    /* Instruction memory interface */ 
    input  inst_resp,
    input  rv32i_word inst_rdata, 
    output inst_read, 
    output rv32i_word inst_addr, 
    /* Data memory interface */
    input data_resp, 
    input rv32i_word data_rdata, 
    output data_read,
    output data_write, 
    output [3:0] data_mbe, 
    output rv32i_word data_addr, 
    output rv32i_word data_wdata
);
/* Signals needed for RVFI Monitor */

/* Declare Datapath */
datapath datapath(.*);

endmodule : mp4
