module fa(
    input src1,
    input src2,
    input carry_in,
    output sum,
    output carry_out
);

    assign sum = ((src1 ^ src2) ^ carry_in);
    assign carry_out = (src1 & src2) | (src2 & carry_in) | (carry_in & src1);
endmodule