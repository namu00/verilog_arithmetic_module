module cla_04(
    input [3:0] src1,
    input [3:0] src2,
    input carry_in,
    input sub_flag,
    output [3:0] sum,
    output carry_out
);
    wire [3:0] _src2;

    wire [3:0] gen; //Generation
    wire [3:0] pro; //Propagation
    wire [3:0] carry;

    //Carry Look-Ahead Block BEGIN
    assign _src2 = sub_flag ? ~src2 : src2; //1's compliment or not
    assign gen = src1 & _src2;  //gernation
    assign pro = src1 ^ _src2;  //propagation

    assign carry[0] = gen[0] | pro[0] & carry_in;
    assign carry[1] = gen[1] | pro[1] & carry[0];
    assign carry[2] = gen[2] | pro[2] & carry[1];
    assign carry[3] = gen[3] | pro[3] & carry[2];
    assign carry_out = carry[3];
    //Carry Look-Ahead Block END

    fa fa_00(
        .src1       (src1[0]),
        .src2       (_src2[0]),
        .carry_in   (carry_in),
        .sum        (sum[0]),
        .carry_out  ()   
    );

    fa fa_01(
        .src1       (src1[1]),
        .src2       (_src2[1]),
        .carry_in   (carry[0]),
        .sum        (sum[1]),
        .carry_out  ()   
    );

    fa fa_02(
        .src1       (src1[2]),
        .src2       (_src2[2]),
        .carry_in   (carry[1]),
        .sum        (sum[2]),
        .carry_out  ()   
    );

    fa fa_03(
        .src1       (src1[3]),
        .src2       (_src2[3]),
        .carry_in   (carry[2]),
        .sum        (sum[3]),
        .carry_out  ()   
    );
endmodule