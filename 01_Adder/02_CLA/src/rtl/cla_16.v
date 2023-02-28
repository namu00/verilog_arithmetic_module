module cla_16(
    input [15:0] src1,
    input [15:0] src2,
    input sub_flag,
    output [15:0] sum,
    output carry_out
);

    wire carry;

    cla_08 low_8bit(
        .src1       (src1[7:0]),
        .src2       (src2[7:0]),
        .sub_flag   (sub_flag),
        .sum        (sum[7:0]),
        .carry_out  (carry)
    );

    cla_08 high_8bit(
        .src1       (src1[15:8]),
        .src2       (src2[15:8]),
        .sub_flag   (carry),
        .sum        (sum[15:8]),
        .carry_out  (carry_out)
    );
endmodule