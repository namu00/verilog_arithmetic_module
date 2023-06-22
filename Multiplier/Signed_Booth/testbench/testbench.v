module testbench;
    reg clk;
    reg n_rst;

    reg start;
    reg [31:0] src1;
    reg [31:0] src2;

    wire [63:0] product;
    wire done;

    s_mul32 uut_s_mul32(
        .clk (clk),
        .n_rst (n_rst),

        .start (start),
        .src1 (src1),
        .src2 (src2),

        .product (product),
        .done (done)
    );

    initial begin
        clk = 1'b0;
        n_rst = 1'b0;
        #7 n_rst = 1'b1;
    end

    always #5 clk = ~clk;

    task verify;
        input [31:0] a;
        input [31:0] b;
    begin
        $display("src1: %x", a);
        $display("src2: %x", b);
        $display("answer: %x", a * b);

        src1 = a;
        src2 = b;
        start = 1'b1;

        @(posedge clk);
        start = 1'b0;

        while(!done) begin
            @(posedge clk);
        end
        $display("----------------------");
        $display("result: %x", product[31:0]);

        if(product[31:0] == (a*b))
            $display("\tPASSED");

        else begin
            $display("\tFAILED");
            repeat(10) @(posedge clk);
            $stop;
        end

        repeat(30) @(posedge clk);
    end
    endtask
    

    integer i;
    initial begin
        wait(n_rst);
        @(posedge clk);
        
        $display("TEST 1. 30 * 40\n");
        verify(30,40);

        $display("TEST 2. -30 * 40\n");
        verify(-30,40);

        $display("TEST 3. Random Test\n");
        for(i = 1; i <= 100; i = i + 1)begin
            $display("TESTCOUNT: %1d\n",i);
            verify($urandom()%32, $urandom()%32);
        end

        $display("\t###### ALL TEST PASSED #####");
        $stop;
    end
endmodule
