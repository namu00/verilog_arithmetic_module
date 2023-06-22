module rca_08(
    input [7:0] src1,
    input [7:0] src2,
    input sub_flag,
    output [7:0] sum,
    output carry_out
);

    wire carry;

    rca_04 low_4bit(
        .src1       (src1[3:0]),
        .src2       (src2[3:0]),
        .sub_flag   (sub_flag),
        .sum        (sum[3:0]),
        .carry_out  (carry)
    );

    rca_04 high_4bit(
        .src1       (src1[7:4]),
        .src2       (src2[7:4]),
        .sub_flag   (carry),
        .sum        (sum[7:4]),
        .carry_out  (carry_out)
    );
endmodule