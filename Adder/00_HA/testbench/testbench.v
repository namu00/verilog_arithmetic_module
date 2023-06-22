module testbench();
    reg src1;
    reg src2;
    wire sum;
    wire carry;

    ha ha_dut(
        .src1   (src1),
        .src2   (src2),
        .sum    (sum),
        .carry  (carry)
    );

    initial begin
        //TESTCASE 1
        src1 = 0;
        src2 = 0;
        #10;

        //TESTCASE 2
        src1 = 0;
        src2 = 1;
        #10;

        //TESTCASE 3
        src1 = 1;
        src2 = 0;
        #10;

        //TESTCASE 4
        src1 = 1;
        src2 = 1;
        #10;
    end
endmodule