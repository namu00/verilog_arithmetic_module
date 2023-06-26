module cla_33(
    input [32:0] src1,
    input [32:0] src2,
    input sub_flag,
    output [32:0] sum,
    output carry_out
);
    wire carry;

    wire s2_msb;
    assign s2_msb = (sub_flag) ? ~src2[32] : src2[32];

    cla_32 u_cla_32(
        .src1       (src1[31:0]),
        .src2       (src2[31:0]),
        .sub_flag   (sub_flag),
        .sum        (sum[31:0]),
        .carry_out  (carry)
    );

    fa u_fa(
        .src1 (src1[32]),
        .src2 (s2_msb),
        .carry_in (carry),
        .sum (sum[32]),
        .carry_out(carry_out)
    );
endmodule