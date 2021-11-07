import rv32i_types::*; 
module mp4 (
    input clk,
    input rst,
    input logic [63:0] mem_rdata, 
    input logic mem_resp, 
    output logic [63:0] mem_wdata, 
    output logic mem_write, 
    output logic mem_read, 
    output rv32i_word mem_addr
);
/* Signals needed for RVFI Monitor */

/* From and to the datapath */
// inst cache 
logic inst_resp_dp;
rv32i_word inst_rdata_dp;
logic inst_read_dp;
rv32i_word inst_addr_dp;
// data cache
logic data_resp_dp;
rv32i_word data_rdata_dp;
logic data_read_dp;
logic data_write_dp; 
logic [3:0] data_mbe_dp; 
rv32i_word data_addr_dp;
rv32i_word data_wdata_dp;

/* Between arbiter and instr cache */
rv32i_word inst_pmem_address; 
logic inst_pmem_read;
logic inst_pmem_resp; 
rv32i_line inst_pmem_rdata; 

/* Between arbiter and data cache */
rv32i_word data_pmem_address; 
logic data_pmem_read;
logic data_pmem_write;
rv32i_line data_pmem_wdata;
logic data_pmem_resp;
rv32i_line data_pmem_rdata; 

/* Declare Datapath */
datapath datapath(.*);
arbiter arbiter (
    .clk(clk),
    .rst(rst),
    .inst_pmem_address(inst_pmem_address),
    .inst_pmem_read(inst_pmem_read), 
    .inst_pmem_rdata(inst_pmem_rdata), 
    .inst_pmem_resp(inst_pmem_resp),
    .data_pmem_address(data_pmem_address),
    .data_pmem_read(data_pmem_read), 
    .data_pmem_write(data_pmem_write),
    .data_pmem_wdata(data_pmem_wdata), 
    .data_pmem_rdata(data_pmem_rdata), 
    .data_pmem_resp(data_pmem_resp),
    .pmem_rdata(mem_rdata), 
    .pmem_resp(mem_resp),
    .pmem_write(mem_write),
    .pmem_read(mem_read),
    .pmem_wdata(mem_wdata), 
    .pmem_addr(mem_addr)
);

cache instr_cache(
  .clk(clk),
  .pmem_resp(inst_pmem_resp),
  .pmem_rdata(inst_pmem_rdata),
  .pmem_wdata(),
  .pmem_address(inst_pmem_address),
  .pmem_read(inst_pmem_read),
  .pmem_write(),
  .mem_read(inst_read_dp),
  .mem_write(1'b0),
  .mem_byte_enable_cpu(4'b0000),
  .mem_address(inst_addr_dp),
  .mem_wdata_cpu(32'd0),
  .mem_resp(inst_resp_dp),
  .mem_rdata_cpu(inst_rdata_dp)
);

cache data_cache (
  .clk(clk),
  .pmem_resp(data_pmem_resp),
  .pmem_rdata(data_pmem_rdata),
  .pmem_address(data_pmem_address),
  .pmem_wdata(data_pmem_wdata),
  .pmem_read(data_pmem_read),
  .pmem_write(data_pmem_write),
  .mem_read(data_read_dp),
  .mem_write(data_write_dp),
  .mem_byte_enable_cpu(data_mbe_dp),
  .mem_address(data_addr_dp),
  .mem_wdata_cpu(data_wdata_dp),
  .mem_resp(data_resp_dp),
  .mem_rdata_cpu(data_rdata_dp)
);

endmodule : mp4
