module testbench;
    reg clk;
    reg n_rst;

    reg start;
    reg [31:0] src1;
    reg [31:0] src2;

    wire [31:0] qut;
    wire [31:0] rmd;
    wire done;

    localparam CLK_PERIOD = 10;
    localparam CYCLE_HALF = CLK_PERIOD/2;

    div32 u_div32(
        .clk (clk),
        .n_rst (n_rst),
        .start (start),
        .src1 (src1),
        .src2 (src2),

        .qut (qut),
        .rmd (rmd),
        .done (done)
    );

    integer q_ans, r_ans;
    task div_test;
        input [31:0] s1;
        input [31:0] s2;
    begin
        q_ans = s1 / s2;
        r_ans = s1 % s2;

        $display("src1: %x", s1);
        $display("src2: %x", s2);
        $display("q_ans: %x, r_ans: %x", q_ans, r_ans);
        $display("---------------------------------------");

        start = 1'b1;
        src1 = s1;
        src2 = s2;
        @(posedge clk);

        start = 1'b0;
        @(posedge clk);

        while(!done) begin
            @(posedge clk);
        end
    
        $display("qut: %x, rmd: %x", qut, rmd);    
        if(qut == q_ans && rmd == r_ans)
            $display("Result: \tPASSED\n\n");
        else if(src2 == 32'h0)
            $display("Result: \tZero Division\n");
        else begin
            $display("Result: \tFAILED\n\n");
            $stop;
        end

        repeat(10) @(posedge clk);
    end
    endtask

    initial begin
        clk = 1'b0;
        n_rst = 1'b0;
        #7; n_rst = 1'b1;
    end

    always #(CYCLE_HALF) clk = ~clk;

    integer i;
    initial begin
        wait(n_rst);
        @(posedge clk);

        for(i = 1; i < 500; i = i + 1)begin
            div_test($urandom()%32, $urandom()%32);
        end

        $display("##### ALL TESTCASE PASSED #####");
        $stop;
    end
endmodule