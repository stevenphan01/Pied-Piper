module cache_datapath #(
  parameter s_offset = 5,
  parameter s_index = 3,
  parameter s_tag = 32 - s_offset - s_index,
  parameter s_mask = 2**s_offset,
  parameter s_line = 8*s_mask,
  parameter num_sets = 2**s_index
)(
  input clk,

  /* CPU memory data signals */
  input logic  [31:0]  mem_byte_enable,
  input logic  [31:0]  mem_address,
  input logic  [s_line - 1:0] mem_wdata,
  output logic [s_line - 1:0] mem_rdata,

  /* Physical memory data signals */
  input  logic [s_line - 1:0] pmem_rdata,
  output logic [s_line - 1:0] pmem_wdata,
  output logic [31:0]  pmem_address,

  /* Control signals */
  input logic [1:0] tag_load,
  input logic [1:0] valid_load,
  input logic [1:0] dirty_load,
  input logic lru_load,
  input logic [1:0] dirty_in,
  output logic [1:0] dirty_out,

  output logic hit,
  output logic [0:0] lru_out,
  output logic [1:0] way_hit,
  input logic [1:0] writing
);
logic [1:0] [s_line - 1:0] line_in, line_out;
logic [1:0] [s_tag - 1:0] tag_out;
logic [1:0] [s_tag - 1:0] address_tag;
logic [s_index - 1:0]  index;
logic [1:0] [31:0] mask;
logic [1:0] valid_out;
logic [0:0] lru_in;

always_comb begin

  line_in = 0;
  mem_rdata = 0;
  mask = 0;
  address_tag[0] = mem_address[31:s_offset + s_index];
  address_tag[1] = mem_address[31:s_offset + s_index];

  index = mem_address[s_offset+s_index - 1:s_offset];


  if((valid_out[1] && (tag_out[1] == address_tag[1])) ||
  (valid_out[0] && (tag_out[0] == address_tag[0])) )
    hit = 1'b1;
  else
    hit = 1'b0;

  if(valid_out[1] && (tag_out[1] == address_tag[1]))
    way_hit = 2'b10;
  else if(valid_out[0] && (tag_out[0] == address_tag[0]))
    way_hit = 2'b01;
  else
    way_hit = 2'b00;  

  if(way_hit[1]) begin 
    lru_in = 1'b0;
  end 
  else if (way_hit[0]) begin 
    lru_in = 1'b1;
  end 
  else
    lru_in = lru_out;

  case (lru_out)
    //MRU was a, replace b
    1'b0: begin
    pmem_wdata = line_out[0];
    pmem_address = (dirty_out[0]) ? {tag_out[0], mem_address[s_offset + s_index - 1:0]} : mem_address;
    end
    //MRU was b, replace a
    1'b1: begin
    pmem_wdata = line_out[1];
    pmem_address = (dirty_out[1]) ? {tag_out[1], mem_address[s_offset + s_index - 1:0]} : mem_address;
    end
  endcase
  //pmem_address = (dirty_out) ? {tag_out, mem_address[s_offset + s_index - 1:0]} : mem_address;
  
  case(way_hit)
    2'b01: begin
      mem_rdata = line_out[0];
    end
    2'b10: begin
      mem_rdata = line_out[1];
    end
	 default: ;
  endcase

  case(writing)
    2'b00: begin // load from memory
      case(lru_out)
      //MRU was a, replace b
      1'b0: begin 
        mask[0] = 32'hFFFFFFFF;
        line_in[0] = pmem_rdata;
      end
      //MRU was b, replace a
      1'b1: begin 
        mask[1] = 32'hFFFFFFFF;
        line_in[1] = pmem_rdata;
      end
      endcase
    end
    2'b01: begin // write from cpu
      case (way_hit)
      //Hit on B
      2'b01: begin 
        mask[0] = mem_byte_enable;
        line_in[0] = mem_wdata;
      end
      //Hit on A
      2'b10: begin 
        mask[1] = mem_byte_enable;
        line_in[1] = mem_wdata;
      end
      default: ;
      endcase
    end
    default:;
	endcase
end


data_array #(s_offset, s_index) DM_cache_A (clk, mask[1], index, index, line_in[1], line_out[1]);
array #(s_tag,s_index) tag_3 (clk, tag_load[1], index, index, address_tag[1], tag_out[1]);
array #(1,s_index) valid_3 (clk, valid_load[1], index, index, 1'b1, valid_out[1]);
array #(1,s_index) dirty_3 (clk, dirty_load[1], index, index, dirty_in[1], dirty_out[1]);

data_array #(s_offset, s_index) DM_cache_B (clk, mask[0], index, index, line_in[0], line_out[0]);
array #(s_tag,s_index) tag_4 (clk, tag_load[0], index, index, address_tag[0], tag_out[0]);
array #(1,s_index) valid_4 (clk, valid_load[0], index, index, 1'b1, valid_out[0]);
array #(1,s_index) dirty_4 (clk, dirty_load[0], index, index, dirty_in[0], dirty_out[0]);

array #(1,s_index) lru (clk, lru_load, index, index, lru_in, lru_out);

endmodule : cache_datapath
