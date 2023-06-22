module cla_04(
    input [3:0] src1,
    input [3:0] src2,
    input sub_flag,
    output [3:0] sum,
    output carry_out
);
    reg [3:0] src2_reg;

    reg [3:0] gen; //Generation
    reg [3:0] pro; //Propagation
    wire [3:0] carry;

    //Carry Look-Ahead Block BEGIN
    always @(*) src2_reg = sub_flag ? ~src2 : src2; //1's compliment or not
    always @(*) gen = src1 & src2_reg;  //gernation
    always @(*) pro = src1 ^ src2_reg;  //propagation

    assign carry[0] = gen[0] | pro[0] & sub_flag;
    assign carry[1] = gen[1] | pro[1] & carry[0];
    assign carry[2] = gen[2] | pro[2] & carry[1];
    assign carry[3] = gen[3] | pro[3] & carry[2];
    assign carry_out = carry[3];
    //Carry Look-Ahead Block END

    fa fa_00(
        .src1       (src1[0]),
        .src2       (src2_reg[0]),
        .carry_in   (sub_flag),
        .sum        (sum[0]),
        .carry_out  ()   
    );

    fa fa_01(
        .src1       (src1[0]),
        .src2       (src2_reg[0]),
        .carry_in   (carry[0]),
        .sum        (sum[0]),
        .carry_out  ()   
    );

    fa fa_02(
        .src1       (src1[0]),
        .src2       (src2_reg[0]),
        .carry_in   (carry[1]),
        .sum        (sum[0]),
        .carry_out  ()   
    );

    fa fa_03(
        .src1       (src1[0]),
        .src2       (src2_reg[0]),
        .carry_in   (carry[2]),
        .sum        (sum[0]),
        .carry_out  ()   
    );
endmodule