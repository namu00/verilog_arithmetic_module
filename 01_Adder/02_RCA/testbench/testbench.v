module testbench();
    reg [31:0] src1;
    reg [31:0] src2;
    reg sub_flag;
    wire [31:0] sum;
    wire carry_out;

    rca_32 rca_32_dut(
        .src1       (src1),
        .src2       (src2),
        .sub_flag   (sub_flag),
        .sum        (sum),
        .carry_out  (carry_out)
    );


    task calculation;
        input s_flag;
        begin
            sub_flag = s_flag; 
            src1 = $random() % 32'hffff_ffff;
            src2 = $random() % 32'hffff_ffff;

            if(s_flag) begin
                if(sum != (src1 - src2)) begin
                    $display("Subtraction faild");
                    $stop;
                end

                else ;
            end

            else begin
                if(sum != (src1 + src2)) begin
                    $display("Addition faild");
                    $stop;
                end

                else ;
            end
        end
    endtask

    integer test_cnt;
    initial begin
        for(test_cnt = 0; test_cnt <= 100; test_cnt = test_cnt + 1) begin
            calculation(0);
        end

        for(test_cnt = 0; test_cnt <= 100; test_cnt = test_cnt + 1) begin
            calculation(1);
        end
        $display("\t##### TEST PASSED #####");
        $stop;
    end

endmodule
