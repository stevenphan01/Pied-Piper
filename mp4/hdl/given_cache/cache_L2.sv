module cache_L2 #(
  parameter s_offset = 5,
  parameter s_index = 3,
  parameter s_tag = 32 - s_offset - s_index,
  parameter s_mask = 2**s_offset,
  parameter s_line = 8*s_mask,
  parameter num_sets = 2**s_index
)(
  input clk,

  /* Physical memory signals */
  input logic pmem_resp,
  input logic [s_line - 1:0] pmem_rdata,
  output logic [31:0] pmem_address,
  output logic [s_line-1:0] pmem_wdata,
  output logic pmem_read,
  output logic pmem_write,

  /* CPU memory signals */
  input logic mem_read,
  input logic mem_write,
  input logic [3:0] mem_byte_enable_cpu,
  input logic [31:0] mem_address,
  input logic [s_line -1 :0] mem_wdata,
  output logic mem_resp,
  output logic [s_line -1 :0] mem_rdata
);

logic tag_load;
logic valid_load;
logic dirty_load;
logic dirty_in;
logic dirty_out;

logic hit;
logic [1:0] writing;

logic [31:0] mem_byte_enable;

assign mem_byte_enable = 32'hFFFFFFFF;

cache_control control(.*);
cache_datapath #(s_offset,s_index) datapath(.*);


endmodule : cache_L2
