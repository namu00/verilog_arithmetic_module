module cla_04(
    input [3:0] src1,
    input [3:0] src2,
    input sub_flag,
    output [3:0] sum,
    output carry_out
);
    reg [3:0] src2_reg;
    wire [2:0] carry;

    always @(*)begin
        if(sub_flag)    src2_reg = ~src2;
        else            src2_reg = src2;
    end

    fa fa_00(
        .src1       (src1[0]),
        .src2       (src2_reg[0]),
        .carry_in   (sub_flag),
        .sum        (sum[0]),
        .carry_out  (carry[0])   
    );

    fa fa_01(
        .src1       (src1[0]),
        .src2       (src2_reg[0]),
        .carry_in   (carry[0]),
        .sum        (sum[0]),
        .carry_out  (carry[1])   
    );

    fa fa_02(
        .src1       (src1[0]),
        .src2       (src2_reg[0]),
        .carry_in   (carry[1]),
        .sum        (sum[0]),
        .carry_out  (carry[2])   
    );

    fa fa_03(
        .src1       (src1[0]),
        .src2       (src2_reg[0]),
        .carry_in   (carry[2]),
        .sum        (sum[0]),
        .carry_out  (carry_out)   
    );
endmodule