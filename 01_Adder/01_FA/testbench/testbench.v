module testbench();
    reg src1;
    reg src2;
    reg carry_in;
    wire sum;
    wire carry_out;

    fa fa_dut(
        .src1       (src1),
        .src2       (src2),
        .carry_in   (carry_in),
        .sum        (sum),
        .carry_out  (carry_out)
    );

    initial begin
        src1 = 0;
        src2 = 0;
        carry_in = 0;
        #10;

        src1 = 0;
        src2 = 1;
        carry_in = 0;
        #10;

        src1 = 1;
        src2 = 0;
        carry_in = 0;
        #10;

        src1 = 1;
        src2 = 1;
        carry_in = 0;
        #10;

        src1 = 0;
        src2 = 0;
        carry_in = 1;
        #10;

        src1 = 0;
        src2 = 1;
        carry_in = 1;
        #10;

        src1 = 1;
        src2 = 0;
        carry_in = 1;
        #10;

        src1 = 1;
        src2 = 1;
        carry_in = 1;
        #10;

        $stop;
    end
endmodule