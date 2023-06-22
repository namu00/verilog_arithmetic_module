module ha(
    input src1,
    input src2,
    output sum,
    output carry
);
    assign sum = src1 ^ src2;
    assign carry = src1 & src2;
endmodule