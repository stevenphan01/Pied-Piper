module muldiv
(
    input logic [2:0] muldivop,
    input logic [31:0] a,
    input logic [31:0] b,
    output logic [31:0] result
);

always_comb
begin
    if(muldivop == 3'b111)
        result = a || b;
    else
        result = 0;
end

endmodule : muldiv