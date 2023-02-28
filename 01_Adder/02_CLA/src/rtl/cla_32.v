module cla_32(
    input [31:0] src1,
    input [31:0] src2,
    input sub_flag,
    output [31:0] sum,
    output carry_out
);

    wire carry;

    cla_16 low_16bit(
        .src1       (src1[15:0]),
        .src2       (src2[15:0]),
        .sub_flag   (sub_flag),
        .sum        (sum[15:0]),
        .carry_out  (carry)
    );

    cla_16 high_16bit(
        .src1       (src1[31:16]),
        .src2       (src2[31:16]),
        .sub_flag   (carry),
        .sum        (sum[31:16]),
        .carry_out  (carry_out)
    );
endmodule